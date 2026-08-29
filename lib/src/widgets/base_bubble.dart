import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/callbacks.dart';
import '../core/config.dart';
import '../core/constants.dart';
import '../core/enums.dart';
import '../core/models.dart';
import '../core/modern_message_models.dart';
import '../theme/bubble_theme.dart';

import 'bubble_scope.dart';
import 'bubble_wrapper.dart';
import 'package:v_platform/v_platform.dart';

import 'context_menu/bubble_context_menu.dart';
import 'shared/adaptive_bubble_interaction.dart';
import 'shared/swipe_to_reply_wrapper.dart';
import 'shared/bubble_avatar.dart';
import 'shared/bubble_header.dart';
import 'shared/bubble_footer.dart';
import 'shared/color_selector_mixin.dart';

/// Abstract base class for all bubble widgets
abstract class BaseBubble extends StatelessWidget with ColorSelectorMixin {
  /// Unique message identifier
  final String messageId;

  /// Whether this message is from the current user (sent by me)
  @override
  final bool isMeSender;

  /// Message timestamp formatted string
  final String time;

  /// Message delivery status
  final VMessageStatus status;

  /// Whether this message is from the same sender as the previous message
  /// When true: no tail, no avatar, smaller spacing (sameSenderSpacing)
  /// When false: show tail, show avatar, larger spacing (differentSenderSpacing)
  final bool isSameSender;

  /// Automatically resolved position in a sender/time-based message group.
  ///
  /// When supplied, this takes precedence over legacy [isSameSender] layout
  /// behavior. Omitting it preserves the pre-2.0 grouping contract.
  final VMessageGroupPosition? groupPosition;

  /// Sender avatar image source (for incoming messages in groups)
  /// Supports network URLs, local files, assets, and memory images
  final VPlatformFile? avatar;

  /// Sender name (for incoming messages in groups)
  final String? senderName;

  /// Sender name color
  final Color? senderColor;

  /// Reply data if this is a reply message
  final VReplyData? replyTo;

  /// Forward data if this is a forwarded message
  final VForwardData? forwardedFrom;

  /// List of reactions on this message
  final List<VBubbleReaction> reactions;

  /// Whether message is edited
  final bool isEdited;

  /// Detailed delivery, receipt, retry, and edit history metadata.
  final VMessageLifecycleData? lifecycle;

  /// Whether message is pinned
  final bool isPinned;

  /// Whether message is starred
  final bool isStarred;

  /// Whether to show search highlight
  final bool isHighlighted;

  /// Inline search query for highlighting matched substrings inside the bubble.
  ///
  /// When non-null and non-empty, every case-insensitive occurrence of
  /// [searchQuery] inside textual content is rendered with
  /// [searchHighlightStyle] (or the theme's `searchHighlightStyle` when null),
  /// similar to the screenshot's red "h" highlights. This is separate from
  /// [isHighlighted] which highlights the whole bubble.
  final String? searchQuery;

  /// Override for the inline search highlight style.
  ///
  /// If null, the theme's `VBubbleTheme.searchHighlightStyle` is used.
  final TextStyle? searchHighlightStyle;
  const BaseBubble({
    super.key,
    required this.messageId,
    required this.isMeSender,
    required this.time,
    this.status = VMessageStatus.sent,
    this.isSameSender = false,
    this.groupPosition,
    this.avatar,
    this.senderName,
    this.senderColor,
    this.replyTo,
    this.forwardedFrom,
    this.reactions = const [],
    this.isEdited = false,
    this.lifecycle,
    this.isPinned = false,
    this.isStarred = false,
    this.isHighlighted = false,
    this.searchQuery,
    this.searchHighlightStyle,
  });

  /// Whether this bubble is visually joined to the preceding message.
  bool get isGroupedWithPrevious =>
      groupPosition?.joinsPrevious ?? isSameSender;

  /// Whether this bubble terminates its visual group.
  bool get showsGroupEnd => groupPosition?.showsGroupEnd ?? !isSameSender;

  /// Resolves the tail visibility for this bubble using the global
  /// [VBubbleConfig.showTails] flag. When `showTails` is false, no tails
  /// are rendered regardless of grouping. This is used uniformly across all
  /// bubble styles including Messenger (per plan: uniform forced-false).
  bool effectiveShowTail(BuildContext context) =>
      context.bubbleConfig.showTails ? showsGroupEnd : false;

  /// Build the main content of the bubble
  Widget buildContent(BuildContext context);

  /// Get the message type name for accessibility (override in subclasses)
  String get messageType => 'message';

