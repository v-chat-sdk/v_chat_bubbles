import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../core/constants.dart';
import '../../core/enums.dart';
import '../../core/models.dart';
import '../../theme/bubble_theme.dart';
import '../bubble_scope.dart';

/// Horizontal row of reaction emojis for the context menu
class ReactionsRow extends StatelessWidget {
  /// Unique identifier for the message
  final String messageId;

  /// Current reactions on the message (from external data)
  final List<VBubbleReaction> currentReactions;

  /// Available reaction emojis to display
  final List<String> availableReactions;

  /// Theme for styling
  final VBubbleTheme theme;

  /// Whether to enable haptic feedback
  final bool enableHapticFeedback;

  /// Callback when a reaction is tapped
  final void Function(String messageId, String emoji, VReactionAction action)?
      onReaction;

  /// Callback when the "+" button is tapped to show more reactions
  /// If null, built-in emoji picker will be shown
  final void Function(String messageId)? onMoreReactions;

  /// Reaction state manager for internal state
  final ReactionStateManager? reactionStateManager;

  /// Whether to show the "+" button for more reactions
  final bool showMoreButton;
  const ReactionsRow({
    super.key,
    required this.messageId,
    required this.currentReactions,
    required this.availableReactions,
    required this.theme,
    this.enableHapticFeedback = true,
    this.onReaction,
    this.onMoreReactions,
    this.reactionStateManager,
    this.showMoreButton = true,
  });
  @override
  Widget build(BuildContext context) {
    // Total items = reactions + 1 for "+" button
    final itemCount =
        availableReactions.length + (showMoreButton ? 1 : 0);
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: theme.menuBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          // Last item is the "+" button
          if (showMoreButton && index == availableReactions.length) {
            return _MoreReactionsButton(
              theme: theme,
              onTap: () => _handleMoreTap(context),
            );
          }
          final emoji = availableReactions[index];
          final isSelected = _isEmojiSelected(emoji);
          return _ReactionButton(
            emoji: emoji,
            isSelected: isSelected,
            theme: theme,
            onTap: () => _handleReactionTap(context, emoji, isSelected),
          );
        },
      ),
    );
  }

  bool _isEmojiSelected(String emoji) {
    // Check internal state manager first
    if (reactionStateManager != null) {
      return reactionStateManager!.isReactionSelected(messageId, emoji);
    }
    // Fallback to external reactions data
    return currentReactions.any((r) => r.emoji == emoji && r.isSelected);
  }

  void _handleReactionTap(BuildContext context, String emoji, bool isSelected) {
    if (enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    // Delay pop to allow CupertinoContextMenu animation to complete
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
    // Update internal state manager
    VReactionAction action;
    if (reactionStateManager != null) {
      action = reactionStateManager!.setReaction(messageId, emoji);
    } else {
      action = isSelected ? VReactionAction.remove : VReactionAction.add;
    }
    // Notify parent via callback
    onReaction?.call(messageId, emoji, action);
  }

  void _handleMoreTap(BuildContext context) {
    if (enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    // Close the context menu first
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
    // If custom callback is provided, use it
    if (onMoreReactions != null) {
      onMoreReactions!.call(messageId);
      return;
    }
    // Otherwise show built-in emoji picker
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        _showEmojiPicker(context);
      }
    });
  }

  void _showEmojiPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _EmojiPickerSheet(
        theme: theme,
        onEmojiSelected: (emoji) {
          Navigator.of(sheetContext).pop();
          if (enableHapticFeedback) {
            HapticFeedback.lightImpact();
          }
          // Update internal state manager
          VReactionAction action;
          if (reactionStateManager != null) {
            action = reactionStateManager!.setReaction(messageId, emoji);
          } else {
            action = VReactionAction.add;
          }
          onReaction?.call(messageId, emoji, action);
        },
      ),
    );
  }
}

/// Built-in emoji picker bottom sheet
class _EmojiPickerSheet extends StatelessWidget {
  final VBubbleTheme theme;
  final void Function(String emoji) onEmojiSelected;
  const _EmojiPickerSheet({
    required this.theme,
    required this.onEmojiSelected,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        color: theme.menuBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.menuTextColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Emoji picker
          Expanded(
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                onEmojiSelected(emoji.emoji);
              },
              config: Config(
                height: double.infinity,
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(
                  columns: 8,
                  emojiSizeMax: 28 * (defaultTargetPlatform == TargetPlatform.iOS ? 1.2 : 1.0),
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  backgroundColor: theme.menuBackground,
                  noRecents: const Text(
                    'No Recents',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  loadingIndicator: const SizedBox.shrink(),
                ),
                categoryViewConfig: CategoryViewConfig(
                  initCategory: Category.RECENT,
                  backgroundColor: theme.menuBackground,
                  indicatorColor: theme.readIconColor,
                  iconColorSelected: theme.readIconColor,
                  iconColor: theme.menuTextColor.withValues(alpha: 0.5),
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                ),
                bottomActionBarConfig: const BottomActionBarConfig(enabled: false),
                searchViewConfig: SearchViewConfig(
                  backgroundColor: theme.menuBackground,
                  buttonIconColor: theme.menuTextColor,
                  hintText: 'Search emoji',
                  hintTextStyle: TextStyle(
                    color: theme.menuTextColor.withValues(alpha: 0.5),
                  ),
                ),
                skinToneConfig: SkinToneConfig(
                  dialogBackgroundColor: isDark ? Colors.grey[800]! : Colors.white,
                  indicatorColor: theme.readIconColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReactionButton extends StatefulWidget {
  final String emoji;
  final bool isSelected;
  final VBubbleTheme theme;
  final VoidCallback onTap;
  const _ReactionButton({
    required this.emoji,
    required this.isSelected,
    required this.theme,
    required this.onTap,
  });
  @override
  State<_ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<_ReactionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isSelected ? 7 : 6,
            vertical: widget.isSelected ? 5 : 4,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.theme.readIconColor.withValues(alpha: 0.15)
                : CupertinoColors.transparent,
            borderRadius: BubbleRadius.small,
            border: widget.isSelected
                ? Border.all(
                    color: widget.theme.readIconColor,
                    width: 1.5,
                  )
                : null,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: widget.isSelected ? 24 : 22,
              decoration: TextDecoration.none,
              decorationColor: const Color(0x00000000),
              backgroundColor: const Color(0x00000000),
              height: 1.0,
            ),
            child: Text(widget.emoji),
          ),
        ),
      ),
    );
  }
}

/// "+" button to show more reactions / emoji picker
class _MoreReactionsButton extends StatefulWidget {
  final VBubbleTheme theme;
  final VoidCallback onTap;
  const _MoreReactionsButton({
    required this.theme,
    required this.onTap,
  });
  @override
  State<_MoreReactionsButton> createState() => _MoreReactionsButtonState();
}

class _MoreReactionsButtonState extends State<_MoreReactionsButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: widget.theme.menuTextColor.withValues(alpha: 0.1),
            borderRadius: BubbleRadius.small,
          ),
          child: Icon(
            CupertinoIcons.add,
            size: 22,
            color: widget.theme.menuTextColor.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
