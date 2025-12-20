import 'package:flutter/material.dart';
import '../core/enums.dart';

/// Constants for bubble painter calculations
abstract class BubblePainterConstants {
  /// Messenger grouped corner ratio (small radius = full radius * this)
  static const double messengerGroupedCornerRatio = 0.22;

  /// Telegram tail width (how far it extends outward from bubble edge)
  static const double telegramTailWidth = 10.0;

  /// Telegram tail height (vertical extent of the tail)
  static const double telegramTailHeight = 16.0;

  /// Telegram small corner (corner where tail meets bubble)
  static const double telegramTailCorner = 2.0;

  /// WhatsApp tail height
  static const double whatsappTailHeight = 8.0;

  /// WhatsApp tail extension
  static const double whatsappTailExtension = 4.0;

  /// iMessage tail curve factor
  static const double imessageTailCurveFactor = 0.3;
}

/// Abstract painter for bubble backgrounds
///
/// Provides factory constructor to create style-specific painters.
/// All painters support:
/// - Solid color or gradient fill
/// - Optional tail for message grouping
/// - Configurable corner radius
/// - RTL layout support
abstract class VBubblePainter extends CustomPainter {
  /// Fill color for the bubble
  final Color color;

  /// Optional gradient (overrides color if provided)
  final Gradient? gradient;

  /// Whether this message is from the current user (sent by me)
  final bool isMeSender;

  /// Whether to show the bubble tail
  final bool showTail;

  /// Corner radius for rounded corners
  final double radius;

  /// Size of the tail decoration
  final double tailSize;

  /// Whether the layout is RTL (right-to-left)
  final bool isRtl;

  /// Computed property: whether tail should be on the right side
  /// In LTR: outgoing (isMeSender) = right, incoming = left
  /// In RTL: outgoing (isMeSender) = left, incoming = right
  bool get tailOnRight => isMeSender != isRtl;

  VBubblePainter({
    required this.color,
    this.gradient,
    required this.isMeSender,
    required this.showTail,
    required this.radius,
    required this.tailSize,
    this.isRtl = false,
  });

  /// Factory to create painter for specific style
  factory VBubblePainter.forStyle({
    required VBubbleStyle style,
    required Color color,
    Gradient? gradient,
    required bool isMeSender,
    required bool showTail,
    required double radius,
    required double tailSize,
    bool isRtl = false,
  }) {
    switch (style) {
      case VBubbleStyle.telegram:
        return VTelegramBubblePainter(
          color: color,
          gradient: gradient,
          isMeSender: isMeSender,
          showTail: showTail,
          radius: radius,
          tailSize: tailSize,
          isRtl: isRtl,
        );
      case VBubbleStyle.whatsapp:
        return VWhatsAppBubblePainter(
          color: color,
          isMeSender: isMeSender,
          showTail: showTail,
          radius: radius,
          tailSize: tailSize,
          isRtl: isRtl,
        );
      case VBubbleStyle.messenger:
        return VMessengerBubblePainter(
          color: color,
          isMeSender: isMeSender,
          showTail: showTail,
          radius: radius,
          tailSize: tailSize,
          isRtl: isRtl,
        );
      case VBubbleStyle.imessage:
        return VIMessageBubblePainter(
          color: color,
          isMeSender: isMeSender,
          showTail: showTail,
          radius: radius,
          tailSize: tailSize,
          isRtl: isRtl,
        );
      case VBubbleStyle.custom:
        return VTelegramBubblePainter(
          color: color,
          isMeSender: isMeSender,
          showTail: showTail,
          radius: radius,
          tailSize: tailSize,
          isRtl: isRtl,
        );
    }
  }

  /// Creates a simple rounded rectangle path (no tail)
  Path createSimpleRoundedPath(Size size) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));
  }

  /// Adds a quadratic bezier for top-left corner
  @protected
  void addTopLeftCorner(Path path, double radius) {
    path.quadraticBezierTo(0, 0, radius, 0);
  }

  /// Adds a quadratic bezier for top-right corner
  @protected
  void addTopRightCorner(Path path, double width, double radius) {
    path.quadraticBezierTo(width, 0, width, radius);
  }

  /// Adds a quadratic bezier for bottom-right corner
  @protected
  void addBottomRightCorner(
      Path path, double width, double height, double radius) {
    path.quadraticBezierTo(width, height, width - radius, height);
  }

  /// Adds a quadratic bezier for bottom-left corner
  @protected
  void addBottomLeftCorner(Path path, double height, double radius) {
    path.quadraticBezierTo(0, height, 0, height - radius);
  }
}

