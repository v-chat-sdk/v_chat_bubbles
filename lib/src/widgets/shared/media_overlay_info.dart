import 'package:flutter/material.dart';
import '../../core/enums.dart';
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
  });

  final String time;
  final VMessageStatus? status;
  final String? caption;
  final bool isMeSender;
  final int maxCaptionLines;
  final Color? readIconColor;

  static const _overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0x80000000)],
  );

  @override
  Widget build(BuildContext context) {
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
                child: Text(
                  caption!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: maxCaptionLines,
                  overflow: TextOverflow.ellipsis,
                ),
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
}
