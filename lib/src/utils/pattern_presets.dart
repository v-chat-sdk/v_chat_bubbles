import 'package:flutter/material.dart';
import '../core/models.dart';

/// Pre-built patterns for common text detection and formatting
class VPatternPresets {
  VPatternPresets._();
  // ===== REGEX PATTERNS (INLINE) =====
  static final _urlRegex = RegExp(
    r'https?://[^\s<>\[\]{}|\\^]+',
    caseSensitive: false,
  );
  static final _emailRegex = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );
  static final _phoneRegex = RegExp(
    r'[\+]?[0-9]{1,4}?[-.\s]?\(?[0-9]{1,3}\)?[-.\s]?[0-9]{1,4}[-.\s]?[0-9]{1,4}[-.\s]?[0-9]{1,9}',
  );
  static final _mentionRegex = RegExp(r'@[a-zA-Z0-9_]+');
  static final _mentionWithIdRegex = RegExp(r'\[(@[^:]+):([^\]]+)\]');
  static final _hashtagRegex = RegExp(r'#[a-zA-Z0-9_]+');
  static final _boldRegex = RegExp(r'\*([^*]+?)\*');
  static final _italicRegex = RegExp(r'_([^_]+?)_');
  static final _codeRegex = RegExp(r'`([^`]+?)`');
  static final _strikethroughRegex = RegExp(r'~([^~]+?)~');
  // ===== BLOCK-LEVEL REGEX PATTERNS =====
  /// Code block: ```code``` or ```lang\ncode```
  /// Uses non-greedy match to avoid catastrophic backtracking
  static final codeBlockRegex = RegExp(
    r'```(?:(\w+)\n)?([\s\S]*?)```',
    multiLine: true,
  );

  /// Blockquote: lines starting with > (supports multiple consecutive lines)
  static final blockquoteRegex = RegExp(
    r'^((?:>[ ]?.+(?:\n|$))+)',
    multiLine: true,
  );

  /// Bulleted list: lines starting with - or * followed by space
  static final bulletListRegex = RegExp(
    r'^((?:[-*][ ]+.+(?:\n|$))+)',
    multiLine: true,
  );

  /// Numbered list: lines starting with digits followed by . and space
  static final numberedListRegex = RegExp(
    r'^((?:\d+\.[ ]+.+(?:\n|$))+)',
    multiLine: true,
  );
  // ===== DETECTION PATTERNS =====
  /// URL pattern (http/https links)
  static VCustomPattern url({required TextStyle style}) => VCustomPattern(
        id: 'url',
        pattern: _urlRegex,
        style: style,
      );

  /// Email pattern
  static VCustomPattern email({required TextStyle style}) => VCustomPattern(
        id: 'email',
        pattern: _emailRegex,
        style: style,
      );

  /// Phone number pattern
  static VCustomPattern phone({required TextStyle style}) => VCustomPattern(
        id: 'phone',
        pattern: _phoneRegex,
        style: style,
      );

  /// Mention pattern (@username)
  static VCustomPattern mention({required TextStyle style}) => VCustomPattern(
        id: 'mention',
        pattern: _mentionRegex,
        style: style,
        valueTransformer: (text) => text.substring(1), // Remove @ prefix
      );

  /// Mention with ID pattern ([@username:userId] -> displays @username)
  ///
  /// Use this when you need to embed user IDs in mentions but display only the username.
  /// - Display: `@username`
  /// - `matchedText` in callback: `@username`
  /// - `rawText` in callback: `[@username:userId]` (extract ID from here)
  ///
  /// Example: `Hey [@John:user_123]!` displays as `Hey @John!`
  ///
  /// To extract userId in callback, use [extractMentionId]:
  /// ```dart
  /// onPatternTap: (match) {
  ///   if (match.patternId == 'mention_with_id') {
  ///     final userId = VPatternPresets.extractMentionId(match.rawText);
  ///     // Navigate to user profile...
  ///   }
  /// }
  /// ```
  static VCustomPattern mentionWithId({required TextStyle style}) =>
      VCustomPattern(
        id: 'mention_with_id',
        pattern: _mentionWithIdRegex,
        style: style,
        valueTransformer: (text) {
          // Extract @username from [@username:userId]
          final match = _mentionWithIdRegex.firstMatch(text);
          return match?.group(1) ?? text;
        },
      );

  /// Extract userId from mention with ID raw text.
  ///
  /// Example:
  /// ```dart
  /// final userId = VPatternPresets.extractMentionId('[@John:user_123]');
  /// print(userId); // 'user_123'
  /// ```
  static String? extractMentionId(String rawText) {
    final match = _mentionWithIdRegex.firstMatch(rawText);
    return match?.group(2);
  }

  /// Extract username from mention with ID raw text (without @ prefix).
  ///
  /// Example:
  /// ```dart
  /// final username = VPatternPresets.extractMentionUsername('[@John:user_123]');
  /// print(username); // 'John'
  /// ```
  static String? extractMentionUsername(String rawText) {
    final match = _mentionWithIdRegex.firstMatch(rawText);
    final withAt = match?.group(1); // @John
    return withAt?.substring(1); // John (remove @)
  }

  /// Extract both username and userId from mention with ID raw text.
  ///
  /// Example:
  /// ```dart
  /// final data = VPatternPresets.extractMentionData('[@John:user_123]');
  /// print(data); // {username: 'John', userId: 'user_123'}
  /// ```
  static ({String? username, String? userId}) extractMentionData(
      String rawText) {
    final match = _mentionWithIdRegex.firstMatch(rawText);
    final withAt = match?.group(1);
    return (
      username: withAt?.substring(1),
      userId: match?.group(2),
    );
  }

  /// Hashtag pattern (#tag)
  static VCustomPattern hashtag({required TextStyle style}) => VCustomPattern(
        id: 'hashtag',
        pattern: _hashtagRegex,
        style: style,
        valueTransformer: (text) => text.substring(1), // Remove # prefix
      );
  // ===== FORMATTING PATTERNS =====
  /// Bold pattern (*text* -> text)
  static VCustomPattern bold({required TextStyle baseStyle}) => VCustomPattern(
        id: 'bold',
        pattern: _boldRegex,
        style: baseStyle.copyWith(
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none,
        ),
        removeMarkers: true,
        markerLength: 1,
        isTappable: false,
      );

  /// Italic pattern (_text_ -> text)
  static VCustomPattern italic({required TextStyle baseStyle}) =>
      VCustomPattern(
        id: 'italic',
        pattern: _italicRegex,
        style: baseStyle.copyWith(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.none,
        ),
        removeMarkers: true,
        markerLength: 1,
        isTappable: false,
      );

  /// Code/monospace pattern (`text` -> text)
  static VCustomPattern code({
    required TextStyle baseStyle,
    Color? backgroundColor,
  }) =>
      VCustomPattern(
        id: 'code',
        pattern: _codeRegex,
        style: baseStyle.copyWith(
          fontFamily: 'monospace',
          backgroundColor:
              backgroundColor ?? Colors.grey.withValues(alpha: 0.2),
          decoration: TextDecoration.none,
        ),
        removeMarkers: true,
        markerLength: 1,
        isTappable: false,
      );

  /// Strikethrough pattern (~text~ -> text)
  static VCustomPattern strikethrough({required TextStyle baseStyle}) =>
      VCustomPattern(
        id: 'strikethrough',
        pattern: _strikethroughRegex,
        style: baseStyle.copyWith(
          decoration: TextDecoration.lineThrough,
          decorationColor: baseStyle.color,
        ),
        removeMarkers: true,
        markerLength: 1,
        isTappable: false,
      );
  // ===== PRESET COLLECTIONS =====
  /// Standard detection patterns (url, email, phone, mention)
  static List<VCustomPattern> standardDetection({
    required TextStyle linkStyle,
    TextStyle? mentionStyle,
  }) =>
      [
        url(style: linkStyle),
        email(style: linkStyle),
        phone(style: linkStyle),
        mention(style: mentionStyle ?? linkStyle),
      ];

  /// Basic formatting patterns (bold, italic, code)
  static List<VCustomPattern> basicFormatting({required TextStyle baseStyle}) =>
      [
        bold(baseStyle: baseStyle),
        italic(baseStyle: baseStyle),
        code(baseStyle: baseStyle),
      ];

  /// Extended formatting patterns (includes strikethrough)
  static List<VCustomPattern> extendedFormatting({
    required TextStyle baseStyle,
  }) =>
      [
        bold(baseStyle: baseStyle),
        italic(baseStyle: baseStyle),
        code(baseStyle: baseStyle),
        strikethrough(baseStyle: baseStyle),
      ];

  /// All patterns (detection + basic formatting + hashtag)
  static List<VCustomPattern> all({
    required TextStyle baseStyle,
    required TextStyle linkStyle,
    TextStyle? mentionStyle,
  }) =>
      [
        ...standardDetection(linkStyle: linkStyle, mentionStyle: mentionStyle),
        hashtag(style: linkStyle),
        ...basicFormatting(baseStyle: baseStyle),
      ];
}