/// Telegram iOS bubble style
///
/// Uses rounded rectangles with a small curved tail at the bottom corner.
/// The tail curves inward creating a subtle hook effect, characteristic
/// of Telegram's iOS design.
class VTelegramBubblePainter extends VBubblePainter {
  late Paint _cachedPaint;
  late Color _lastColor;
  Gradient? _lastGradient;
  late Size _lastSize;
  late Path _cachedPath;
  late Size _cachedSize;
  late bool _cachedShowTail;
  late bool _cachedTailOnRight;
  late double _cachedRadius;
  bool _isPaintInitialized = false;
  bool _isPathInitialized = false;

  VTelegramBubblePainter({
    required super.color,
    super.gradient,
    required super.isMeSender,
    required super.showTail,
    required super.radius,
    required super.tailSize,
    super.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!_isPaintInitialized ||
        _lastColor != color ||
        _lastGradient != gradient ||
        _lastSize != size) {
      _cachedPaint = Paint()..style = PaintingStyle.fill;
      if (gradient != null) {
        _cachedPaint.shader = gradient!.createShader(
          Rect.fromLTWH(0, 0, size.width, size.height),
        );
      } else {
        _cachedPaint.color = color;
      }
      _lastColor = color;
      _lastGradient = gradient;
      _lastSize = size;
      _isPaintInitialized = true;
    }
    if (!_isPathInitialized ||
        _cachedSize != size ||
        _cachedShowTail != showTail ||
        _cachedTailOnRight != tailOnRight ||
        _cachedRadius != radius) {
      // Use tailOnRight to determine path (respects RTL)
      final tailPath =
          tailOnRight ? _createRightTailPath(size) : _createLeftTailPath(size);
      _cachedPath = showTail ? tailPath : createSimpleRoundedPath(size);
      _cachedSize = size;
      _cachedShowTail = showTail;
      _cachedTailOnRight = tailOnRight;
      _cachedRadius = radius;
      _isPathInitialized = true;
    }
    canvas.drawPath(_cachedPath, _cachedPaint);
  }

  /// Creates bubble path with authentic Telegram tail on bottom-right
  /// The tail curves outward and hooks back, characteristic of Telegram iOS design
  Path _createRightTailPath(Size size) {
    final width = size.width;
    final height = size.height;
    final r = radius;
    final path = Path();
    // Start from top-left
    path.moveTo(r, 0);
    // Top edge
    path.lineTo(width - r, 0);
    // Top-right corner
    path.quadraticBezierTo(width, 0, width, r);
    // Right edge down to where tail begins (tail starts closer to bottom)
    path.lineTo(width, height - 10);
    // Telegram-authentic tail: smooth outward curve with elegant hook back
    // The tail flows naturally from the bubble edge, curves out, then sweeps
    // down and hooks back to meet the bottom edge
    path.cubicTo(
      width, height - 4, // control 1: slight curve before extending
      width + 2, height + 1, // control 2: curve outward and down
      width + 5, height + 2, // end: tail tip extends out and slightly below
    );
    // Hook back: the signature Telegram curve that sweeps back to bottom
    path.cubicTo(
      width + 4, height + 4, // control 1: continue the downward flow
      width - 4, height + 2, // control 2: sweep back toward bubble
      width - r, height, // end: smooth junction with bottom edge
    );
    // Bottom edge
    path.lineTo(r, height);
    // Bottom-left corner
    path.quadraticBezierTo(0, height, 0, height - r);
    // Left edge
    path.lineTo(0, r);
    // Top-left corner
    path.quadraticBezierTo(0, 0, r, 0);
    path.close();
    return path;
  }

