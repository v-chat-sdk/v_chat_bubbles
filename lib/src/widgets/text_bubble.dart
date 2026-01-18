import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../core/config.dart';
import '../core/constants.dart';
import '../core/enums.dart';
import '../core/models.dart';
import '../utils/text_parser.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';
import 'shared/block_format_widgets.dart';
import 'shared/bubble_footer.dart';
import 'shared/link_preview_widget.dart';

/// Simple text message bubble
///
/// Renders text content with support for:
/// - Link, email, phone, and mention detection
/// - Expandable text with "See more/less" for long messages
/// - Link preview (optional) with image, title, description
/// - Reply preview, forward header, and sender name (handled by BaseBubble)
class VTextBubble extends BaseBubble {
  /// Message text content
  final String text;

  /// Optional link preview data
  final VLinkPreviewData? linkPreview;

  @override
  String get messageType => 'text message';

  const VTextBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.text,
    this.linkPreview,
    super.status,
    super.isSameSender,
    super.avatar,
    super.senderName,
    super.senderColor,
    super.replyTo,
    super.forwardedFrom,
    super.reactions,
    super.isEdited,
    super.isPinned,
    super.isStarred,
    super.isHighlighted,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = context.bubbleTheme;
    final textColor = selectTextColor(theme);
    final header = buildBubbleHeader(context);
    final showTail = !isSameSender;
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: showTail,
      child: _ExpandableTextWithPreview(
        messageId: messageId,
        text: text,
        linkPreview: linkPreview,
        isMeSender: isMeSender,
        textColor: textColor,
        header: header,
        // Meta values for proper didUpdateWidget comparison
        time: time,
        status: status,
        isEdited: isEdited,
        isPinned: isPinned,
        isStarred: isStarred,
      ),
    );
  }
}

/// Internal stateful widget for expandable text with link preview
class _ExpandableTextWithPreview extends StatefulWidget {
  final String messageId;
  final String text;
  final VLinkPreviewData? linkPreview;
  final bool isMeSender;
  final Color textColor;
  final Widget? header;
  // Meta values for proper comparison in didUpdateWidget
  final String time;
  final VMessageStatus status;
  final bool isEdited;
  final bool isPinned;
  final bool isStarred;

  const _ExpandableTextWithPreview({
    required this.messageId,
    required this.text,
    this.linkPreview,
    required this.isMeSender,
    required this.textColor,
    this.header,
    required this.time,
    required this.status,
    required this.isEdited,
    required this.isPinned,
    required this.isStarred,
  });

  @override
  State<_ExpandableTextWithPreview> createState() =>
      _ExpandableTextWithPreviewState();
}

