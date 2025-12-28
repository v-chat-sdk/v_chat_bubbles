import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/models.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';
import 'shared/unified_image.dart';

/// Contact card message bubble
class VContactBubble extends BaseBubble {
  /// Contact data (name, phone, avatar)
  final VContactData contactData;
  @override
  String get messageType => 'contact';
  const VContactBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.contactData,
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
    final callbacks = context.bubbleCallbacks;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    final textColor = selectTextColor(theme);
    final linkColor = selectLinkColor(theme);
    final header = buildBubbleHeader(context);
    return GestureDetector(
      onTap: isSelectionMode ? null : () => callbacks.onTap?.call(messageId),
      child: VBubbleWrapper(
        isMeSender: isMeSender,
        showTail: !isSameSender,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header != null) header,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAvatar(context, linkColor),
                BubbleSpacing.gapXL,
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        contactData.name,
                        style: theme.messageTextStyle.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      BubbleSpacing.vGapXS,
                      // Phone number + meta inline
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (contactData.phoneNumber != null)
                            Flexible(
                              child: Text(
                                contactData.phoneNumber!,
                                style: theme.timeTextStyle
                                    .copyWith(color: linkColor),
                              ),
                            ),
                          BubbleSpacing.gapM,
                          buildMeta(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, Color color) {
    final config = context.bubbleConfig;
    // Contact avatars are 1.5x the default message avatar size
    final size = config.avatar.size * 1.5;
    final radius = size / 2;
    final iconSize = size * 0.58;
    if (contactData.avatar != null) {
      return VUnifiedImage(
        imageSource: contactData.avatar!,
        width: size,
        height: size,
        isCircular: true,
        shimmerBaseColor: color.withValues(alpha: 0.2),
        shimmerHighlightColor: color.withValues(alpha: 0.1),
        fadeInDuration: config.animation.fadeIn,
        errorWidget: CircleAvatar(
          radius: radius,
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(Icons.person, color: color, size: iconSize),
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: color.withValues(alpha: 0.2),
      child: Icon(Icons.person, color: color, size: iconSize),
    );
  }
}