  /// Creates bubble path with authentic Telegram tail on bottom-left (mirrored)
  Path _createLeftTailPath(Size size) {
    final width = size.width;
    final height = size.height;
    final r = radius;
    final path = Path();
    // Start from top-right
    path.moveTo(width - r, 0);
    // Top-right corner
    path.quadraticBezierTo(width, 0, width, r);
    // Right edge
    path.lineTo(width, height - r);
    // Bottom-right corner
    path.quadraticBezierTo(width, height, width - r, height);
    // Bottom edge to tail area
    path.lineTo(r, height);
    // Telegram-authentic tail: mirrored smooth outward curve with hook back
    // Hook from bottom edge outward to the left
    path.cubicTo(
      4, height + 2, // control 1: sweep toward tail
      -4, height + 4, // control 2: continue outward flow
      -5, height + 2, // end: tail tip extends out and slightly below
    );
    // Curve back up to meet the left edge
    path.cubicTo(
      -2, height + 1, // control 1: curve back inward
      0, height - 4, // control 2: rise back toward bubble
      0, height - 10, // end: smooth junction with left edge
    );
    // Left edge
    path.lineTo(0, r);
    // Top-left corner
    path.quadraticBezierTo(0, 0, r, 0);
    // Top edge
    path.lineTo(width - r, 0);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(VTelegramBubblePainter oldDelegate) =>
      color != oldDelegate.color ||
      gradient != oldDelegate.gradient ||
      isMeSender != oldDelegate.isMeSender ||
      showTail != oldDelegate.showTail ||
      radius != oldDelegate.radius ||
      tailSize != oldDelegate.tailSize ||
      isRtl != oldDelegate.isRtl;
}

/// WhatsApp iOS bubble style
///
/// Uses rounded bubbles with a small triangular pointer at the top corner.
/// The tail is subtle and points outward at the top, characteristic of
/// WhatsApp's iOS design.
class VWhatsAppBubblePainter extends VBubblePainter {
  late Paint _cachedPaint;
  late Color _lastColor;
  late Path _cachedPath;
  late Size _cachedSize;
  late bool _cachedShowTail;
  late bool _cachedTailOnRight;
  late double _cachedRadius;
  bool _isPaintInitialized = false;
  bool _isPathInitialized = false;

  VWhatsAppBubblePainter({
    required super.color,
    required super.isMeSender,
    required super.showTail,
    required super.radius,
    required super.tailSize,
    super.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!_isPaintInitialized || _lastColor != color) {
      _cachedPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      _lastColor = color;
      _isPaintInitialized = true;
    }
    if (!_isPathInitialized ||
        _cachedSize != size ||
        _cachedShowTail != showTail ||
        _cachedTailOnRight != tailOnRight ||
        _cachedRadius != radius) {
      // Use tailOnRight to determine path (respects RTL)
      final tailPath =
          tailOnRight ? _createRightTailPath(size) : _createLeftTailPath(size);
      _cachedPath = showTail ? tailPath : createSimpleRoundedPath(size);
      _cachedSize = size;
      _cachedShowTail = showTail;
      _cachedTailOnRight = tailOnRight;
      _cachedRadius = radius;
      _isPathInitialized = true;
    }
    canvas.drawPath(_cachedPath, _cachedPaint);
  }

  /// Creates bubble path with small tail at top-right
  Path _createRightTailPath(Size size) {
    final width = size.width;
    final height = size.height;
    final cornerRadius = radius;
    const tailHeight = BubblePainterConstants.whatsappTailHeight;
    const tailExtension = BubblePainterConstants.whatsappTailExtension;
    final path = Path();
    // Start from bottom-left
    path.moveTo(cornerRadius, height);
    // Bottom-left corner
    path.quadraticBezierTo(0, height, 0, height - cornerRadius);
    // Left edge
    path.lineTo(0, cornerRadius);
    // Top-left corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    // Top edge to tail starting point
    path.lineTo(width - cornerRadius - 2, 0);
    // Small tail pointing up-right
    path.lineTo(width - tailExtension, 0);
    path.quadraticBezierTo(width + 2, -2, width + tailExtension, 2);
    path.quadraticBezierTo(width + 2, 6, width, tailHeight);
    // Right edge
    path.lineTo(width, height - cornerRadius);
    // Bottom-right corner
    path.quadraticBezierTo(width, height, width - cornerRadius, height);
    path.close();
    return path;
  }

