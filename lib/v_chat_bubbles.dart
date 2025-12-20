/// A comprehensive chat bubble library supporting multiple messaging app styles.
///
/// Provides Telegram, WhatsApp, Messenger, and iMessage bubble styles
/// with full theming, callbacks, and customization support.
library;

// Re-export v_platform for convenient VPlatformFile access
export 'package:v_platform/v_platform.dart';

// Re-export v_chat_voice_player for voice message controller
export 'package:v_chat_voice_player/v_chat_voice_player.dart';

// Core
export 'src/core/core.dart';

// Theme
export 'src/theme/theme.dart';

// Painters
export 'src/painters/painters.dart';

// Widgets
export 'src/widgets/widgets.dart';

// Viewers
export 'src/viewers/viewers.dart';

// Utils
export 'src/utils/utils.dart';
