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
