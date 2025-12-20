import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Configuration for block formatting styles
@immutable
class VBlockFormatStyle {
  /// Background color for code blocks
  final Color codeBlockBackground;

  /// Text color for code blocks
  final Color codeBlockTextColor;

  /// Border color for blockquotes
  final Color blockquoteBorderColor;

  /// Background color for blockquotes
  final Color blockquoteBackground;

  /// Text color for blockquotes
  final Color blockquoteTextColor;

  /// Bullet/number color for lists
  final Color listMarkerColor;

  /// Text color for list items
  final Color listTextColor;

  /// Border radius for code blocks
  final double codeBlockRadius;

  /// Font size for code blocks
  final double codeBlockFontSize;

  /// Whether to show copy button on code blocks
  final bool showCopyButton;
  const VBlockFormatStyle({
    required this.codeBlockBackground,
    required this.codeBlockTextColor,
    required this.blockquoteBorderColor,
    required this.blockquoteBackground,
    required this.blockquoteTextColor,
    required this.listMarkerColor,
    required this.listTextColor,
    this.codeBlockRadius = 8.0,
    this.codeBlockFontSize = 13.0,
    this.showCopyButton = true,
  });

  /// Create style from bubble theme colors
  factory VBlockFormatStyle.fromColors({
    required Color textColor,
    required Color accentColor,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;
    return VBlockFormatStyle(
      codeBlockBackground: isDark
          ? Colors.black.withValues(alpha: 0.3)
          : Colors.grey.withValues(alpha: 0.15),
      codeBlockTextColor: textColor,
      blockquoteBorderColor: accentColor,
      blockquoteBackground: isDark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.grey.withValues(alpha: 0.08),
      blockquoteTextColor: textColor.withValues(alpha: 0.85),
      listMarkerColor: accentColor,
      listTextColor: textColor,
    );
  }
}

/// Widget for rendering code blocks (```code```)
class VCodeBlockWidget extends StatelessWidget {
  final String code;
  final String? language;
  final VBlockFormatStyle style;
  final double maxWidth;
  const VCodeBlockWidget({
    super.key,
    required this.code,
    this.language,
    required this.style,
    this.maxWidth = double.infinity,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: style.codeBlockBackground,
        borderRadius: BorderRadius.circular(style.codeBlockRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (language != null || style.showCopyButton) _buildHeader(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: SelectableText(
              code.trim(),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: style.codeBlockFontSize,
                color: style.codeBlockTextColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: style.codeBlockTextColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (language != null)
            Text(
              language!,
              style: TextStyle(
                fontSize: 11,
                color: style.codeBlockTextColor.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            )
          else
            const SizedBox.shrink(),
          if (style.showCopyButton)
            GestureDetector(
              onTap: () => _copyCode(context),
              child: Icon(
                Icons.copy_rounded,
                size: 16,
                color: style.codeBlockTextColor.withValues(alpha: 0.5),
              ),
            ),
        ],
      ),
    );
  }

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Widget for rendering blockquotes (> text)
class VBlockquoteWidget extends StatelessWidget {
  final String text;
  final VBlockFormatStyle style;
  final double maxWidth;

  /// Inline spans for the blockquote text (for nested formatting)
  final List<InlineSpan>? spans;
  const VBlockquoteWidget({
    super.key,
    required this.text,
    required this.style,
    this.maxWidth = double.infinity,
    this.spans,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 8),
      decoration: BoxDecoration(
        color: style.blockquoteBackground,
        border: Border(
          left: BorderSide(
            color: style.blockquoteBorderColor,
            width: 3,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: spans != null
          ? RichText(text: TextSpan(children: spans))
          : Text(
              text,
              style: TextStyle(
                color: style.blockquoteTextColor,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
    );
  }
}

/// Widget for rendering bulleted lists (- item or * item)
class VBulletListWidget extends StatelessWidget {
  final List<String> items;
  final VBlockFormatStyle style;
  final double maxWidth;

  /// Optional: inline spans for each item (for nested formatting)
  final List<List<InlineSpan>?>? itemSpans;
  const VBulletListWidget({
    super.key,
    required this.items,
    required this.style,
    this.maxWidth = double.infinity,
    this.itemSpans,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) _buildItem(items[i], i),
        ],
      ),
    );
  }

  Widget _buildItem(String item, int index) {
    final hasSpans = itemSpans != null &&
        index < itemSpans!.length &&
        itemSpans![index] != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 8),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: style.listMarkerColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: hasSpans
                ? RichText(text: TextSpan(children: itemSpans![index]))
                : Text(
                    item,
                    style: TextStyle(
                      color: style.listTextColor,
                      height: 1.4,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Widget for rendering numbered lists (1. item)
class VNumberedListWidget extends StatelessWidget {
  final List<String> items;
  final VBlockFormatStyle style;
  final double maxWidth;

  /// Start number (defaults to 1)
  final int startNumber;

  /// Optional: inline spans for each item (for nested formatting)
  final List<List<InlineSpan>?>? itemSpans;
  const VNumberedListWidget({
    super.key,
    required this.items,
    required this.style,
    this.maxWidth = double.infinity,
    this.startNumber = 1,
    this.itemSpans,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < items.length; i++) _buildItem(items[i], i),
        ],
      ),
    );
  }

  Widget _buildItem(String item, int index) {
    final number = startNumber + index;
    final hasSpans = itemSpans != null &&
        index < itemSpans!.length &&
        itemSpans![index] != null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$number.',
              style: TextStyle(
                color: style.listMarkerColor,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          Expanded(
            child: hasSpans
                ? RichText(text: TextSpan(children: itemSpans![index]))
                : Text(
                    item,
                    style: TextStyle(
                      color: style.listTextColor,
                      height: 1.4,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
