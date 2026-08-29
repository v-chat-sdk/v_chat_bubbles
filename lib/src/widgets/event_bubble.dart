import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/enums.dart';
import '../core/modern_message_models.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';

/// Calendar event message with controlled RSVP actions.
class VEventBubble extends BaseBubble {
  final VEventData event;

  @override
  String get messageType => 'event';

  const VEventBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.event,
    super.status,
    super.isSameSender,
    super.groupPosition,
    super.avatar,
    super.senderName,
    super.senderColor,
    super.replyTo,
    super.forwardedFrom,
    super.reactions,
    super.isEdited,
    super.lifecycle,
    super.isPinned,
    super.isStarred,
    super.isHighlighted,
    super.searchQuery,
    super.searchHighlightStyle,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = context.bubbleTheme;
    final callbacks = context.bubbleCallbacks;
    final selectionMode = context.bubbleScope.isSelectionMode;
    final textColor = selectTextColor(theme);
    final secondaryColor = selectSecondaryTextColor(theme);
    final accent = selectLinkColor(theme);
    final header = buildBubbleHeader(context);
    return buildBubbleContainer(
      context: context,
      child: InkWell(
        onTap: selectionMode || callbacks.onEventOpen == null
            ? null
            : () => callbacks.onEventOpen!(messageId, event.eventId),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ?header,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DateTile(date: event.startsAt, accent: accent),
                BubbleSpacing.gapL,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        event.title,
                        style: theme.messageTextStyle.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          decoration: event.isCancelled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      BubbleSpacing.vGapXS,
                      Text(
                        _timeRange(event.startsAt, event.endsAt),
                        style: theme.captionTextStyle.copyWith(
                          color: secondaryColor,
                        ),
                      ),
                      if (event.location != null)
                        Text(
                          event.location!,
                          style: theme.captionTextStyle.copyWith(
                            color: secondaryColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (event.description != null) ...[
              BubbleSpacing.vGapM,
              Text(
                event.description!,
                style: theme.captionTextStyle.copyWith(color: textColor),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            BubbleSpacing.vGapM,
            Text(
              '${event.attendeeCount} attending',
              style: theme.timeTextStyle.copyWith(color: secondaryColor),
            ),
            if (!event.isCancelled) ...[
              BubbleSpacing.vGapS,
              Wrap(
                spacing: 6,
                children: [
                  _responseChip(context, VEventResponse.going, 'Going'),
                  _responseChip(context, VEventResponse.maybe, 'Maybe'),
                  _responseChip(context, VEventResponse.declined, 'Decline'),
                ],
              ),
            ],
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: buildMeta(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _responseChip(
    BuildContext context,
    VEventResponse response,
    String label,
  ) {
    final selectionMode = context.bubbleScope.isSelectionMode;
    return ChoiceChip(
      key: ValueKey('v-event-${response.name}-${event.eventId}'),
      label: Text(label),
      selected: event.response == response,
      onSelected:
          selectionMode || context.bubbleCallbacks.onEventResponse == null
          ? null
          : (_) =>
                context.bubbleCallbacks.onEventResponse!(messageId, response),
    );
  }

  String _timeRange(DateTime start, DateTime? end) {
    final startText = _clock(start);
    return end == null ? startText : '$startText – ${_clock(end)}';
  }

  String _clock(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}

class _DateTile extends StatelessWidget {
  final DateTime date;
  final Color accent;

  const _DateTile({required this.date, required this.accent});

  @override
  Widget build(BuildContext context) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return Container(
      width: 54,
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BubbleRadius.small,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            months[date.month - 1],
            style: TextStyle(color: accent, fontWeight: FontWeight.w700),
          ),
          Text(
            '${date.day}',
            style: TextStyle(
              color: accent,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
