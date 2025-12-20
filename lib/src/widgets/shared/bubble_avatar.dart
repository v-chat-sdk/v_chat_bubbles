import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import '../../core/callbacks.dart';
import '../bubble_scope.dart';
import 'unified_image.dart';

class VBubbleAvatar extends StatelessWidget {
  final bool isMeSender;
  final VPlatformFile? avatar;
  final String? senderName;
  final Color? senderColor;
  final VBubbleCallbacks? callbacks;
  final String? messageId;

  const VBubbleAvatar({
    super.key,
    required this.isMeSender,
    this.avatar,
    this.senderName,
    this.senderColor,
    this.callbacks,
    this.messageId,
  });

  @override
  Widget build(BuildContext context) {
    final config = context.bubbleConfig;
    final size = config.avatar.size;
    final theme = context.bubbleTheme;

    Widget avatarWidget;

    if (avatar != null) {
      final bubbleColor =
          isMeSender ? theme.outgoingBubbleColor : theme.incomingBubbleColor;
      avatarWidget = VUnifiedImage(
        imageSource: avatar!,
        width: size,
        height: size,
        isCircular: true,
        shimmerBaseColor: bubbleColor.withValues(alpha: 0.3),
        shimmerHighlightColor: bubbleColor.withValues(alpha: 0.1),
        fadeInDuration: config.animation.fadeIn,
        errorWidget: _buildAvatarPlaceholder(size),
      );
    } else if (senderName != null && senderName!.isNotEmpty) {
      final letter = senderName![0].toUpperCase();
      final color = senderColor ?? _generateColorFromName(senderName!);
      avatarWidget = CircleAvatar(
        radius: size / 2,
        backgroundColor: color,
        child: Text(
          letter,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.45,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      avatarWidget = _buildAvatarPlaceholder(size);
    }

    if (callbacks?.onAvatarTap != null && messageId != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => callbacks!.onAvatarTap!(messageId!),
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }

  Widget _buildAvatarPlaceholder(double size) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey[400],
      child: Icon(Icons.person, size: size * 0.6, color: Colors.white),
    );
  }

  Color _generateColorFromName(String name) {
    final colors = [
      const Color(0xFF1976D2),
      const Color(0xFF388E3C),
      const Color(0xFFF57C00),
      const Color(0xFF7B1FA2),
      const Color(0xFFD32F2F),
      const Color(0xFF00796B),
      const Color(0xFF5D4037),
      const Color(0xFF455A64),
    ];
    final hash = name.codeUnits.fold(0, (prev, curr) => prev + curr);
    return colors[hash % colors.length];
  }
}
