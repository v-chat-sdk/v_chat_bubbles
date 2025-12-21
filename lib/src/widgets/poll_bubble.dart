import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/enums.dart';
import '../core/models.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';

/// Poll message bubble
class VPollBubble extends BaseBubble {
  /// Poll data (question, options, mode, results)
  final VPollData pollData;
  @override
  String get messageType => 'poll';
  const VPollBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.pollData,
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
    final header = buildBubbleHeader(context);
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: !isSameSender,
      maxWidth: MediaQuery.sizeOf(context).width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header,
          // Poll icon and type
          Row(
            children: [
              Icon(
                pollData.mode == VPollMode.quiz ? Icons.quiz : Icons.poll,
                size: BubbleSizes.iconStandard,
                color: secondaryColor,
              ),
              BubbleSpacing.gapM,
              Text(
                _getPollTypeLabel(context),
                style: theme.timeTextStyle.copyWith(color: secondaryColor),
              ),
              if (pollData.isAnonymous) ...[
                Text(' • ',
                    style: theme.timeTextStyle.copyWith(color: secondaryColor)),
                Text(context.bubbleConfig.translations.pollAnonymous,
                    style: theme.timeTextStyle.copyWith(color: secondaryColor)),
              ],
            ],
          ),
          BubbleSpacing.vGapL,
          // Question
          Text(
            pollData.question,
            style: theme.messageTextStyle.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          BubbleSpacing.vGapXL,
          // Options
          ...pollData.options.map((option) => _buildOption(context, option)),
          BubbleSpacing.vGapL,
          // Footer
          Row(
            children: [
              Flexible(
                child: Text(
                  '${pollData.totalVotes} vote${pollData.totalVotes == 1 ? '' : 's'}',
                  style: theme.timeTextStyle.copyWith(color: secondaryColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (pollData.isClosed) ...[
                BubbleSpacing.gapS,
                Text(
                  'Final results',
                  style: theme.timeTextStyle.copyWith(color: secondaryColor),
                ),
              ],
              BubbleSpacing.gapS,
              buildMeta(context),
            ],
          ),
        ],
      ),
    );
  }

  String _getPollTypeLabel(BuildContext context) {
    final translations = context.bubbleConfig.translations;
    switch (pollData.mode) {
      case VPollMode.quiz:
        return translations.pollQuiz;
      case VPollMode.multiple:
        return translations.pollMultipleChoice;
      default:
        return translations.pollDefault;
    }
  }

  Widget _buildOption(BuildContext context, VPollOption option) {
    final theme = context.bubbleTheme;
    final callbacks = context.bubbleCallbacks;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    final textColor = selectTextColor(theme);
    final linkColor = selectLinkColor(theme);
    final progressColor =
        isMeSender ? theme.progressColor : theme.incomingLinkColor;
    final showResults = pollData.hasVoted || pollData.isClosed;
    final percentage = option.percentage;
    return GestureDetector(
      onTap: isSelectionMode
          ? null
          : (!showResults && !pollData.isClosed
              ? () => callbacks.onPollVote?.call(messageId, option.id)
              : null),
      child: Container(
        margin: EdgeInsets.only(bottom: BubbleSpacing.inlineL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (!showResults) ...[
                  Container(
                    width: BubbleSizes.iconDefault,
                    height: BubbleSizes.iconDefault,
                    decoration: BoxDecoration(
                      shape: pollData.mode == VPollMode.multiple
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      borderRadius: pollData.mode == VPollMode.multiple
                          ? BubbleRadius.tiny
                          : null,
                      border: Border.all(color: linkColor, width: 2),
                    ),
                    child: option.isSelected
                        ? Icon(Icons.check,
                            size: BubbleSizes.iconSmall, color: linkColor)
                        : null,
                  ),
                  BubbleSpacing.gapL,
                ],
                Expanded(
                  child: Text(
                    option.text,
                    style: theme.messageTextStyle.copyWith(
                      color: textColor,
                      fontWeight: option.isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (showResults) ...[
                  if (pollData.mode == VPollMode.quiz && option.isCorrect)
                    Icon(Icons.check_circle,
                        color: Colors.green, size: BubbleSizes.iconStandard),
                  if (option.isSelected &&
                      !option.isCorrect &&
                      pollData.mode == VPollMode.quiz)
                    Icon(Icons.cancel,
                        color: Colors.red, size: BubbleSizes.iconStandard),
                  BubbleSpacing.gapM,
                  Text(
                    '${(percentage * 100).toInt()}%',
                    style: theme.timeTextStyle.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            if (showResults) ...[
              BubbleSpacing.vGapS,
              ClipRRect(
                borderRadius: BubbleRadius.extraSmall,
                child: LinearProgressIndicator(
                  value: percentage,
                  backgroundColor:
                      progressColor.withValues(alpha: BubbleOpacity.light2),
                  color: option.isSelected ? linkColor : progressColor,
                  minHeight: 4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
