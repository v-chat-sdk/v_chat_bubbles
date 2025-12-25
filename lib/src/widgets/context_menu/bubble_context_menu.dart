import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../core/callbacks.dart';
import '../../core/config.dart' show VBubbleConfig, VTranslationConfig;
import '../../core/constants.dart';
import '../../core/context_menu_config.dart';
import '../../core/enums.dart';
import '../../core/models.dart';
import '../../theme/bubble_theme.dart';
import '../bubble_scope.dart';
import 'reactions_row.dart';

/// Maps a menu item ID to its corresponding VMessageAction
VMessageAction? _actionForItem(VBubbleMenuItem item) {
  switch (item.id) {
    case 'reply':
      return VMessageAction.reply;
    case 'forward':
      return VMessageAction.forward;
    case 'copy':
      return VMessageAction.copy;
    case 'download':
      return VMessageAction.download;
    case 'edit':
      return VMessageAction.edit;
    case 'delete':
      return VMessageAction.delete;
    case 'pin':
      return VMessageAction.pin;
    case 'star':
      return VMessageAction.star;
    case 'report':
      return VMessageAction.report;
    default:
      return null;
  }
}

/// iOS-style context menu wrapper for chat bubbles
///
/// Provides a native iOS context menu experience with:
/// - Bubble preview with zoom effect
/// - Reactions row at the top
/// - Action items (Reply, Forward, Copy, etc.)
///
/// Usage:
/// ```dart
/// BubbleContextMenuWrapper(
///   messageId: 'msg_123',
///   messageType: 'text',
///   isMeSender: true,
///   currentReactions: [],
///   child: YourBubbleWidget(),
/// )
/// ```
class BubbleContextMenuWrapper extends StatelessWidget {
  /// The bubble widget to wrap
  final Widget child;

  /// Unique message identifier
  final String messageId;

  /// Type of message (text, image, etc.)
  final String messageType;

  /// Whether this message is from the current user
  final bool isMeSender;

  /// Current reactions on the message
  final List<VBubbleReaction> currentReactions;

  /// Whether context menu is enabled
  final bool enabled;
  const BubbleContextMenuWrapper({
    super.key,
    required this.child,
    required this.messageId,
    required this.messageType,
    required this.isMeSender,
    this.currentReactions = const [],
    this.enabled = true,
  });
  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    final scope = context.bubbleScope;
    final config = scope.config;
    final menuConfig = config.contextMenu;
    if (!menuConfig.enableBuiltInMenu) return child;
    if (!config.gestures.enableLongPress) return child;
    // Capture all scope data upfront since CupertinoContextMenu creates a new overlay
    final theme = scope.theme;
    final style = scope.style;
    final callbacks = scope.callbacks;
    final reactionStateManager = scope.reactionStateManager;
    final menuItems = scope.getMenuItemsFor(messageId, messageType, isMeSender);
    // Build actions list with captured data (not from context)
    final actions = _buildActionsWithData(
      theme: theme,
      style: style,
      config: config,
      callbacks: callbacks,
      menuConfig: menuConfig,
      reactionStateManager: reactionStateManager,
      menuItems: menuItems,
    );
    return CupertinoContextMenu.builder(
      enableHapticFeedback: config.gestures.enableHapticFeedback,
      actions: actions,
      builder: (builderContext, animation) {
        // Don't access scope here - use captured data or simple decoration
        final isOpen = animation.value >= CupertinoContextMenu.animationOpensAt;
        final decoration = isOpen
            ? BoxDecoration(
                borderRadius: BubbleRadius.standard,
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              )
            : null;
        // When opened, constrain the preview size to fit screen
        // Wrap with Material for proper text rendering in Cupertino overlay
        Widget preview = Material(
          type: MaterialType.transparency,
          child: VBubbleScopeData(
            style: style,
            theme: theme,
            config: config,
            callbacks: callbacks,
            menuItemsBuilder: scope.menuItemsBuilder,
            isSelectionMode: scope.isSelectionMode,
            selectedIds: scope.selectedIds,
            expandStateManager: scope.expandStateManager,
            reactionStateManager: reactionStateManager,
            child: child,
          ),
        );
        if (isOpen) {
          // Get screen size for constraints
          final screenSize = MediaQuery.of(builderContext).size;
          final maxPreviewHeight = screenSize.height * 0.4;
          final maxPreviewWidth = screenSize.width * 0.9;
          preview = Container(
            decoration: decoration,
            constraints: BoxConstraints(
              maxHeight: maxPreviewHeight,
              maxWidth: maxPreviewWidth,
            ),
            child: ClipRRect(
              borderRadius: BubbleRadius.standard,
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: preview,
              ),
            ),
          );
        }
        return preview;
      },
    );
  }

  List<Widget> _buildActionsWithData({
    required VBubbleTheme theme,
    required VBubbleStyle style,
    required VBubbleConfig config,
    required VBubbleCallbacks callbacks,
    required VContextMenuConfig menuConfig,
    required ReactionStateManager reactionStateManager,
    required List<VBubbleMenuItem> menuItems,
  }) {
    final actions = <Widget>[];
    // Reactions row
    if (menuConfig.showReactions) {
      final reactions =
          menuConfig.customReactions ?? VBubbleTheme.reactionsForStyle(style);
      actions.add(
        ReactionsRow(
          messageId: messageId,
          currentReactions: currentReactions,
          availableReactions: reactions,
          theme: theme,
          enableHapticFeedback: config.gestures.enableHapticFeedback,
          onReaction: callbacks.onReaction,
          reactionStateManager: reactionStateManager,
        ),
      );
    }
    // Menu items
    for (final item in menuItems) {
      final action = _actionForItem(item);
      if (action != null && !menuConfig.availableActions.contains(action)) {
        continue;
      }
      actions.add(
        _ContextMenuItem(
          item: item,
          theme: theme,
          enableHapticFeedback: config.gestures.enableHapticFeedback,
          onTap: callbacks.onMenuItemSelected,
          messageId: messageId,
          translations: config.translations,
        ),
      );
    }
    return actions;
  }
}

