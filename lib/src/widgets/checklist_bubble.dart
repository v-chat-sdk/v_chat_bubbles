import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/modern_message_models.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';

/// Collaborative checklist message with controlled completion state.
class VChecklistBubble extends BaseBubble {
  final VChecklistData checklist;

  @override
  String get messageType => 'checklist';

  const VChecklistBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.checklist,
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
    final header = buildBubbleHeader(context);
    return buildBubbleContainer(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ?header,
          Row(
            children: [
              Icon(Icons.checklist_rounded, color: textColor),
              BubbleSpacing.gapM,
              Expanded(
                child: Text(
                  checklist.title,
                  style: theme.messageTextStyle.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${checklist.completedCount}/${checklist.items.length}',
                style: theme.timeTextStyle.copyWith(color: secondaryColor),
              ),
            ],
          ),
          BubbleSpacing.vGapM,
          ClipRRect(
            borderRadius: BubbleRadius.extraSmall,
            child: LinearProgressIndicator(
              value: checklist.progress,
              minHeight: 4,
              color: selectLinkColor(theme),
              backgroundColor: textColor.withValues(alpha: 0.12),
            ),
          ),
          BubbleSpacing.vGapL,
          ...checklist.items.map(
            (item) => _buildItem(
              context,
              item,
              enabled:
                  checklist.canEdit &&
                  !selectionMode &&
                  callbacks.onChecklistItemToggle != null,
            ),
          ),
          if (checklist.canAddItems &&
              !selectionMode &&
              callbacks.onChecklistAddItem != null)
            TextButton.icon(
              key: ValueKey('v-checklist-add-$messageId'),
              onPressed: () => callbacks.onChecklistAddItem!(messageId),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add item'),
            ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: buildMeta(context),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    VChecklistItem item, {
    required bool enabled,
  }) {
    final theme = context.bubbleTheme;
    final callbacks = context.bubbleCallbacks;
    final textColor = selectTextColor(theme);
    final secondaryColor = selectSecondaryTextColor(theme);
    return Semantics(
      checked: item.isCompleted,
      button: enabled,
      child: InkWell(
        key: ValueKey('v-checklist-item-${item.id}'),
        onTap: enabled
            ? () => callbacks.onChecklistItemToggle!(
                messageId,
                item.id,
                !item.isCompleted,
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                item.isCompleted
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                color: item.isCompleted ? selectLinkColor(theme) : textColor,
              ),
              BubbleSpacing.gapM,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.text,
                      style: theme.messageTextStyle.copyWith(
                        color: textColor,
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (item.assigneeName != null)
                      Text(
                        item.assigneeName!,
                        style: theme.timeTextStyle.copyWith(
                          color: secondaryColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