  /// Creates bubble path with small tail at top-left (mirrored)
  Path _createLeftTailPath(Size size) {
    final width = size.width;
    final height = size.height;
    final cornerRadius = radius;
    const tailHeight = BubblePainterConstants.whatsappTailHeight;
    const tailExtension = BubblePainterConstants.whatsappTailExtension;
    final path = Path();
    // Start from bottom-right
    path.moveTo(width - cornerRadius, height);
    // Bottom-right corner
    path.quadraticBezierTo(width, height, width, height - cornerRadius);
    // Right edge
    path.lineTo(width, cornerRadius);
    // Top-right corner
    path.quadraticBezierTo(width, 0, width - cornerRadius, 0);
    // Top edge to tail starting point
    path.lineTo(cornerRadius + 2, 0);
    // Small tail pointing up-left
    path.lineTo(tailExtension, 0);
    path.quadraticBezierTo(-2, -2, -tailExtension, 2);
    path.quadraticBezierTo(-2, 6, 0, tailHeight);
    // Left edge
    path.lineTo(0, height - cornerRadius);
    // Bottom-left corner
    path.quadraticBezierTo(0, height, cornerRadius, height);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(VWhatsAppBubblePainter oldDelegate) =>
      color != oldDelegate.color ||
      isMeSender != oldDelegate.isMeSender ||
      showTail != oldDelegate.showTail ||
      radius != oldDelegate.radius ||
      tailSize != oldDelegate.tailSize ||
      isRtl != oldDelegate.isRtl;
}

/// Messenger iOS bubble style
///
/// Uses fully rounded bubbles with no tail. Corner radii vary based on
/// message grouping:
/// - Full radius on all corners for first/single message
/// - Reduced radius on grouped side for consecutive messages
class VMessengerBubblePainter extends VBubblePainter {
  late Paint _cachedPaint;
  late Color _lastColor;
  bool _isInitialized = false;

  VMessengerBubblePainter({
    required super.color,
    required super.isMeSender,
    required super.showTail,
    required super.radius,
    required super.tailSize,
    super.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!_isInitialized || _lastColor != color) {
      _cachedPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      _lastColor = color;
      _isInitialized = true;
    }
    // Calculate corner radii based on grouping
    final fullRadius = radius;
    final groupedRadius =
        radius * BubblePainterConstants.messengerGroupedCornerRatio;
    // showTail = true: last message in group (full radius)
    // showTail = false: middle message (small radius on grouped side)
    // Use tailOnRight to determine which side is grouped (respects RTL)
    double topLeft, topRight, bottomLeft, bottomRight;
    if (tailOnRight) {
      // Grouped side is right
      topLeft = fullRadius;
      bottomLeft = fullRadius;
      topRight = showTail ? fullRadius : groupedRadius;
      bottomRight = showTail ? fullRadius : groupedRadius;
    } else {
      // Grouped side is left
      topRight = fullRadius;
      bottomRight = fullRadius;
      topLeft = showTail ? fullRadius : groupedRadius;
      bottomLeft = showTail ? fullRadius : groupedRadius;
    }
    final rect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width,
      size.height,
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
    canvas.drawRRect(rect, _cachedPaint);
  }

  @override
  bool shouldRepaint(VMessengerBubblePainter oldDelegate) =>
      color != oldDelegate.color ||
      isMeSender != oldDelegate.isMeSender ||
      showTail != oldDelegate.showTail ||
      radius != oldDelegate.radius ||
      tailSize != oldDelegate.tailSize ||
      isRtl != oldDelegate.isRtl;
}

/// iMessage iOS bubble style
///
/// Uses a distinctive curved tail that swoops outward from the bottom corner.
/// The tail is an elegant bezier curve iconic to iOS Messages app.
class VIMessageBubblePainter extends VBubblePainter {
  late Paint _cachedPaint;
  late Color _lastColor;
  late Path _cachedPath;
  late Size _cachedSize;
  late bool _cachedShowTail;
  late bool _cachedTailOnRight;
  late double _cachedRadius;
  bool _isPaintInitialized = false;
  bool _isPathInitialized = false;