/// Individual context menu action item
class _ContextMenuItem extends StatelessWidget {
  final VBubbleMenuItem item;
  final VBubbleTheme theme;
  final bool enableHapticFeedback;
  final void Function(String messageId, VBubbleMenuItem item)? onTap;
  final String messageId;
  final VTranslationConfig translations;
  const _ContextMenuItem({
    required this.item,
    required this.theme,
    required this.enableHapticFeedback,
    required this.onTap,
    required this.messageId,
    required this.translations,
  });
  @override
  Widget build(BuildContext context) {
    final isDestructive = item.isDestructive;
    final textColor =
        isDestructive ? theme.menuDestructiveColor : theme.menuTextColor;
    // Use translated label, falling back to item.label for custom items
    final label = translations.labelForMenuItemId(item.id, fallback: item.label);
    return CupertinoContextMenuAction(
      onPressed: () {
        if (enableHapticFeedback) {
          HapticFeedback.selectionClick();
        }
        // Delay pop to allow CupertinoContextMenu animation to complete
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });
        onTap?.call(messageId, item);
      },
      isDestructiveAction: isDestructive,
      trailingIcon: item.icon,
      child: Text(
        label,
        style: TextStyle(color: textColor),
      ),
    );
  }
}

/// Simple wrapper that shows context menu on long press without CupertinoContextMenu
///
/// Alternative for cases where CupertinoContextMenu animation is not desired.
/// Shows a modal bottom sheet with reactions and actions.
class BubbleContextMenuSheet extends StatelessWidget {
  final String messageId;
  final String messageType;
  final bool isMeSender;
  final List<VBubbleReaction> currentReactions;
  const BubbleContextMenuSheet({
    super.key,
    required this.messageId,
    required this.messageType,
    required this.isMeSender,
    this.currentReactions = const [],
  });

  /// Show the context menu as a modal bottom sheet
  static Future<void> show({
    required BuildContext context,
    required String messageId,
    required String messageType,
    required bool isMeSender,
    List<VBubbleReaction> currentReactions = const [],
  }) {
    // Capture scope data before showing popup
    final scope = context.bubbleScope;
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => VBubbleScopeData(
        style: scope.style,
        theme: scope.theme,
        config: scope.config,
        callbacks: scope.callbacks,
        menuItemsBuilder: scope.menuItemsBuilder,
        isSelectionMode: scope.isSelectionMode,
        selectedIds: scope.selectedIds,
        expandStateManager: scope.expandStateManager,
        reactionStateManager: scope.reactionStateManager,
        child: BubbleContextMenuSheet(
          messageId: messageId,
          messageType: messageType,
          isMeSender: isMeSender,
          currentReactions: currentReactions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = context.bubbleScope;
    final theme = scope.theme;
    final config = scope.config;
    final callbacks = scope.callbacks;
    final menuConfig = config.contextMenu;
    final reactionStateManager = scope.reactionStateManager;
    final menuItems = scope.getMenuItemsFor(messageId, messageType, isMeSender);
    final translations = config.translations;
    return CupertinoActionSheet(
      title: menuConfig.showReactions
          ? ReactionsRow(
              messageId: messageId,
              currentReactions: currentReactions,
              availableReactions: menuConfig.customReactions ??
                  VBubbleTheme.reactionsForStyle(scope.style),
              theme: theme,
              enableHapticFeedback: config.gestures.enableHapticFeedback,
              onReaction: callbacks.onReaction,
              reactionStateManager: reactionStateManager,
            )
          : null,
      actions: menuItems
          .where((item) {
            final action = _actionForItem(item);
            return action == null ||
                menuConfig.availableActions.contains(action);
          })
          .map((item) {
            final label =
                translations.labelForMenuItemId(item.id, fallback: item.label);
            return CupertinoActionSheetAction(
              onPressed: () {
                if (config.gestures.enableHapticFeedback) {
                  HapticFeedback.selectionClick();
                }
                Navigator.of(context).pop();
                callbacks.onMenuItemSelected?.call(messageId, item);
              },
              isDestructiveAction: item.isDestructive,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: item.isDestructive
                        ? theme.menuDestructiveColor
                        : theme.menuTextColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(label),
                ],
              ),
            );
          })
          .toList(),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(translations.contextMenuCancel),
      ),
    );
  }
}
