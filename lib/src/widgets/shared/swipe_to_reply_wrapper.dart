import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A wrapper widget that handles swipe-to-reply gesture with smooth animations
class VSwipeToReplyWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipe;
  final bool isMeSender;
  final double swipeThreshold;
  final Duration animationDuration;
  final Curve animationCurve;
  final Widget? icon;
  final double velocityThreshold;
  final double maxDragExtent;
  final double cancelThreshold;

  const VSwipeToReplyWrapper({
    super.key,
    required this.child,
    this.onSwipe,
    required this.isMeSender,
    this.swipeThreshold = 60.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
    this.icon,
    this.velocityThreshold = 800.0,
    this.maxDragExtent = 120.0,
    this.cancelThreshold = 0.3,
  });

  @override
  State<VSwipeToReplyWrapper> createState() => _SwipeToReplyWrapperState();
}

class _SwipeToReplyWrapperState extends State<VSwipeToReplyWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0.0;
  double _animationStartExtent = 0.0;
  double _peakDragExtent = 0.0;
  bool _triggered = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _controller.addListener(_onAnimationTick);
    _controller.addStatusListener(_onAnimationStatus);
  }

  @override
  void didUpdateWidget(covariant VSwipeToReplyWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onAnimationTick);
    _controller.removeStatusListener(_onAnimationStatus);
    _controller.dispose();
    super.dispose();
  }

  void _onAnimationTick() {
    if (_isDragging) return;
    final curvedValue = widget.animationCurve.transform(_controller.value);
    setState(() {
      _dragExtent = _animationStartExtent * (1.0 - curvedValue);
    });
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _dragExtent = 0.0;
        _animationStartExtent = 0.0;
        _triggered = false;
      });
    }
  }

  double _applyRubberBand(double offset, double limit) {
    if (offset.abs() <= limit) return offset;
    final sign = offset.sign;
    final excess = offset.abs() - limit;
    final dampened = limit + (1 - math.exp(-excess / limit)) * limit * 0.5;
    return sign * dampened;
  }

  void _handleDragStart(DragStartDetails details) {
    if (widget.onSwipe == null) return;
    _controller.stop();
    _isDragging = true;
    _peakDragExtent = _dragExtent.abs();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (widget.onSwipe == null || !_isDragging) return;
    // RTL support - swipe direction follows app locale
    final isAppRTL = Directionality.of(context) == TextDirection.rtl;
    final layoutIsMeSender = isAppRTL ? !widget.isMeSender : widget.isMeSender;
    final double delta = details.primaryDelta ?? 0;
    bool allowed = false;
    if (layoutIsMeSender) {
      // Sender side: swipe left to reply (RTL: swipe right)
      if (delta < 0) allowed = true;
      if (delta > 0 && _dragExtent < 0) allowed = true;
    } else {
      // Receiver side: swipe right to reply (RTL: swipe left)
      if (delta > 0) allowed = true;
      if (delta < 0 && _dragExtent > 0) allowed = true;
    }
    if (allowed || _dragExtent.abs() > 0) {
      setState(() {
        double newExtent = _dragExtent + delta;
        if (layoutIsMeSender) {
          if (newExtent > 0) newExtent = 0;
        } else {
          if (newExtent < 0) newExtent = 0;
        }
        _dragExtent = _applyRubberBand(newExtent, widget.maxDragExtent);
        if (_dragExtent.abs() > _peakDragExtent) {
          _peakDragExtent = _dragExtent.abs();
        }
        final wasTriggered = _triggered;
        _triggered = _dragExtent.abs() >= widget.swipeThreshold;
        if (_triggered && !wasTriggered) {
          HapticFeedback.mediumImpact();
        } else if (!_triggered && wasTriggered) {
          HapticFeedback.lightImpact();
        }
      });
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (widget.onSwipe == null || !_isDragging) return;
    _isDragging = false;
    // RTL support - velocity direction follows app locale
    final isAppRTL = Directionality.of(context) == TextDirection.rtl;
    final layoutIsMeSender = isAppRTL ? !widget.isMeSender : widget.isMeSender;
    final velocity = details.primaryVelocity ?? 0;
    bool velocityTriggered = false;
    if (layoutIsMeSender) {
      // Sender side: swipe left velocity
      if (velocity < -widget.velocityThreshold) velocityTriggered = true;
    } else {
      // Receiver side: swipe right velocity
      if (velocity > widget.velocityThreshold) velocityTriggered = true;
    }
    final reachedThreshold = _peakDragExtent >= widget.swipeThreshold;
    final draggedBackToCancel = reachedThreshold &&
        _dragExtent.abs() < widget.swipeThreshold * widget.cancelThreshold;
    final shouldTrigger =
        (_triggered || velocityTriggered) && !draggedBackToCancel;
    if (shouldTrigger) {
      HapticFeedback.mediumImpact();
      widget.onSwipe!();
    }
    _animateBack();
  }

  void _animateBack() {
    if (_dragExtent == 0) {
      _triggered = false;
      return;
    }
    _animationStartExtent = _dragExtent;
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onSwipe == null) return widget.child;
    final progress =
        (_dragExtent.abs() / widget.swipeThreshold).clamp(0.0, 1.0);
    final triggeredScale = 1.1;
    final progressScale = 0.5 + (progress * 0.5);
    final iconScale = _triggered ? triggeredScale : progressScale;
    final iconOpacity = progress.clamp(0.0, 1.0);
    final triggeredRotation = 0.0;
    final progressRotation = (1 - progress) * -math.pi / 6;
    final iconRotation = _triggered ? triggeredRotation : progressRotation;
    final leftPosition = _dragExtent > 0 ? 0.0 : null;
    final rightPosition = _dragExtent < 0 ? 0.0 : null;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_dragExtent != 0)
          Positioned(
            top: 0,
            bottom: 0,
            left: leftPosition,
            right: rightPosition,
            child: Container(
              width: widget.swipeThreshold,
              alignment: Alignment.center,
              child: Opacity(
                opacity: iconOpacity,
                child: Transform.rotate(
                  angle: iconRotation,
                  child: Transform.scale(
                    scale: iconScale,
                    child: widget.icon ??
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _triggered
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.reply,
                            size: 20,
                            color: _triggered
                                ? Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                        ),
                  ),
                ),
              ),
            ),
          ),
        GestureDetector(
          onHorizontalDragStart: _handleDragStart,
          onHorizontalDragUpdate: _handleDragUpdate,
          onHorizontalDragEnd: _handleDragEnd,
          child: Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
