import 'dart:async';

import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import '../core/constants.dart';
import '../core/modern_message_models.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'shared/unified_image.dart';

/// Live-location message with last-update and expiry state.
class VLiveLocationBubble extends BaseBubble {
  final VLiveLocationData liveLocation;

  @override
  String get messageType => 'live location';

  const VLiveLocationBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.liveLocation,
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
  });

  @override
  Widget buildContent(BuildContext context) {
    final header = buildBubbleHeader(context);
    return buildBubbleContainer(
      context: context,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null)
            Padding(padding: const EdgeInsets.all(8), child: header),
          _LiveLocationContent(
            messageId: messageId,
            data: liveLocation,
            isMeSender: isMeSender,
            footer: buildMeta(context),
          ),
        ],
      ),
    );
  }
}

class _LiveLocationContent extends StatefulWidget {
  final String messageId;
  final VLiveLocationData data;
  final bool isMeSender;
  final Widget footer;

  const _LiveLocationContent({
    required this.messageId,
    required this.data,
    required this.isMeSender,
    required this.footer,
  });

  @override
  State<_LiveLocationContent> createState() => _LiveLocationContentState();
}

class _LiveLocationContentState extends State<_LiveLocationContent> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.data.isActiveAt(_now)) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() => _now = DateTime.now());
        if (!widget.data.isActiveAt(_now)) _timer?.cancel();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.bubbleTheme;
    final selectionMode = context.bubbleScope.isSelectionMode;
    final active = widget.data.isActiveAt(_now);
    final textColor = widget.isMeSender
        ? theme.outgoingTextColor
        : theme.incomingTextColor;
    final secondaryColor = widget.isMeSender
        ? theme.outgoingSecondaryTextColor
        : theme.incomingSecondaryTextColor;
    return GestureDetector(
      onTap: selectionMode || context.bubbleCallbacks.onLiveLocationTap == null
          ? null
          : () => context.bubbleCallbacks.onLiveLocationTap!(
              widget.messageId,
              widget.data.sessionId,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (widget.data.staticMapUrl != null)
                  VUnifiedImage(
                    imageSource: VPlatformFile.fromUrl(
                      networkUrl: widget.data.staticMapUrl!,
                    ),
                    fit: BoxFit.cover,
                  )
                else
                  ColoredBox(
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.map_outlined,
                      size: BubbleSizes.iconHuge,
                      color: Colors.grey,
                    ),
                  ),
                Center(
                  child: Icon(
                    Icons.navigation_rounded,
                    color: active ? Colors.red : Colors.grey,
                    size: 36,
                  ),
                ),
                PositionedDirectional(
                  top: 8,
                  start: 8,
                  child: _StatusChip(
                    active: active,
                    remaining: widget.data.remainingAt(_now),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.data.address ??
                      '${widget.data.latitude.toStringAsFixed(4)}, '
                          '${widget.data.longitude.toStringAsFixed(4)}',
                  style: theme.messageTextStyle.copyWith(color: textColor),
                ),
                BubbleSpacing.vGapXS,
                Text(
                  'Updated ${_clock(widget.data.lastUpdatedAt)}'
                  '${widget.data.trail.isEmpty ? '' : ' · ${widget.data.trail.length} trail points'}',
                  style: theme.timeTextStyle.copyWith(color: secondaryColor),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: widget.footer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _clock(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}

class _StatusChip extends StatelessWidget {
  final bool active;
  final Duration remaining;

  const _StatusChip({required this.active, required this.remaining});

  @override
  Widget build(BuildContext context) {
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return Container(
      key: const ValueKey('v-live-location-status'),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BubbleRadius.chip,
      ),
      child: Text(
        active
            ? 'LIVE · $minutes:${seconds.toString().padLeft(2, '0')}'
            : 'ENDED',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
