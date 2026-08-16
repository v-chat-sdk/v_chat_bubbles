import 'package:flutter/foundation.dart';

import 'enums.dart';

/// Minimal message metadata used to calculate visual grouping.
@immutable
class VMessageGroupingInfo {
  /// Stable sender identifier. Consecutive messages must match to be grouped.
  final String senderId;

  /// Creation time used with the configured grouping time threshold.
  final DateTime sentAt;

  /// Forces this message to start and end its own visual group.
  ///
  /// Use this for system events, date separators, or messages whose visual
  /// treatment must not be joined to adjacent bubbles.
  final bool breaksGroup;

  const VMessageGroupingInfo({
    required this.senderId,
    required this.sentAt,
    this.breaksGroup = false,
  });
}

/// Resolves deterministic bubble positions for a chronologically ordered list.
abstract final class VMessageGrouping {
  /// Resolves every item in [messages] using [timeThreshold].
  static List<VMessageGroupPosition> resolve(
    List<VMessageGroupingInfo> messages, {
    Duration timeThreshold = const Duration(minutes: 1),
  }) {
    assert(!timeThreshold.isNegative, 'timeThreshold must not be negative');
    return List<VMessageGroupPosition>.generate(
      messages.length,
      (index) => resolveAt(messages, index, timeThreshold: timeThreshold),
      growable: false,
    );
  }

  /// Resolves one item without allocating positions for the entire list.
  static VMessageGroupPosition resolveAt(
    List<VMessageGroupingInfo> messages,
    int index, {
    Duration timeThreshold = const Duration(minutes: 1),
  }) {
    if (index < 0 || index >= messages.length) {
      throw RangeError.index(index, messages, 'index');
    }
    if (timeThreshold.isNegative) {
      throw ArgumentError.value(
        timeThreshold,
        'timeThreshold',
        'must not be negative',
      );
    }

    final joinsPrevious =
        index > 0 &&
        _canGroup(messages[index - 1], messages[index], timeThreshold);
    final joinsNext =
        index < messages.length - 1 &&
        _canGroup(messages[index], messages[index + 1], timeThreshold);

    if (!joinsPrevious && !joinsNext) return VMessageGroupPosition.single;
    if (!joinsPrevious) return VMessageGroupPosition.first;
    if (joinsNext) return VMessageGroupPosition.middle;
    return VMessageGroupPosition.last;
  }

  static bool _canGroup(
    VMessageGroupingInfo earlier,
    VMessageGroupingInfo later,
    Duration threshold,
  ) {
    if (earlier.breaksGroup || later.breaksGroup) return false;
    if (earlier.senderId != later.senderId) return false;
    final difference = later.sentAt.difference(earlier.sentAt);
    return !difference.isNegative && difference <= threshold;
  }
}
