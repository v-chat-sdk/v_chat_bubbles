import 'package:flutter/material.dart';

/// Wraps InteractiveViewer with double-tap to zoom functionality
class VDoubleTapZoomViewer extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final double doubleTapScale;
  final Duration animationDuration;
  const VDoubleTapZoomViewer({
    super.key,
    required this.child,
    this.minScale = 1.0,
    this.maxScale = 4.0,
    this.doubleTapScale = 2.0,
    this.animationDuration = const Duration(milliseconds: 200),
  });
  @override
  State<VDoubleTapZoomViewer> createState() => _DoubleTapZoomViewerState();
}

class _DoubleTapZoomViewerState extends State<VDoubleTapZoomViewer>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformController =
      TransformationController();
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  TapDownDetails? _doubleTapDetails;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animationController.addListener(_onAnimationUpdate);
  }

  @override
  void dispose() {
    _animationController.removeListener(_onAnimationUpdate);
    _animationController.dispose();
    _transformController.dispose();
    super.dispose();
  }

  void _onAnimationUpdate() {
    if (_animation != null) {
      _transformController.value = _animation!.value;
    }
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_doubleTapDetails == null) return;
    final position = _doubleTapDetails!.localPosition;
    final currentScale = _transformController.value.getMaxScaleOnAxis();
    final isZoomedIn = currentScale > 1.05;
    Matrix4 endMatrix;
    if (isZoomedIn) {
      // Zoom out to 1.0
      endMatrix = Matrix4.identity();
    } else {
      // Zoom in to doubleTapScale centered on tap position
      final x = -position.dx * (widget.doubleTapScale - 1);
      final y = -position.dy * (widget.doubleTapScale - 1);
      endMatrix = Matrix4.identity()..setTranslationRaw(x, y, 0);
      endMatrix.setEntry(0, 0, widget.doubleTapScale);
      endMatrix.setEntry(1, 1, widget.doubleTapScale);
      endMatrix.setEntry(2, 2, 1.0);
    }
    _animation = Matrix4Tween(
      begin: _transformController.value,
      end: endMatrix,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _handleDoubleTapDown,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformController,
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        clipBehavior: Clip.none,
        panEnabled: true,
        scaleEnabled: true,
        child: widget.child,
      ),
    );
  }
}
