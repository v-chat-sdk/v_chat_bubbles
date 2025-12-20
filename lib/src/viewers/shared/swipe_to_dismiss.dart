import 'package:flutter/material.dart';

/// A widget that allows dismissing its child by swiping down
class VSwipeToDismiss extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismiss;
  final double dismissThreshold;
  final double velocityThreshold;
  const VSwipeToDismiss({
    super.key,
    required this.child,
    required this.onDismiss,
    this.dismissThreshold = 100,
    this.velocityThreshold = 800,
  });
  @override
  State<VSwipeToDismiss> createState() => _SwipeToDismissState();
}

class _SwipeToDismissState extends State<VSwipeToDismiss>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragOffset = 0;
  bool _isDragging = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _isDragging = true;
    _controller.stop();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;
    setState(() {
      _dragOffset += details.delta.dy;
      // Only allow downward drag
      if (_dragOffset < 0) _dragOffset = 0;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;
    final velocity = details.primaryVelocity ?? 0;
    if (_dragOffset > widget.dismissThreshold ||
        velocity > widget.velocityThreshold) {
      // Dismiss
      widget.onDismiss();
    } else {
      // Animate back to original position
      _animation = Tween<double>(begin: _dragOffset, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller.forward(from: 0).then((_) {
        if (mounted) {
          setState(() => _dragOffset = 0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final currentOffset = _isDragging ? _dragOffset : _animation.value;
          final currentProgress =
              (currentOffset / widget.dismissThreshold).clamp(0.0, 1.0);
          final currentScale = 1.0 - (currentProgress * 0.1);
          final currentOpacity = 1.0 - (currentProgress * 0.3);
          return Transform.translate(
            offset: Offset(0, currentOffset),
            child: Transform.scale(
              scale: currentScale,
              child: Opacity(
                opacity: currentOpacity.clamp(0.0, 1.0),
                child: child,
              ),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
