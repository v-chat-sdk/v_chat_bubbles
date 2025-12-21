import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/enums.dart';
import '../core/models.dart';
import '../utils/format_utils.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';

/// Call message bubble for voice/video call logs
///
/// Displays call information with:
/// - Call type icon (voice/video)
/// - Call status (incoming, outgoing, missed, declined, cancelled)
/// - Call duration (if connected)
/// - Callback button
class VCallBubble extends BaseBubble {
  /// Call data (type, status, duration)
  final VCallData callData;
  @override
  String get messageType => 'call';
  const VCallBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.callData,
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
    final secondaryColor = selectSecondaryTextColor(theme);
    final linkColor = selectLinkColor(theme);
    final header = buildBubbleHeader(context);
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: !isSameSender,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) header,
          Row(
            children: [
              _buildCallIcon(context, linkColor, secondaryColor),
              BubbleSpacing.gapXL,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getCallTitle(context),
                      style: theme.messageTextStyle.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    BubbleSpacing.vGapXS,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatusIcon(context, secondaryColor),
                        BubbleSpacing.gapS,
                        Flexible(
                          child: Text(
                            _getCallSubtitle(context),
                            style: theme.timeTextStyle
                                .copyWith(color: secondaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCallIcon(
      BuildContext context, Color linkColor, Color secondaryColor) {
    final isMissed = callData.status == VCallStatus.missed ||
        callData.status == VCallStatus.declined;
    return Container(
      width: BubbleSizes.callIconContainer,
      height: BubbleSizes.callIconContainer,
      decoration: BoxDecoration(
        color: (isMissed ? Colors.red : linkColor).withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        callData.type == VCallType.video ? Icons.videocam : Icons.phone,
        color: isMissed ? Colors.red : linkColor,
        size: BubbleSizes.iconLarge,
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context, Color color) {
    IconData icon;
    Color iconColor = color;
    switch (callData.status) {
      case VCallStatus.incoming:
        icon = Icons.call_received;
      case VCallStatus.outgoing:
        icon = Icons.call_made;
      case VCallStatus.missed:
        icon = Icons.call_missed;
        iconColor = Colors.red;
      case VCallStatus.declined:
        icon = Icons.call_end;
        iconColor = Colors.red;
      case VCallStatus.cancelled:
        icon = Icons.cancel_outlined;
        iconColor = Colors.orange;
    }
    return Icon(icon, size: BubbleSizes.iconSmall, color: iconColor);
  }

  String _getCallTitle(BuildContext context) {
    final translations = context.bubbleConfig.translations;
    final typeStr = callData.type == VCallType.video
        ? translations.callVideo
        : translations.callVoice;
    switch (callData.status) {
      case VCallStatus.incoming:
        return '${translations.callIncoming} $typeStr Call';
      case VCallStatus.outgoing:
        return '${translations.callOutgoing} $typeStr Call';
      case VCallStatus.missed:
        return '${translations.callMissed} $typeStr Call';
      case VCallStatus.declined:
        return '${translations.callDeclined} $typeStr Call';
      case VCallStatus.cancelled:
        return '${translations.callCancelled} $typeStr Call';
    }
  }

  String _getCallSubtitle(BuildContext context) {
    if (callData.duration != null && callData.duration!.inSeconds > 0) {
      return formatCallDuration(callData.duration!);
    }
    final translations = context.bubbleConfig.translations;
    switch (callData.status) {
      case VCallStatus.missed:
        return translations.callNotAnswered;
      case VCallStatus.declined:
        return translations.callDeclinedStatus;
      case VCallStatus.cancelled:
        return translations.callCancelledStatus;
      default:
        return translations.callTapToCallBack;
    }
  }
}
