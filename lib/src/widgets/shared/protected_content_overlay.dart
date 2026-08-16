import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/enums.dart';
import '../../core/modern_message_models.dart';

/// Stateful overlay for spoiler, view-once, and expiring message content.
class VProtectedContentOverlay extends StatefulWidget {
  final VContentProtectionData protection;
  final VoidCallback? onReveal;
  final VoidCallback? onExpired;

  const VProtectedContentOverlay({
    super.key,
    required this.protection,
    this.onReveal,
    this.onExpired,
  });

  @override
  State<VProtectedContentOverlay> createState() =>
      _VProtectedContentOverlayState();
}

class _VProtectedContentOverlayState extends State<VProtectedContentOverlay> {
  Timer? _timer;
  late bool _revealed;
  DateTime _now = DateTime.now();
  bool _reportedExpiry = false;

  bool get _isExpired => widget.protection.isExpiredAt(_now);

  @override
  void initState() {
    super.initState();
    _revealed = widget.protection.initiallyRevealed;
    _startTimerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant VProtectedContentOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.protection.mode != widget.protection.mode ||
        oldWidget.protection.expiresAt != widget.protection.expiresAt ||
        oldWidget.protection.viewedAt != widget.protection.viewedAt) {
      _now = DateTime.now();
      _revealed = widget.protection.initiallyRevealed;
      _reportedExpiry = false;
      _startTimerIfNeeded();
    }
  }

  void _startTimerIfNeeded() {
    _timer?.cancel();
    if (widget.protection.expiresAt == null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
      if (_isExpired) {
        _timer?.cancel();
        if (!_reportedExpiry) {
          _reportedExpiry = true;
          widget.onExpired?.call();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _reveal() {
    _now = DateTime.now();
    if (_isExpired) return;
    setState(() => _revealed = true);
    widget.onReveal?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (_revealed && !_isExpired) return const SizedBox.shrink();

    final remaining = widget.protection.remainingAt(_now);
    final label = _isExpired
        ? widget.protection.expiredLabel
        : widget.protection.revealLabel;
    final icon = switch (widget.protection.mode) {
      VContentProtectionMode.spoiler => Icons.visibility_off_outlined,
      VContentProtectionMode.viewOnce => Icons.looks_one_outlined,
      VContentProtectionMode.expiring => Icons.timer_outlined,
    };

    return Positioned.fill(
      child: Semantics(
        button: !_isExpired,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _isExpired ? null : _reveal,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.62),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: Colors.white, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        label,
                        key: const ValueKey('v-protected-content-label'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!_isExpired && remaining != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _formatDuration(remaining),
                          key: const ValueKey('v-protected-content-countdown'),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds.clamp(0, 359999);
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