  VIMessageBubblePainter({
    required super.color,
    required super.isMeSender,
    required super.showTail,
    required super.radius,
    required super.tailSize,
    super.isRtl,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!_isPaintInitialized || _lastColor != color) {
      _cachedPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      _lastColor = color;
      _isPaintInitialized = true;
    }
    if (!_isPathInitialized ||
        _cachedSize != size ||
        _cachedShowTail != showTail ||
        _cachedTailOnRight != tailOnRight ||
        _cachedRadius != radius) {
      // Use tailOnRight to determine path (respects RTL)
      final tailPath =
          tailOnRight ? _createRightTailPath(size) : _createLeftTailPath(size);
      _cachedPath = showTail ? tailPath : createSimpleRoundedPath(size);
      _cachedSize = size;
      _cachedShowTail = showTail;
      _cachedTailOnRight = tailOnRight;
      _cachedRadius = radius;
      _isPathInitialized = true;
    }
    canvas.drawPath(_cachedPath, _cachedPaint);
  }

  /// Creates bubble path with iconic iMessage tail on bottom-right
  Path _createRightTailPath(Size size) {
    final width = size.width;
    final height = size.height;
    final cornerRadius = radius;
    const curveFactor = BubblePainterConstants.imessageTailCurveFactor;
    final path = Path();
    // Start top-left
    path.moveTo(cornerRadius, 0);
    // Top edge
    path.lineTo(width - cornerRadius, 0);
    // Top-right corner
    path.quadraticBezierTo(width, 0, width, cornerRadius);
    // Right edge down to tail area
    path.lineTo(width, height - cornerRadius);
    // The iconic iMessage tail using cubic bezier curves
    // First curve: down and out toward tail tip
    path.cubicTo(
      width,
      height - cornerRadius * curveFactor,
      width + cornerRadius * 0.1,
      height - cornerRadius * 0.1,
      width + tailSize * 0.6,
      height + tailSize * curveFactor,
    );
    // Second curve: back in and up to bottom edge
    path.cubicTo(
      width + tailSize * 0.2,
      height + tailSize * 0.1,
      width - cornerRadius * curveFactor,
      height,
      width - cornerRadius,
      height,
    );
    // Bottom edge
    path.lineTo(cornerRadius, height);
    // Bottom-left corner
    path.quadraticBezierTo(0, height, 0, height - cornerRadius);
    // Left edge
    path.lineTo(0, cornerRadius);
    // Top-left corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.close();
    return path;
  }

  /// Creates bubble path with iMessage tail on bottom-left (mirrored)
  Path _createLeftTailPath(Size size) {
    final width = size.width;
    final height = size.height;
    final cornerRadius = radius;
    const curveFactor = BubblePainterConstants.imessageTailCurveFactor;
    final path = Path();
    // Start top-left
    path.moveTo(cornerRadius, 0);
    // Top edge
    path.lineTo(width - cornerRadius, 0);
    // Top-right corner
    path.quadraticBezierTo(width, 0, width, cornerRadius);
    // Right edge
    path.lineTo(width, height - cornerRadius);
    // Bottom-right corner
    path.quadraticBezierTo(width, height, width - cornerRadius, height);
    // Bottom edge to tail
    path.lineTo(cornerRadius, height);
    // The iconic iMessage tail (mirrored)
    path.cubicTo(
      cornerRadius * curveFactor,
      height,
      -tailSize * 0.2,
      height + tailSize * 0.1,
      -tailSize * 0.6,
      height + tailSize * curveFactor,
    );
    // Curve back up
    path.cubicTo(
      -cornerRadius * 0.1,
      height - cornerRadius * 0.1,
      0,
      height - cornerRadius * curveFactor,
      0,
      height - cornerRadius,
    );
    // Left edge
    path.lineTo(0, cornerRadius);
    // Top-left corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(VIMessageBubblePainter oldDelegate) =>
      color != oldDelegate.color ||
      isMeSender != oldDelegate.isMeSender ||
      showTail != oldDelegate.showTail ||
      radius != oldDelegate.radius ||
      tailSize != oldDelegate.tailSize ||
      isRtl != oldDelegate.isRtl;
}
