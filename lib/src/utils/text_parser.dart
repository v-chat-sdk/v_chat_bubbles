import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import '../core/models.dart';
import '../widgets/shared/block_format_widgets.dart';
import 'pattern_presets.dart';

/// Represents a parsed content segment (either text spans or a block widget)
@immutable
class VParsedSegment {
  /// Inline spans for text content (null if this is a block widget)
  final List<InlineSpan>? spans;

  /// Block widget (null if this is inline text)
  final Widget? blockWidget;

  /// Whether this segment is a block-level element
  bool get isBlock => blockWidget != null;
  const VParsedSegment.inline(this.spans) : blockWidget = null;
  const VParsedSegment.block(this.blockWidget) : spans = null;
}

/// Configuration for block-level parsing
@immutable
class VBlockParseConfig {
  /// Enable code block parsing (```code```)
  final bool enableCodeBlocks;

  /// Enable blockquote parsing (> text)
  final bool enableBlockquotes;

  /// Enable bullet list parsing (- item or * item)
  final bool enableBulletLists;

  /// Enable numbered list parsing (1. item)
  final bool enableNumberedLists;

  /// Style configuration for block elements
  final VBlockFormatStyle? style;

  /// Max width for block widgets
  final double maxWidth;
  const VBlockParseConfig({
    this.enableCodeBlocks = true,
    this.enableBlockquotes = true,
    this.enableBulletLists = true,
    this.enableNumberedLists = true,
    this.style,
    this.maxWidth = double.infinity,
  });

  /// All block patterns enabled
  static const all = VBlockParseConfig();

  /// No block patterns
  static const none = VBlockParseConfig(
    enableCodeBlocks: false,
    enableBlockquotes: false,
    enableBulletLists: false,
    enableNumberedLists: false,
  );

  /// Code blocks only
  static const codeOnly = VBlockParseConfig(
    enableBlockquotes: false,
    enableBulletLists: false,
    enableNumberedLists: false,
  );

  /// Check if any block patterns are enabled
  bool get hasAnyEnabled =>
      enableCodeBlocks ||
      enableBlockquotes ||
      enableBulletLists ||
      enableNumberedLists;
}