class _ExpandableTextWithPreviewState
    extends State<_ExpandableTextWithPreview> {
  // ═══════════════════════════════════════════════════════════════════════════
  // PERFORMANCE CACHE - Avoid re-parsing on every scroll/build
  // ═══════════════════════════════════════════════════════════════════════════
  /// Cached inline spans (parsed once, reused on rebuilds)
  List<InlineSpan>? _cachedSpans;
  List<InlineSpan>? _cachedTruncatedSpans;

  /// Cached block widgets (for block-level formatting)
  List<Widget>? _cachedBlockWidgets;

  /// Cached pattern list (built once per config)
  List<VCustomPattern>? _cachedPatterns;

  /// Cache key to detect when re-parsing is needed
  String? _cacheKey;

  /// Cached text direction
  TextDirection? _cachedTextDirection;

  @override
  void didUpdateWidget(covariant _ExpandableTextWithPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Invalidate cache only for properties that affect text parsing
    // Meta values (status, isEdited, isPinned, isStarred) don't need cache
    // invalidation - they only affect VBubbleFooter which rebuilds anyway
    if (oldWidget.text != widget.text ||
        oldWidget.textColor != widget.textColor ||
        oldWidget.isMeSender != widget.isMeSender) {
      _invalidateCache();
    }
  }

  void _invalidateCache() {
    _cachedSpans = null;
    _cachedTruncatedSpans = null;
    _cachedBlockWidgets = null;
    _cachedPatterns = null;
    _cacheKey = null;
    _cachedTextDirection = null;
  }

  /// Build meta widget using values passed from parent
  Widget _buildMeta() {
    return VBubbleFooter(
      isMeSender: widget.isMeSender,
      time: widget.time,
      status: widget.status,
      isStarred: widget.isStarred,
      isPinned: widget.isPinned,
      isEdited: widget.isEdited,
    );
  }

  void _toggleExpand() {
    final manager = context.expandStateManager;
    manager.toggle(widget.messageId);
    context.bubbleCallbacks.onExpandToggle?.call(
      widget.messageId,
      manager.isExpanded(widget.messageId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expandManager = context.expandStateManager;
    return ListenableBuilder(
      listenable: expandManager,
      builder: (context, _) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    final callbacks = context.bubbleCallbacks;
    final expandManager = context.expandStateManager;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    final isExpanded = expandManager.isExpanded(widget.messageId);
    final shouldTruncate = config.textExpansion.enabled &&
        widget.text.length > config.textExpansion.characterThreshold;
    final displayText = shouldTruncate && !isExpanded
        ? widget.text.substring(0, config.textExpansion.characterThreshold)
        : widget.text;
    // Generate cache key from relevant config values
    // Include isSelectionMode since it affects whether pattern taps are enabled
    final newCacheKey =
        '${widget.text}_${widget.textColor.hashCode}_${widget.isMeSender}_${config.patterns.hashCode}_$isSelectionMode';
    final needsReParse = _cacheKey != newCacheKey;
    if (needsReParse) {
      _cacheKey = newCacheKey;
      _cachedSpans = null;
      _cachedTruncatedSpans = null;
      _cachedBlockWidgets = null;
    }
    final linkColor =
        widget.isMeSender ? theme.outgoingLinkColor : theme.incomingLinkColor;
    final baseStyle = theme.messageTextStyle.copyWith(color: widget.textColor);
    final linkStyle = theme.linkTextStyle.copyWith(color: linkColor);
    final mentionStyle = theme.messageTextStyle.copyWith(
      color: linkColor,
      fontWeight: FontWeight.w600,
    );
    // Check if block patterns are enabled
    final hasBlockPatterns = config.patterns.hasBlockPatterns;
    // Check if text selection is enabled (mobile only, web uses SelectionArea)
    final enableTextSelection = config.textExpansion.enableTextSelection;
    // Build link preview widget if available
    Widget? linkPreviewWidget;
    if (widget.linkPreview != null) {
      linkPreviewWidget = VLinkPreviewWidget(
        linkPreview: widget.linkPreview!,
        linkColor: linkColor,
        textColor: widget.textColor,
        isMeSender: widget.isMeSender,
        messageId: widget.messageId,
      );
    }
    // Cache text direction
    _cachedTextDirection ??= VTextParser.getTextDirection(widget.text);
    final textDirection = _cachedTextDirection!;
    // Disable pattern taps when in selection mode
    final effectiveOnPatternTap =
        isSelectionMode ? null : callbacks.onPatternTap;
    // Use block parsing if block patterns are enabled
    if (hasBlockPatterns && !shouldTruncate) {
      return _wrapWithWebSelection(
        isSelectionMode: isSelectionMode,
        child: _buildBlockContent(
          context,
          displayText,
          baseStyle,
          linkStyle,
          mentionStyle,
          effectiveOnPatternTap,
          linkPreviewWidget,
          linkColor,
          config,
        ),
      );
    }
    // ═══════════════════════════════════════════════════════════════════════
    // CACHED INLINE PARSING - Only parse once per text/config combination
    // ═══════════════════════════════════════════════════════════════════════
    List<InlineSpan> spans;
    if (shouldTruncate && !isExpanded) {
      // Use truncated cache
      _cachedTruncatedSpans ??= _parseText(
        displayText,
        baseStyle,
        linkStyle,
        mentionStyle,
        config,
        effectiveOnPatternTap,
      );
      spans = _cachedTruncatedSpans!;
    } else {
      // Use full text cache
      _cachedSpans ??= _parseText(
        widget.text,
        baseStyle,
        linkStyle,
        mentionStyle,
        config,
        effectiveOnPatternTap,
      );
      spans = _cachedSpans!;
    }
    if (!shouldTruncate) {
      final textRow = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: _buildRichText(
              spans: spans,
              textDirection: textDirection,
              enableSelection: enableTextSelection,
            ),
          ),
          BubbleSpacing.gapM,
          _buildMeta(),
        ],
      );
      if (widget.header == null && linkPreviewWidget == null) {
        return _wrapWithWebSelection(
          isSelectionMode: isSelectionMode,
          child: textRow,
        );
      }
      return _wrapWithWebSelection(
        isSelectionMode: isSelectionMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.header != null) widget.header!,
            if (linkPreviewWidget != null) ...[
              linkPreviewWidget,
              BubbleSpacing.gapM,
            ],
            textRow,
          ],
        ),
      );
    }
    // Truncated text with gradient fade and "See more/less"
    final animDuration =
        isExpanded ? config.animation.expand : config.animation.collapse;
    final animCurve = config.animation.defaultCurve;
    return _wrapWithWebSelection(
      isSelectionMode: isSelectionMode,
      child: AnimatedSize(
        duration: animDuration,
        curve: animCurve,
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.header != null) widget.header!,
            if (linkPreviewWidget != null) ...[
              linkPreviewWidget,
              BubbleSpacing.gapM,
            ],
            AnimatedCrossFade(
              duration: animDuration,
              firstCurve: animCurve,
              secondCurve: animCurve,
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.textColor,
                    widget.textColor.withValues(alpha: 0),
                  ],
                  stops: const [0.7, 1.0],
                ).createShader(bounds),
                blendMode: BlendMode.dstIn,
                child: _buildRichText(
                  spans: spans,
                  textDirection: textDirection,
                  enableSelection: enableTextSelection,
                ),
              ),
              secondChild: _buildRichText(
                spans: spans,
                textDirection: textDirection,
                enableSelection: enableTextSelection,
              ),
            ),
            BubbleSpacing.vGapS,
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: _toggleExpand,
                    child: Text(
                      isExpanded
                          ? config.translations.seeLess
                          : config.translations.seeMore,
                      style: theme.linkTextStyle.copyWith(
                        color: linkColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                _buildMeta(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT SELECTION - Enable text selection based on config
  // ═══════════════════════════════════════════════════════════════════════════
  /// Wraps content with SelectionArea on web platform for text selection support.
  /// Disabled during message selection mode to avoid conflicts.
  Widget _wrapWithWebSelection({
    required bool isSelectionMode,
    required Widget child,
  }) {
    // Only enable on web and when not in message selection mode
    if (!kIsWeb || isSelectionMode) return child;
    return SelectionArea(child: child);
  }

  /// Builds text widget - SelectableText.rich() when selection enabled, RichText otherwise.
  /// Pattern taps (links, mentions) still work with SelectableText.
  Widget _buildRichText({
    required List<InlineSpan> spans,
    required TextDirection textDirection,
    required bool enableSelection,
  }) {
    final textSpan = TextSpan(children: spans);
    if (enableSelection && !kIsWeb) {
      // Use SelectableText.rich for mobile when selection enabled
      // Web uses SelectionArea wrapper instead
      return SelectableText.rich(
        textSpan,
        textDirection: textDirection,
      );
    }
    return RichText(
      text: textSpan,
      textDirection: textDirection,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS - Cached parsing
  // ═══════════════════════════════════════════════════════════════════════════
  /// Build and cache patterns list
  List<VCustomPattern> _getPatterns(
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextStyle mentionStyle,
    VBubbleConfig config,
  ) {
    return _cachedPatterns ??= config.patterns.buildPatterns(
      baseStyle: baseStyle,
      linkStyle: linkStyle,
      mentionStyle: mentionStyle,
    );
  }

  /// Parse text and return spans (used for caching)
  List<InlineSpan> _parseText(
    String text,
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextStyle mentionStyle,
    VBubbleConfig config,
    void Function(VPatternMatch match)? onPatternTap,
  ) {
    final patterns = _getPatterns(baseStyle, linkStyle, mentionStyle, config);
    return VTextParser.parseWithPatterns(
      text,
      baseStyle: baseStyle,
      patterns: patterns,
      onPatternTap: onPatternTap,
      messageId: widget.messageId,
    );
  }

  /// Build content with block-level formatting support (code blocks, blockquotes, lists)
  /// Uses cached block widgets to avoid re-parsing on every build
  Widget _buildBlockContent(
    BuildContext context,
    String text,
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextStyle mentionStyle,
    void Function(VPatternMatch match)? onPatternTap,
    Widget? linkPreviewWidget,
    Color linkColor,
    VBubbleConfig config,
  ) {
    // Use cached block widgets if available
    _cachedBlockWidgets ??= _parseBlockContent(
      text,
      baseStyle,
      linkStyle,
      mentionStyle,
      linkColor,
      config,
      onPatternTap,
    );
    // Build the column with all content
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.header != null) widget.header!,
        if (linkPreviewWidget != null) ...[
          linkPreviewWidget,
          BubbleSpacing.gapM,
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _cachedBlockWidgets!,
              ),
            ),
            BubbleSpacing.gapM,
            _buildMeta(),
          ],
        ),
      ],
    );
  }

  /// Parse block content (expensive operation - only called once per text)
  List<Widget> _parseBlockContent(
    String text,
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextStyle mentionStyle,
    Color linkColor,
    VBubbleConfig config,
    void Function(VPatternMatch match)? onPatternTap,
  ) {
    // Derive brightness from text color luminance
    final brightness = widget.textColor.computeLuminance() > 0.5
        ? Brightness.dark
        : Brightness.light;
    // Create block style based on theme
    final blockStyle = VBlockFormatStyle.fromColors(
      textColor: widget.textColor,
      accentColor: linkColor,
      brightness: brightness,
    );
    // Create block config from pattern config
    final blockConfig = VBlockParseConfig(
      enableCodeBlocks: config.patterns.enableCodeBlocks,
      enableBlockquotes: config.patterns.enableBlockquotes,
      enableBulletLists: config.patterns.enableBulletLists,
      enableNumberedLists: config.patterns.enableNumberedLists,
      style: blockStyle,
      maxWidth: config.sizing.maxWidth ?? double.infinity,
    );
    // Use cached patterns
    final patterns = _getPatterns(baseStyle, linkStyle, mentionStyle, config);
    // Parse text with block support
    return VTextParser.parseWithBlocks(
      text,
      baseStyle: baseStyle,
      inlinePatterns: patterns,
      blockConfig: blockConfig,
      onPatternTap: onPatternTap,
      messageId: widget.messageId,
    );
  }

}
