import 'package:flutter/material.dart';
import '../../core/enums.dart';
import '../../utils/text_parser.dart';
import 'message_status_icon.dart';

/// Overlay for media bubbles showing time, status, and optional caption.
class VMediaOverlayInfo extends StatelessWidget {
  const VMediaOverlayInfo({
    super.key,
    required this.time,
    this.status,
    this.caption,
    this.isMeSender = true,
    this.maxCaptionLines = 2,
    this.readIconColor,
    this.searchQuery,
    this.searchHighlightStyle,
  });

  final String time;
  final VMessageStatus? status;
  final String? caption;
  final bool isMeSender;
  final int maxCaptionLines;
  final Color? readIconColor;
  final String? searchQuery;
  final TextStyle? searchHighlightStyle;

  static const _overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0x80000000)],
  );

  @override
  Widget build(BuildContext context) {
    final TextStyle highlight =
        searchHighlightStyle ??
        const TextStyle(
          backgroundColor: Color(0xFFFF3B82),
          color: Color(0xFFFFFFFF),
        );
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: const BoxDecoration(gradient: _overlayGradient),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (caption != null && caption!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: _buildCaption(caption!, highlight),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
                if (isMeSender && status != null) ...[
                  const SizedBox(width: 4),
                  VMessageStatusIcon(
                    status: status!,
                    color: Colors.white70,
                    size: 14,
                    readColor: readIconColor,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaption(String text, TextStyle highlight) {
    const base = TextStyle(color: Colors.white, fontSize: 14);
    if (searchQuery == null || searchQuery!.isEmpty) {
      return Text(
        text,
        style: base,
        maxLines: maxCaptionLines,
        overflow: TextOverflow.ellipsis,
      );
    }
    final spans = VTextParser.buildHighlightedSpans(
      text,
      base,
      searchQuery,
      highlight,
    );
    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxCaptionLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