/// Utility to parse text and create styled spans for links, mentions, etc.
class VTextParser {
  /// NEW API: Parse text with custom patterns
  ///
  /// Example:
  /// ```dart
  /// VTextParser.parseWithPatterns(
  ///   'Hello *world*! Check https://example.com',
  ///   baseStyle: TextStyle(color: Colors.black),
  ///   patterns: [
  ///     VPatternPresets.bold(baseStyle: baseStyle),
  ///     VPatternPresets.url(style: linkStyle),
  ///   ],
  ///   onPatternTap: (match) => print('Tapped: ${match.patternId}'),
  ///   messageId: 'msg_123',
  /// );
  /// ```
  static List<InlineSpan> parseWithPatterns(
    String text, {
    required TextStyle baseStyle,
    required List<VCustomPattern> patterns,
    void Function(VPatternMatch match)? onPatternTap,
    String? messageId,
  }) {
    if (text.isEmpty) return [];
    // Collect all matches with pattern info
    final List<_PatternedMatch> matches = [];
    for (final pattern in patterns) {
      for (final match in pattern.pattern.allMatches(text)) {
        // Skip if overlaps with existing match (first match wins)
        if (!_overlapsPattern(matches, match.start, match.end)) {
          matches.add(_PatternedMatch(
            start: match.start,
            end: match.end,
            rawText: match.group(0)!,
            pattern: pattern,
          ));
        }
      }
    }
    // Sort by position
    matches.sort((a, b) => a.start.compareTo(b.start));
    // Build spans
    final List<InlineSpan> spans = [];
    int currentIndex = 0;
    // Ensure baseStyle has no decoration to prevent bleeding
    final safeBaseStyle = baseStyle.decoration == null
        ? baseStyle.copyWith(decoration: TextDecoration.none)
        : baseStyle;
    for (final match in matches) {
      // Add text before match
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
          style: safeBaseStyle,
        ));
      }
      // Determine display text (with or without markers)
      String displayText = match.rawText;
      if (match.pattern.removeMarkers &&
          match.rawText.length > match.pattern.markerLength * 2) {
        displayText = match.rawText.substring(
          match.pattern.markerLength,
          match.rawText.length - match.pattern.markerLength,
        );
      }
      // Create recognizer for tappable patterns
      GestureRecognizer? recognizer;
      if (match.pattern.isTappable && onPatternTap != null) {
        final value =
            match.pattern.valueTransformer?.call(displayText) ?? displayText;
        recognizer = TapGestureRecognizer()
          ..onTap = () => onPatternTap(VPatternMatch(
                patternId: match.pattern.id,
                matchedText: value,
                rawText: match.rawText,
                messageId: messageId,
              ));
      }
      // Ensure pattern style has explicit decoration to prevent bleeding
      final patternStyle = match.pattern.style;
      final safePatternStyle = patternStyle.decoration == null
          ? patternStyle.copyWith(decoration: TextDecoration.none)
          : patternStyle;
      spans.add(TextSpan(
        text: displayText,
        style: safePatternStyle,
        recognizer: recognizer,
      ));
      currentIndex = match.end;
    }
    // Add remaining text
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: safeBaseStyle,
      ));
    }
    return spans;
  }

  static bool _overlapsPattern(
      List<_PatternedMatch> matches, int start, int end) {
    for (final match in matches) {
      if (start < match.end && end > match.start) return true;
    }
    return false;
  }

  // ════════════════════════════════════════════════════════════════════════════
  // BLOCK-LEVEL PARSING - Code blocks, blockquotes, lists
  // ════════════════════════════════════════════════════════════════════════════

  /// Parse text with support for block-level elements (code blocks, blockquotes, lists)
  ///
  /// Returns a list of widgets that can be rendered in a Column.
  /// Block elements become separate widgets, inline text becomes RichText.
  ///
  /// Performance optimizations:
  /// - Early return if no block markers detected
  /// - Single-pass block extraction
  /// - Lazy inline pattern application
  static List<Widget> parseWithBlocks(
    String text, {
    required TextStyle baseStyle,
    required List<VCustomPattern> inlinePatterns,
    required VBlockParseConfig blockConfig,
    void Function(VPatternMatch match)? onPatternTap,
    String? messageId,
  }) {
    if (text.isEmpty) return [];
    // Fast path: check if text contains any block markers
    if (!blockConfig.hasAnyEnabled || !_hasBlockMarkers(text, blockConfig)) {
      // No block elements, use standard inline parsing
      final spans = parseWithPatterns(
        text,
        baseStyle: baseStyle,
        patterns: inlinePatterns,
        onPatternTap: onPatternTap,
        messageId: messageId,
      );
      if (spans.isEmpty) return [];
      return [
        RichText(
          text: TextSpan(children: spans),
          textDirection: getTextDirection(text),
        ),
      ];
    }
    // Get or create block style
    final blockStyle = blockConfig.style ??
        VBlockFormatStyle.fromColors(
          textColor: baseStyle.color ?? Colors.black,
          accentColor: Colors.blue,
          brightness: Brightness.light,
        );
    // Extract all block matches
    final blockMatches = _extractBlockMatches(text, blockConfig);
    if (blockMatches.isEmpty) {
      // No actual block matches found, use inline parsing
      final spans = parseWithPatterns(
        text,
        baseStyle: baseStyle,
        patterns: inlinePatterns,
        onPatternTap: onPatternTap,
        messageId: messageId,
      );
      return [
        RichText(
          text: TextSpan(children: spans),
          textDirection: getTextDirection(text),
        ),
      ];
    }
    // Sort by position
    blockMatches.sort((a, b) => a.start.compareTo(b.start));
    // Build widgets
    final widgets = <Widget>[];
    int currentIndex = 0;
    for (final block in blockMatches) {
      // Add text before this block
      if (block.start > currentIndex) {
        final beforeText = text.substring(currentIndex, block.start).trim();
        if (beforeText.isNotEmpty) {
          final spans = parseWithPatterns(
            beforeText,
            baseStyle: baseStyle,
            patterns: inlinePatterns,
            onPatternTap: onPatternTap,
            messageId: messageId,
          );
          widgets.add(
            RichText(
              text: TextSpan(children: spans),
              textDirection: getTextDirection(beforeText),
            ),
          );
        }
      }
      // Add the block widget
      widgets.add(_buildBlockWidget(
        block,
        blockStyle,
        blockConfig.maxWidth,
        baseStyle,
        inlinePatterns,
        onPatternTap,
        messageId,
      ));
      currentIndex = block.end;
    }
    // Add remaining text after last block
    if (currentIndex < text.length) {
      final afterText = text.substring(currentIndex).trim();
      if (afterText.isNotEmpty) {
        final spans = parseWithPatterns(
          afterText,
          baseStyle: baseStyle,
          patterns: inlinePatterns,
          onPatternTap: onPatternTap,
          messageId: messageId,
        );
        widgets.add(
          RichText(
            text: TextSpan(children: spans),
            textDirection: getTextDirection(afterText),
          ),
        );
      }
    }
    return widgets;
  }

  /// Quick check for block markers (performance optimization)
  static bool _hasBlockMarkers(String text, VBlockParseConfig config) {
    if (config.enableCodeBlocks && text.contains('```')) return true;
    if (config.enableBlockquotes && text.contains('\n>')) return true;
    if (config.enableBlockquotes && text.startsWith('>')) return true;
    if (config.enableBulletLists) {
      if (text.contains('\n- ') || text.contains('\n* ')) return true;
      if (text.startsWith('- ') || text.startsWith('* ')) return true;
    }
    if (config.enableNumberedLists) {
      if (RegExp(r'\n\d+\. ').hasMatch(text)) return true;
      if (RegExp(r'^\d+\. ').hasMatch(text)) return true;
    }
    return false;
  }

  /// Extract all block-level matches from text
  static List<_BlockMatch> _extractBlockMatches(
      String text, VBlockParseConfig config) {
    final matches = <_BlockMatch>[];
    // Code blocks first (highest priority, can contain other markers)
    if (config.enableCodeBlocks) {
      for (final match in VPatternPresets.codeBlockRegex.allMatches(text)) {
        matches.add(_BlockMatch(
          type: _BlockType.codeBlock,
          start: match.start,
          end: match.end,
          content: match.group(2) ?? '',
          language: match.group(1),
        ));
      }
    }
    // Blockquotes
    if (config.enableBlockquotes) {
      for (final match in VPatternPresets.blockquoteRegex.allMatches(text)) {
        if (!_overlapsBlock(matches, match.start, match.end)) {
          final rawContent = match.group(1) ?? '';
          // Strip > prefix from each line
          final content = rawContent
              .split('\n')
              .map((line) => line.replaceFirst(RegExp(r'^>\s?'), ''))
              .join('\n')
              .trim();
          matches.add(_BlockMatch(
            type: _BlockType.blockquote,
            start: match.start,
            end: match.end,
            content: content,
          ));
        }
      }
    }
    // Bullet lists
    if (config.enableBulletLists) {
      for (final match in VPatternPresets.bulletListRegex.allMatches(text)) {
        if (!_overlapsBlock(matches, match.start, match.end)) {
          final rawContent = match.group(1) ?? '';
          final items = rawContent
              .split('\n')
              .where((line) => line.trim().isNotEmpty)
              .map((line) => line.replaceFirst(RegExp(r'^[-*]\s+'), ''))
              .toList();
          matches.add(_BlockMatch(
            type: _BlockType.bulletList,
            start: match.start,
            end: match.end,
            content: rawContent,
            listItems: items,
          ));
        }
      }
    }
    // Numbered lists
    if (config.enableNumberedLists) {
      for (final match in VPatternPresets.numberedListRegex.allMatches(text)) {
        if (!_overlapsBlock(matches, match.start, match.end)) {
          final rawContent = match.group(1) ?? '';
          final items = rawContent
              .split('\n')
              .where((line) => line.trim().isNotEmpty)
              .map((line) => line.replaceFirst(RegExp(r'^\d+\.\s+'), ''))
              .toList();
          matches.add(_BlockMatch(
            type: _BlockType.numberedList,
            start: match.start,
            end: match.end,
            content: rawContent,
            listItems: items,
          ));
        }
      }
    }
    return matches;
  }

  /// Check if a range overlaps with existing block matches
  static bool _overlapsBlock(List<_BlockMatch> matches, int start, int end) {
    for (final match in matches) {
      if (start < match.end && end > match.start) return true;
    }
    return false;
  }

  /// Build the appropriate widget for a block match
  static Widget _buildBlockWidget(
    _BlockMatch block,
    VBlockFormatStyle style,
    double maxWidth,
    TextStyle baseStyle,
    List<VCustomPattern> inlinePatterns,
    void Function(VPatternMatch match)? onPatternTap,
    String? messageId,
  ) {
    switch (block.type) {
      case _BlockType.codeBlock:
        return VCodeBlockWidget(
          code: block.content,
          language: block.language,
          style: style,
          maxWidth: maxWidth,
        );
      case _BlockType.blockquote:
        // Apply inline formatting to blockquote content
        final spans = parseWithPatterns(
          block.content,
          baseStyle: baseStyle.copyWith(
            color: style.blockquoteTextColor,
            fontStyle: FontStyle.italic,
          ),
          patterns: inlinePatterns,
          onPatternTap: onPatternTap,
          messageId: messageId,
        );
        return VBlockquoteWidget(
          text: block.content,
          style: style,
          maxWidth: maxWidth,
          spans: spans,
        );
      case _BlockType.bulletList:
        // Apply inline formatting to each list item
        final itemSpans = block.listItems?.map((item) {
          return parseWithPatterns(
            item,
            baseStyle: baseStyle.copyWith(color: style.listTextColor),
            patterns: inlinePatterns,
            onPatternTap: onPatternTap,
            messageId: messageId,
          );
        }).toList();
        return VBulletListWidget(
          items: block.listItems ?? [],
          style: style,
          maxWidth: maxWidth,
          itemSpans: itemSpans,
        );
      case _BlockType.numberedList:
        // Apply inline formatting to each list item
        final itemSpans = block.listItems?.map((item) {
          return parseWithPatterns(
            item,
            baseStyle: baseStyle.copyWith(color: style.listTextColor),
            patterns: inlinePatterns,
            onPatternTap: onPatternTap,
            messageId: messageId,
          );
        }).toList();
        return VNumberedListWidget(
          items: block.listItems ?? [],
          style: style,
          maxWidth: maxWidth,
          itemSpans: itemSpans,
        );
    }
  }

  // ════════════════════════════════════════════════════════════════════════════
  // RTL DETECTION - Content-based text direction using intl package
  // ════════════════════════════════════════════════════════════════════════════

  /// Detect if text content is RTL using intl package's Bidi algorithm
  /// Checks if text starts with RTL characters (Arabic, Hebrew, Persian, etc.)
  static bool isRTL(String text) {
    if (text.isEmpty) return false;
    return intl.Bidi.startsWithRtl(text);
  }

  /// Check if text contains any RTL characters
  static bool hasAnyRTL(String text) {
    if (text.isEmpty) return false;
    return intl.Bidi.hasAnyRtl(text);
  }

  /// Detect overall text directionality using intl package
  /// Returns true if text is predominantly RTL
  static bool detectRTLDirectionality(String text) {
    if (text.isEmpty) return false;
    return intl.Bidi.detectRtlDirectionality(text);
  }

  /// Get TextDirection for content-based rendering
  static TextDirection getTextDirection(String text) {
    return isRTL(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Get TextDirection based on overall text directionality
  static TextDirection getOverallTextDirection(String text) {
    return detectRTLDirectionality(text)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}

/// Internal match class with pattern reference
class _PatternedMatch {
  final int start;
  final int end;
  final String rawText;
  final VCustomPattern pattern;
  _PatternedMatch({
    required this.start,
    required this.end,
    required this.rawText,
    required this.pattern,
  });
}

/// Block element types
enum _BlockType {
  codeBlock,
  blockquote,
  bulletList,
  numberedList,
}

/// Internal class for block-level matches
class _BlockMatch {
  final _BlockType type;
  final int start;
  final int end;
  final String content;
  final String? language; // For code blocks
  final List<String>? listItems; // For lists
  _BlockMatch({
    required this.type,
    required this.start,
    required this.end,
    required this.content,
    this.language,
    this.listItems,
  });
}
