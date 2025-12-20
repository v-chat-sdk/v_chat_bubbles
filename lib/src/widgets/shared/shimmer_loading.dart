import 'package:flutter/material.dart';

/// Animated shimmer loading placeholder for media content
///
/// Creates a smooth gradient animation that sweeps across
/// the placeholder, indicating loading state.
class VShimmerLoading extends StatefulWidget {
  /// Width of the shimmer container
  final double? width;

  /// Height of the shimmer container
  final double? height;

  /// Base color for the shimmer effect
  final Color? baseColor;

  /// Highlight color for the shimmer sweep
  final Color? highlightColor;

  /// Border radius for the shimmer container
  final BorderRadius? borderRadius;

  /// Optional child widget to overlay on shimmer
  final Widget? child;

  const VShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.baseColor,
    this.highlightColor,
    this.borderRadius,
    this.child,
  });

  /// Creates a shimmer placeholder for image loading
  factory VShimmerLoading.image({
    Key? key,
    double? width,
    double height = 200,
    Color? baseColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
  }) {
    return VShimmerLoading(
      key: key,
      width: width,
      height: height,
      baseColor: baseColor,
      highlightColor: highlightColor,
      borderRadius: borderRadius,
      child: const Icon(Icons.image, size: 40, color: Colors.white38),
    );
  }

  /// Creates a shimmer placeholder for video thumbnail loading
  factory VShimmerLoading.video({
    Key? key,
    double? width,
    double height = 200,
    Color? baseColor,
    Color? highlightColor,
    BorderRadius? borderRadius,
  }) {
    return VShimmerLoading(
      key: key,
      width: width,
      height: height,
      baseColor: baseColor,
      highlightColor: highlightColor,
      borderRadius: borderRadius,
      child: const Icon(Icons.play_circle_outline,
          size: 48, color: Colors.white38),
    );
  }

  /// Creates a shimmer placeholder for gallery items
  factory VShimmerLoading.gallery({
    Key? key,
    double? width,
    double height = 120,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return VShimmerLoading(
      key: key,
      width: width,
      height: height,
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: const Icon(Icons.photo_library, size: 32, color: Colors.white38),
    );
  }

  @override
  State<VShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<VShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? Colors.grey[300]!;
    final highlightColor = widget.highlightColor ?? Colors.grey[100]!;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: child,
        );
      },
      child: widget.child != null ? Center(child: widget.child) : null,
    );
  }
}
