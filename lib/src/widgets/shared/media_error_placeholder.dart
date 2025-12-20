import 'package:flutter/material.dart';

/// Shared error placeholder widget for media content
///
/// Used across image, video, sticker, and gallery bubbles for consistent
/// error state presentation.
class VMediaErrorPlaceholder extends StatelessWidget {
  /// Placeholder height
  final double? height;

  /// Placeholder width
  final double? width;

  /// Background color (defaults to grey[300])
  final Color? backgroundColor;

  /// Icon to display (defaults to broken_image)
  final IconData icon;

  /// Icon size (defaults to 48)
  final double iconSize;

  /// Icon color (defaults to grey)
  final Color? iconColor;

  const VMediaErrorPlaceholder({
    super.key,
    this.height,
    this.width,
    this.backgroundColor,
    this.icon = Icons.broken_image,
    this.iconSize = 48,
    this.iconColor,
  });

  /// Creates a placeholder for image errors
  const VMediaErrorPlaceholder.image({
    super.key,
    this.height = 150,
    this.width,
    this.backgroundColor,
  })  : icon = Icons.broken_image,
        iconSize = 32,
        iconColor = null;

  /// Creates a placeholder for video thumbnail errors
  const VMediaErrorPlaceholder.video({
    super.key,
    this.height = 200,
    this.width,
    this.backgroundColor,
  })  : icon = Icons.broken_image,
        iconSize = 48,
        iconColor = Colors.white54;

  /// Creates a placeholder for sticker errors
  const VMediaErrorPlaceholder.sticker({
    super.key,
    this.height,
    this.width,
    this.backgroundColor,
  })  : icon = Icons.emoji_emotions,
        iconSize = 64,
        iconColor = Colors.grey;

  /// Creates a placeholder for gallery image errors
  const VMediaErrorPlaceholder.gallery({
    super.key,
    this.height,
    this.width,
    this.backgroundColor,
  })  : icon = Icons.broken_image,
        iconSize = 32,
        iconColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: backgroundColor ?? Colors.grey[300],
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? Colors.grey,
        ),
      ),
    );
  }
}
