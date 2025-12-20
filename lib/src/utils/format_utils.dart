// Utility functions for formatting durations, file sizes, and other values

/// Formats a Duration into a human-readable string
///
/// Formats:
/// - Under 1 minute: "45s"
/// - Under 1 hour: "5:30" (minutes:seconds)
/// - 1 hour or more: "1:05:30" (hours:minutes:seconds)
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

/// Formats a Duration for call logs with human-readable units
///
/// Formats:
/// - Under 1 minute: "45s"
/// - Under 1 hour: "5m 30s"
/// - 1 hour or more: "1h 5m"
String formatCallDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  if (hours > 0) {
    return '${hours}h ${minutes}m';
  }
  if (minutes > 0) {
    return '${minutes}m ${seconds}s';
  }
  return '${seconds}s';
}

/// Formats file size in bytes to human-readable string
///
/// Examples: "512 B", "1.5 KB", "3.2 MB", "1.1 GB"
String formatFileSize(int bytes) {
  const int kb = 1024;
  const int mb = kb * 1024;
  const int gb = mb * 1024;
  if (bytes < kb) {
    return '$bytes B';
  }
  if (bytes < mb) {
    return '${(bytes / kb).toStringAsFixed(1)} KB';
  }
  if (bytes < gb) {
    return '${(bytes / mb).toStringAsFixed(1)} MB';
  }
  return '${(bytes / gb).toStringAsFixed(1)} GB';
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

/// Format date for display (e.g., "Jan 15, 2024")
String formatDate(DateTime date) {
  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}

/// Format time for display (e.g., "2:30 PM")
String formatTime(DateTime time) {
  final hour = time.hour;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  return '$displayHour:$minute $period';
}

/// Format date and time combined
String formatDateTime(DateTime dateTime) {
  return '${formatDate(dateTime)} at ${formatTime(dateTime)}';
}
