import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_platform/v_platform.dart';
import 'package:video_player/video_player.dart';
import '../core/callbacks.dart';
import '../core/config.dart';
import '../core/models.dart';
import '../widgets/bubble_scope.dart';
import 'shared/viewer_app_bar.dart';
import 'shared/viewer_overlay.dart';
import 'shared/video_controls.dart';

/// Full-screen video player with essential controls
class VVideoPlayerPage extends StatefulWidget {
  final VMediaViewerData data;
  final VBubbleCallbacks? callbacks;
  const VVideoPlayerPage({
    super.key,
    required this.data,
    this.callbacks,
  });
  @override
  State<VVideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VVideoPlayerPage> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  String? _errorMessage;
  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeController() async {
    try {
      _controller = _createController(widget.data.file);
      await _controller!.initialize();
      await _controller!.play();
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }
    }
  }

  VideoPlayerController _createController(VPlatformFile file) {
    if (file.isFromUrl) {
      return VideoPlayerController.networkUrl(Uri.parse(file.networkUrl!));
    } else if (file.isFromPath) {
      return VideoPlayerController.file(File(file.fileLocalPath!));
    } else if (file.isFromAssets) {
      return VideoPlayerController.asset(file.assetsPath!);
    }
    throw ArgumentError('Unsupported video source');
  }

  Future<void> _retryInitialization() async {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _isInitialized = false;
    });
    _controller?.dispose();
    _controller = null;
    await _initializeController();
  }

  void _toggleFullscreen() {
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    if (isLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    // Reset orientation preferences after a delay
    Future.delayed(const Duration(milliseconds: 100), () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_hasError) {
      return _buildErrorState(context);
    }
    if (!_isInitialized || _controller == null) {
      return _buildLoadingState();
    }
    return VViewerOverlay(
      overlay: _buildOverlay(context),
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: Hero(
            tag: 'media_${widget.data.messageId}',
            child: VideoPlayer(_controller!),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Loading video...',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final scope = VBubbleScopeData.maybeOf(context);
    final translations =
        scope?.config.translations ?? const VTranslationConfig();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.white54, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Failed to load video',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _retryInitialization,
            icon: const Icon(Icons.refresh),
            label: Text(translations.viewerRetry),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white24,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              translations.viewerClose,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // App bar at top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: VViewerAppBar(
            title: widget.data.senderName,
            subtitle: widget.data.time,
            onClose: () => Navigator.of(context).pop(),
            onDownload: widget.callbacks?.onDownload != null
                ? () => widget.callbacks!.onDownload!(widget.data.messageId)
                : null,
            onShare: widget.callbacks?.onShare != null
                ? () => widget.callbacks!.onShare!(widget.data.messageId)
                : null,
          ),
        ),
        // Video controls
        if (_controller != null)
          VVideoControls(
            controller: _controller!,
            onFullscreen: _toggleFullscreen,
          ),
      ],
    );
  }
}
