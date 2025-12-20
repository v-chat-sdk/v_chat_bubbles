import 'dart:async';
import 'package:flutter/material.dart';

/// Overlay wrapper that auto-hides controls after a delay
class VViewerOverlay extends StatefulWidget {
  final Widget child;
  final Widget overlay;
  final Duration autoHideDelay;
  final bool initiallyVisible;
  const VViewerOverlay({
    super.key,
    required this.child,
    required this.overlay,
    this.autoHideDelay = const Duration(seconds: 3),
    this.initiallyVisible = true,
  });
  @override
  State<VViewerOverlay> createState() => _ViewerOverlayState();
}

class _ViewerOverlayState extends State<VViewerOverlay> {
  late bool _isVisible;
  Timer? _hideTimer;
  @override
  void initState() {
    super.initState();
    _isVisible = widget.initiallyVisible;
    if (_isVisible) {
      _startHideTimer();
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(widget.autoHideDelay, () {
      if (mounted) {
        setState(() => _isVisible = false);
      }
    });
  }

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
      if (_isVisible) {
        _startHideTimer();
      } else {
        _hideTimer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleVisibility,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,
          AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_isVisible,
              child: widget.overlay,
            ),
          ),
        ],
      ),
    );
  }
}
