import 'package:flutter/cupertino.dart';
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

  /// Reaction state manager for internal state
  final ReactionStateManager? reactionStateManager;
  const ReactionsRow({
    super.key,
    required this.messageId,
    required this.currentReactions,
    required this.availableReactions,
    required this.theme,
    this.enableHapticFeedback = true,
    this.onReaction,
    this.reactionStateManager,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: theme.menuBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: availableReactions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
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
