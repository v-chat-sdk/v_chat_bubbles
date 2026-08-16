import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Adds pointer and keyboard affordances without changing bubble dimensions.
class VAdaptiveBubbleInteraction extends StatefulWidget {
  final String messageId;
  final bool isMeSender;
  final Widget child;
  final bool enableHoverActions;
  final bool enableSecondaryTap;
  final bool enableKeyboardShortcuts;
  final double minTapTargetSize;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;
  final VoidCallback? onActivate;
  final VoidCallback? onReply;
  final VoidCallback? onReact;
  final VoidCallback? onRetry;
  final ValueChanged<Offset>? onShowContextMenu;
  final String replyLabel;
  final String retryLabel;

  const VAdaptiveBubbleInteraction({
    super.key,
    required this.messageId,
    required this.isMeSender,
    required this.child,
    required this.enableHoverActions,
    required this.enableSecondaryTap,
    required this.enableKeyboardShortcuts,
    required this.minTapTargetSize,
    required this.fadeInDuration,
    required this.fadeOutDuration,
    required this.replyLabel,
    required this.retryLabel,
    this.onActivate,
    this.onReply,
    this.onReact,
    this.onRetry,
    this.onShowContextMenu,
  });

  @override
  State<VAdaptiveBubbleInteraction> createState() =>
      _VAdaptiveBubbleInteractionState();
}

class _VAdaptiveBubbleInteractionState
    extends State<VAdaptiveBubbleInteraction> {
  final FocusNode _focusNode = FocusNode(debugLabel: 'chat bubble');
  bool _isHovered = false;
  bool _showFocusHighlight = false;

  bool get _showActions =>
      widget.enableHoverActions && (_isHovered || _showFocusHighlight);

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Offset _centerOnScreen() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return Offset.zero;
    return renderBox.localToGlobal(renderBox.size.center(Offset.zero));
  }

  void _showContextMenu([Offset? position]) {
    widget.onShowContextMenu?.call(position ?? _centerOnScreen());
  }

  @override
  Widget build(BuildContext context) {
    final actionCount =
        (widget.onRetry == null ? 0 : 1) +
        (widget.onReply == null ? 0 : 1) +
        (widget.onReact == null ? 0 : 1);
    final targetSize = widget.minTapTargetSize.clamp(40.0, 64.0);
    final shortcuts = <ShortcutActivator, Intent>{
      const SingleActivator(LogicalKeyboardKey.enter): const ActivateIntent(),
      const SingleActivator(LogicalKeyboardKey.space): const ActivateIntent(),
      if (widget.onReply != null)
        const SingleActivator(LogicalKeyboardKey.keyR, alt: true):
            const _ReplyToBubbleIntent(),
      if (widget.onShowContextMenu != null)
        const SingleActivator(LogicalKeyboardKey.f10, shift: true):
            const _ShowBubbleMenuIntent(),
    };
    final actions = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (_) {
          widget.onActivate?.call();
          return null;
        },
      ),
      _ReplyToBubbleIntent: CallbackAction<_ReplyToBubbleIntent>(
        onInvoke: (_) {
          widget.onReply?.call();
          return null;
        },
      ),
      _ShowBubbleMenuIntent: CallbackAction<_ShowBubbleMenuIntent>(
        onInvoke: (_) {
          _showContextMenu();
          return null;
        },
      ),
    };

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        if (!_isHovered) setState(() => _isHovered = true);
      },
      onExit: (_) {
        if (_isHovered) setState(() => _isHovered = false);
      },
      child: Listener(
        onPointerDown: (_) => _focusNode.requestFocus(),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onSecondaryTapDown:
              widget.enableSecondaryTap && widget.onShowContextMenu != null
              ? (details) => _showContextMenu(details.globalPosition)
              : null,
          child: FocusableActionDetector(
            focusNode: _focusNode,
            enabled: widget.enableKeyboardShortcuts,
            shortcuts: shortcuts,
            actions: actions,
            onShowFocusHighlight: (value) {
              if (_showFocusHighlight != value) {
                setState(() => _showFocusHighlight = value);
              }
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: actionCount == 0 ? 0 : targetSize * actionCount,
              ),
              child: Stack(
                alignment: widget.isMeSender
                    ? Alignment.topRight
                    : Alignment.topLeft,
                children: [
                  widget.child,
                  if (actionCount > 0)
                    _buildActionRail(context, targetSize: targetSize),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionRail(BuildContext context, {required double targetSize}) {
    return Positioned(
      key: ValueKey('v-bubble-hover-actions-${widget.messageId}'),
      left: widget.isMeSender ? 0 : null,
      right: widget.isMeSender ? null : 0,
      top: 0,
      child: IgnorePointer(
        ignoring: !_showActions,
        child: AnimatedOpacity(
          opacity: _showActions ? 1 : 0,
          duration: _showActions
              ? widget.fadeInDuration
              : widget.fadeOutDuration,
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            elevation: 2,
            borderRadius: BorderRadius.circular(targetSize / 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.onRetry != null)
                  IconButton(
                    key: ValueKey('v-bubble-retry-${widget.messageId}'),
                    tooltip: widget.retryLabel,
                    constraints: BoxConstraints.tightFor(
                      width: targetSize,
                      height: targetSize,
                    ),
                    onPressed: widget.onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                if (widget.onReply != null)
                  IconButton(
                    key: ValueKey('v-bubble-reply-${widget.messageId}'),
                    tooltip: widget.replyLabel,
                    constraints: BoxConstraints.tightFor(
                      width: targetSize,
                      height: targetSize,
                    ),
                    onPressed: widget.onReply,
                    icon: const Icon(Icons.reply_rounded),
                  ),
                if (widget.onReact != null)
                  IconButton(
                    key: ValueKey('v-bubble-react-${widget.messageId}'),
                    tooltip: '❤️',
                    constraints: BoxConstraints.tightFor(
                      width: targetSize,
                      height: targetSize,
                    ),
                    onPressed: widget.onReact,
                    icon: const Icon(Icons.add_reaction_outlined),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReplyToBubbleIntent extends Intent {
  const _ReplyToBubbleIntent();
}

class _ShowBubbleMenuIntent extends Intent {
  const _ShowBubbleMenuIntent();
}
