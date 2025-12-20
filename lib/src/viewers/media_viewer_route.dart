import 'package:flutter/material.dart';
import '../core/callbacks.dart';
import '../core/models.dart';
import 'image_viewer_page.dart';
import 'video_player_page.dart';
import 'gallery_viewer_page.dart';

/// Factory class for creating media viewer routes
class VMediaViewerRoute {
  VMediaViewerRoute._();

  /// Open single image viewer
  static void openImage({
    required BuildContext context,
    required VMediaViewerData data,
    VBubbleCallbacks? callbacks,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) {
          return VImageViewerPage(
            data: data,
            callbacks: callbacks,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// Open video player
  static void openVideo({
    required BuildContext context,
    required VMediaViewerData data,
    VBubbleCallbacks? callbacks,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) {
          return VVideoPlayerPage(
            data: data,
            callbacks: callbacks,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// Open gallery viewer with multiple images
  static void openGallery({
    required BuildContext context,
    required VMediaViewerData data,
    VBubbleCallbacks? callbacks,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        barrierDismissible: false,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) {
          return VGalleryViewerPage(
            data: data,
            callbacks: callbacks,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  /// Open appropriate viewer based on media type
  static void open({
    required BuildContext context,
    required VMediaViewerData data,
    VBubbleCallbacks? callbacks,
  }) {
    if (data.items != null && data.items!.isNotEmpty) {
      openGallery(context: context, data: data, callbacks: callbacks);
    } else if (data.isVideo) {
      openVideo(context: context, data: data, callbacks: callbacks);
    } else {
      openImage(context: context, data: data, callbacks: callbacks);
    }
  }
}