  /// Get the semantic label for this message
  String _getSemanticLabel(BuildContext context) {
    final config = context.bubbleConfig;
    final translations = config.translations;
    final direction = isMeSender
        ? translations.statusSent
        : translations.statusReceived;
    final statusText = isMeSender ? ', ${status.name}' : '';
    final editedText = isEdited ? ', ${translations.statusEdited}' : '';
    final pinnedText = isPinned ? ', ${translations.statusPinned}' : '';
    final starredText = isStarred ? ', ${translations.statusStarred}' : '';
    if (config.accessibility.semanticLabelBuilder != null) {
      return config.accessibility.semanticLabelBuilder!(
        messageType,
        '$direction $messageType at $time$statusText$editedText$pinnedText$starredText',
      );
    }
    final senderInfo = senderName != null ? 'from $senderName, ' : '';
    return '$direction $messageType, $senderInfo$time$statusText$editedText$pinnedText$starredText';
  }

  @override
  Widget build(BuildContext context) {
    final scope = context.bubbleScope;
    final theme = scope.theme;
    final config = scope.config;
    final callbacks = scope.callbacks;
    final isSelectionMode = scope.isSelectionMode;
    final isSelected = scope.isSelected(messageId);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxBubbleWidth = config.getEffectiveMaxWidth(screenWidth);
    final isWideScreen = screenWidth >= config.sizing.wideScreenBreakpoint;
    final horizontalMargin = isWideScreen
        ? config.spacing.horizontalMargin * 2
        : config.spacing.horizontalMargin;
    final oppositeMargin = isWideScreen ? horizontalMargin : 50.0;
    const selectionIndicatorWidth = 44.0;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // RTL Layout Support - Flutter's Row automatically mirrors in RTL
    // MainAxisAlignment.end becomes LEFT in RTL, which is correct for sender
    // No need to flip isMeSender - let Flutter handle it naturally
    final showTail = effectiveShowTail(context);
    final showAvatar = showsGroupEnd;
    // Build bubble content
    final bubbleContent = Row(
      mainAxisAlignment: isMeSender
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isMeSender && config.avatar.show) ...[
          if (showAvatar)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              // Disable avatar tap in selection mode
              onTap: isSelectionMode
                  ? null
                  : () => callbacks.onAvatarTap?.call(messageId),
              child: buildAvatarWidget(context),
            )
          else
            SizedBox(width: config.avatar.size),
          BubbleSpacing.gapL,
        ],
        Flexible(
          child: VSwipeToReplyWrapper(
            isMeSender: isMeSender,
            onSwipe:
                (config.gestures.enableSwipeToReply &&
                    callbacks.onSwipeReply != null)
                ? () => callbacks.onSwipeReply!(messageId)
                : null,
            swipeThreshold: config.gestures.swipeThreshold,
            animationDuration: config.animation.swipe,
            animationCurve: config.animation.defaultCurve,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxBubbleWidth,
                minWidth: config.sizing.minWidth,
              ),
              child: _buildInteractiveWrapper(
                context: context,
                config: config,
                callbacks: callbacks,
                theme: theme,
                style: scope.style,
                isSelectionMode: isSelectionMode,
                showTail: showTail,
                bubbleContent: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isHighlighted ? const Color(0x33FFEB3B) : null,
                    border: config.accessibility.enableHighContrast
                        ? Border.all(color: selectTextColor(theme), width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(
                      config.spacing.bubbleRadius,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: isMeSender
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildContent(context),
                      buildReactionsWidget(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    final rowContent = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Selection indicator at far left (Telegram style)
        if (isSelectionMode)
          SizedBox(
            width: selectionIndicatorWidth,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.selectionCheckmarkColor
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? theme.selectionCheckmarkColor
                        : isDarkMode
                        ? Colors.white
                        : Colors.black54,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: BubbleSizes.iconMedium,
                      )
                    : null,
              ),
            ),
          ),
        // Bubble content
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: isSelectionMode
                  ? 0
                  : isMeSender
                  ? oppositeMargin
                  : horizontalMargin,
              right: isMeSender ? horizontalMargin : oppositeMargin,
            ),
            child: bubbleContent,
          ),
        ),
      ],
    );
    Widget bubble = Padding(
      padding: EdgeInsets.only(
        top: isGroupedWithPrevious
            ? config.spacing.sameSenderSpacing
            : config.spacing.differentSenderSpacing,
      ),
      // In selection mode, wrap entire row for full-width tap target
      child: isSelectionMode
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _handleTap(context),
              child: rowContent,
            )
          : rowContent,
    );
    if (config.accessibility.enableSemanticLabels) {
      bubble = Semantics(
        label: _getSemanticLabel(context),
        button: true,
        child: ExcludeSemantics(child: bubble),
      );
    }
    return bubble;
  }

  /// Build the avatar widget with fallback to placeholder
  ///
  /// Renders the avatar in this priority:
  /// 1. [avatar] VPlatformFile if provided
  /// 2. Letter avatar from [senderName] with auto-generated color
  /// 3. Default placeholder icon
  ///
  /// Custom bubbles can override this for custom avatar rendering.
  @protected
  /// Uses [VBubbleAvatar] widget.
  @protected
  Widget buildAvatarWidget(BuildContext context) {
    return VBubbleAvatar(
      isMeSender: isMeSender,
      avatar: avatar,
      senderName: senderName,
      senderColor: senderColor,
      callbacks: context.bubbleCallbacks,
      messageId: messageId,
    );
  }

  /// Build the default avatar placeholder
  ///
  /// Delegated to [VBubbleAvatar].kept for backwards compatibility if needed,
  /// but ideally should be removed or deprecated.
  @protected
  Widget buildAvatarPlaceholder(double size) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey[400],
      child: Icon(Icons.person, size: size * 0.6, color: Colors.white),
    );
  }

  /// Build the bubble header section containing forward indicator, sender name, and reply preview
  ///
  /// Returns null if no header content is needed.
  /// Custom bubbles can use this to add standard header elements.
  @protected
  /// Uses [VBubbleHeader] widget.
  @protected
  Widget? buildBubbleHeader(BuildContext context) {
    // Check if there's any header content to show
    final showSenderName = senderName != null && !isMeSender;
    if (forwardedFrom == null && !showSenderName && replyTo == null) {
      return null;
    }
    return VBubbleHeader(
      isMeSender: isMeSender,
      forwardedFrom: forwardedFrom,
      senderName: senderName,
      senderColor: senderColor,
      replyTo: replyTo,
      callbacks: context.bubbleCallbacks,
      messageId: messageId,
    );
  }

  /// Build the reactions widget row
  ///
  /// Shows emoji reaction pills with counts.
  /// Combines external reactions with internal user-selected state.
  @protected
  Widget buildReactionsWidget(BuildContext context) {
    final theme = context.bubbleTheme;
    final callbacks = context.bubbleCallbacks;
    final reactionStateManager = context.reactionStateManager;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    return ListenableBuilder(
      listenable: reactionStateManager,
      builder: (context, _) {
        final effectiveReactions = getEffectiveReactions(reactionStateManager);
        if (effectiveReactions.isEmpty) return const SizedBox.shrink();
        final maxVisible =
            context.bubbleConfig.contextMenu.maxVisibleReactionPills;
        final visibleReactions = effectiveReactions.take(maxVisible).toList();
        final overflowCount =
            effectiveReactions.length - visibleReactions.length;
        return Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              ...visibleReactions.map((reaction) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  // Disable reaction tap in selection mode
                  onTapUp: isSelectionMode
                      ? null
                      : (details) {
                          callbacks.onReactionDetailsTap?.call(
                            messageId,
                            reaction,
                            details.globalPosition,
                          );
                          callbacks.onReactionTap?.call(
                            messageId,
                            reaction.emoji,
                            details.globalPosition,
                          );
                        },
                  child: Tooltip(
                    message: reaction.actors.isEmpty
                        ? reaction.emoji
                        : reaction.actors
                              .map((actor) => actor.displayName)
                              .join(', '),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: reaction.isSelected
                            ? theme.reactionSelectedBackground
                            : theme.reactionBackground,
                        borderRadius: BubbleRadius.standard,
                        border: Border.all(
                          color: theme.reactionTextColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            reaction.emoji,
                            style: TextStyle(fontSize: BubbleSizes.iconSmall),
                          ),
                          if (reaction.count > 1) ...[
                            BubbleSpacing.gapXS,
                            Text(
                              '${reaction.count}',
                              style: TextStyle(
                                fontSize: BubbleSizes.iconTiny,
                                color: theme.reactionTextColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }),
              if (overflowCount > 0)
                Container(
                  key: ValueKey('v-reaction-overflow-$messageId'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: theme.reactionBackground,
                    borderRadius: BubbleRadius.standard,
                  ),
                  child: Text(
                    '+$overflowCount',
                    style: TextStyle(
                      fontSize: BubbleSizes.iconTiny,
                      color: theme.reactionTextColor,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Combines external reactions with internal user-selected state
  ///
  /// Merges the [reactions] list with user's selection from [stateManager].
  @protected
  List<VBubbleReaction> getEffectiveReactions(
    ReactionStateManager stateManager,
  ) {
    final userSelectedEmojis = stateManager.getSelectedReactions(messageId);
    // If no user selection and no external reactions, return empty
    if (userSelectedEmojis.isEmpty && reactions.isEmpty) {
      return [];
    }
    // If no user selection, return external reactions as-is
    if (userSelectedEmojis.isEmpty) {
      return reactions;
    }
    final externalEmoji = reactions.map((reaction) => reaction.emoji).toSet();
    final effectiveReactions = reactions
        .map(
          (reaction) => reaction.copyWith(
            isSelected: userSelectedEmojis.contains(reaction.emoji),
          ),
        )
        .toList();
    for (final emoji in userSelectedEmojis.difference(externalEmoji)) {
      effectiveReactions.add(
        VBubbleReaction(emoji: emoji, count: 1, isSelected: true),
      );
    }
    return effectiveReactions;
  }

  /// Build the metadata row with timestamp, status, and flags
  ///
  /// Shows starred/pinned/edited indicators, timestamp, and status icon (for sender).
  /// Custom bubbles should use this for consistent metadata display.
  @protected
  /// Uses [VBubbleFooter] widget.
  @protected
  Widget buildMeta(BuildContext context, {Color? overrideColor}) {
    return VBubbleFooter(
      isMeSender: isMeSender,
      time: time,
      status: status,
      isStarred: isStarred,
      isPinned: isPinned,
      isEdited: isEdited,
      lifecycle: lifecycle,
      overrideColor: overrideColor,
    );
  }

  /// Build just the timestamp widget.
  /// Uses [VBubbleFooter] with hidden status/flags if possible, but simplest to generic Text
  /// or we can expose a specific small widget. For now, we'll keep the simple Text return
  /// to avoid breaking changes if this is called directly, but we encourage using buildMeta/VBubbleFooter.
  @protected
  Widget buildTimestamp(BuildContext context, {Color? overrideColor}) {
    final theme = context.bubbleTheme;
    final defaultMetaColor = selectSecondaryTextColor(theme);
    final metaColor = overrideColor ?? defaultMetaColor;
    return Text(time, style: theme.timeTextStyle.copyWith(color: metaColor));
  }

  // buildStatusIcon is removed/delegated. If we need it for backward compat:
  @protected
  Widget buildStatusIcon(BuildContext context, {Color? overrideColor}) {
    // We can't easily reuse VBubbleFooter for JUST the icon without refactoring VBubbleFooter to expose it.
    // For now, I'll keep the logic here to avoid breaking changes for subclasses that might use it,
    // but the main buildMeta uses VBubbleFooter.
    // Actually, to reduce complexity, I should verify if any subclasses use this.
    // Assuming they might, I'll copy the logic from VBubbleFooter or just duplicate it briefly.
    // Given the task is complexity reduction, keeping it here is counter-intuitive but safer than breaking.
    // I Will simplify it.

    final theme = context.bubbleTheme;
    final statusConfig = theme.statusIcons;
    Color color = overrideColor ?? _getStatusColor(theme);

    return Icon(
      statusConfig.iconFor(status),
      size: statusConfig.size,
      color: color,
    );
  }

  Color _getStatusColor(VBubbleTheme theme) {
    switch (status) {
      case VMessageStatus.sending:
        return theme.pendingIconColor;
      case VMessageStatus.sent:
        return theme.sentIconColor;
      case VMessageStatus.delivered:
        return theme.deliveredIconColor;
      case VMessageStatus.read:
        return theme.readIconColor;
      case VMessageStatus.error:
        return theme.errorColor;
    }
  }

  /// Build a standard bubble container with VBubbleWrapper
  ///
  /// Convenience method for custom bubbles to wrap their content in a styled bubble.
  /// Uses the current theme and config for consistent styling.
  ///
  /// Parameters:
  /// - [child]: The content widget to wrap
  /// - [showTail]: Whether to show the bubble tail (defaults to !isSameSender)
  /// - [padding]: Custom padding (defaults to config spacing)
  /// - [maxWidth]: Maximum width constraint
  /// - [backgroundColor]: Override bubble color
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Widget buildContent(BuildContext context) {
  ///   return buildBubbleContainer(
  ///     context: context,
  ///     child: Column(
  ///       children: [
  ///         buildBubbleHeader(context) ?? const SizedBox.shrink(),
  ///         Text('Custom content'),
  ///         buildMeta(context),
  ///       ],
  ///     ),
  ///   );
  /// }
  /// ```
  @protected
  Widget buildBubbleContainer({
    required BuildContext context,
    required Widget child,
    bool? showTail,
    EdgeInsetsGeometry? padding,
    double? maxWidth,
    Color? backgroundColor,
  }) {
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: showTail ?? effectiveShowTail(context),
      maxWidth: maxWidth,
      backgroundColor: backgroundColor,
      padding: padding,
      child: child,
    );
  }

  /// Wraps bubble content with tap gesture and context menu
  Widget _buildInteractiveWrapper({
    required BuildContext context,
    required VBubbleConfig config,
    required VBubbleCallbacks callbacks,
    required VBubbleTheme theme,
    required VBubbleStyle style,
    required bool isSelectionMode,
    required bool showTail,
    required Widget bubbleContent,
  }) {
    // In selection mode, gesture is handled at the row level (full width tap)
    // See build() method where the outer Row is wrapped with GestureDetector
    if (isSelectionMode) {
      return bubbleContent;
    }
    // Check if user provided custom onLongPress callback
    final hasCustomLongPress = callbacks.onLongPress != null;
    // Use built-in menu only if enabled AND no custom callback provided
    final useBuiltInMenu =
        config.gestures.enableLongPress &&
        config.contextMenu.enableBuiltInMenu &&
        !hasCustomLongPress;
    Widget child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _handleTap(context),
      onDoubleTap: config.gestures.enableDoubleTapToReact
          ? () => _handleDoubleTap(context)
          : null,
      // Use custom onLongPress if provided
      onLongPressStart: hasCustomLongPress && config.gestures.enableLongPress
          ? (details) =>
                callbacks.onLongPress!(messageId, details.globalPosition)
          : null,
      child: bubbleContent,
    );
    if (useBuiltInMenu) {
      child = BubbleContextMenuWrapper(
        messageId: messageId,
        messageType: messageType,
        isMeSender: isMeSender,
        currentReactions: reactions,
        enabled: useBuiltInMenu,
        child: child,
      );
    }

    ValueChanged<Offset>? onShowContextMenu;
    if (hasCustomLongPress) {
      onShowContextMenu = (position) =>
          callbacks.onLongPress!(messageId, position);
    } else if (config.contextMenu.enableBuiltInMenu) {
      onShowContextMenu = (_) => BubbleContextMenuSheet.show(
        context: context,
        messageId: messageId,
        messageType: messageType,
        isMeSender: isMeSender,
        currentReactions: reactions,
      );
    }

    return VAdaptiveBubbleInteraction(
      messageId: messageId,
      isMeSender: isMeSender,
      enableHoverActions: config.gestures.enableHoverActions,
      enableSecondaryTap: config.gestures.enableSecondaryTap,
      enableKeyboardShortcuts: config.gestures.enableKeyboardShortcuts,
      minTapTargetSize: config.accessibility.minTapTargetSize,
      fadeInDuration: config.animation.fadeIn,
      fadeOutDuration: config.animation.fadeOut,
      replyLabel: config.translations.actionReply,
      retryLabel: config.translations.viewerRetry,
      onActivate: () => _handleTap(context),
      onReply: callbacks.onSwipeReply == null
          ? null
          : () => callbacks.onSwipeReply!(messageId),
      onReact: callbacks.onReaction == null || !config.contextMenu.showReactions
          ? null
          : () => _toggleDefaultReaction(context),
      onRetry: lifecycle?.canRetry == true && callbacks.onRetryMessage != null
          ? () => callbacks.onRetryMessage!(messageId)
          : null,
      onShowContextMenu: onShowContextMenu,
      child: child,
    );
  }

  void _handleTap(BuildContext context) {
    final scope = context.bubbleScope;
    if (scope.isSelectionMode) {
      final isCurrentlySelected = scope.isSelected(messageId);
      context.bubbleCallbacks.onSelectionChanged?.call(
        messageId,
        !isCurrentlySelected,
      );
    } else {
      context.bubbleCallbacks.onTap?.call(messageId);
    }
  }

  void _handleDoubleTap(BuildContext context) {
    final config = context.bubbleConfig;
    if (!config.gestures.enableDoubleTapToReact) return;
    _toggleDefaultReaction(context);
  }

  void _toggleDefaultReaction(BuildContext context) {
    final config = context.bubbleConfig;
    if (config.gestures.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    // Always use love emoji for double-tap reaction
    const defaultReaction = '❤️';
    // Update internal state
    final reactionStateManager = context.reactionStateManager;
    final action = reactionStateManager.setReaction(
      messageId,
      defaultReaction,
      allowMultiple: config.contextMenu.allowMultipleReactions,
    );
    // Notify parent via callback
    context.bubbleCallbacks.onReaction?.call(
      messageId,
      defaultReaction,
      action,
    );
  }
}
