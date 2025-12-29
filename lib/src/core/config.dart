import 'package:flutter/material.dart';

import '../utils/pattern_presets.dart';
import 'context_menu_config.dart';
import 'enums.dart';
import 'models.dart';

/// Configuration for animation durations
@immutable
class VAnimationConfig {
  final Duration fadeIn;
  final Duration fadeOut;
  final Duration expand;
  final Duration collapse;
  final Duration highlight;
  final Duration swipe;
  final Curve defaultCurve;
  const VAnimationConfig({
    this.fadeIn = const Duration(milliseconds: 200),
    this.fadeOut = const Duration(milliseconds: 150),
    this.expand = const Duration(milliseconds: 300),
    this.collapse = const Duration(milliseconds: 250),
    this.highlight = const Duration(milliseconds: 1500),
    this.swipe = const Duration(milliseconds: 600),
    this.defaultCurve = Curves.easeOutCubic,
  });

  /// Standard animations (default)
  static const standard = VAnimationConfig();

  /// Fast animations for snappy feel
  static const fast = VAnimationConfig(
    fadeIn: Duration(milliseconds: 100),
    fadeOut: Duration(milliseconds: 80),
    expand: Duration(milliseconds: 200),
    collapse: Duration(milliseconds: 150),
    highlight: Duration(milliseconds: 1000),
    swipe: Duration(milliseconds: 150),
  );

  /// Slow animations for smooth feel
  static const slow = VAnimationConfig(
    fadeIn: Duration(milliseconds: 350),
    fadeOut: Duration(milliseconds: 250),
    expand: Duration(milliseconds: 450),
    collapse: Duration(milliseconds: 400),
    highlight: Duration(milliseconds: 2500),
    swipe: Duration(milliseconds: 300),
  );

  /// No animations - instant transitions
  static const none = VAnimationConfig(
    fadeIn: Duration.zero,
    fadeOut: Duration.zero,
    expand: Duration.zero,
    collapse: Duration.zero,
    highlight: Duration.zero,
    swipe: Duration.zero,
  );
  VAnimationConfig copyWith({
    Duration? fadeIn,
    Duration? fadeOut,
    Duration? expand,
    Duration? collapse,
    Duration? highlight,
    Duration? swipe,
    Curve? defaultCurve,
  }) =>
      VAnimationConfig(
        fadeIn: fadeIn ?? this.fadeIn,
        fadeOut: fadeOut ?? this.fadeOut,
        expand: expand ?? this.expand,
        collapse: collapse ?? this.collapse,
        highlight: highlight ?? this.highlight,
        swipe: swipe ?? this.swipe,
        defaultCurve: defaultCurve ?? this.defaultCurve,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VAnimationConfig &&
          runtimeType == other.runtimeType &&
          fadeIn == other.fadeIn &&
          fadeOut == other.fadeOut &&
          expand == other.expand &&
          collapse == other.collapse &&
          highlight == other.highlight &&
          swipe == other.swipe &&
          defaultCurve == other.defaultCurve;
  @override
  int get hashCode => Object.hash(
        fadeIn,
        fadeOut,
        expand,
        collapse,
        highlight,
        swipe,
        defaultCurve,
      );
}

/// Configuration for accessibility features
@immutable
class VAccessibilityConfig {
  /// Enable semantic labels for screen readers
  final bool enableSemanticLabels;

  /// Minimum tap target size (48x48 recommended for accessibility)
  final double minTapTargetSize;

  /// Enable high contrast mode support
  final bool enableHighContrast;

  /// Custom semantic label builder for messages
  final String Function(String messageType, String content)?
      semanticLabelBuilder;
  const VAccessibilityConfig({
    this.enableSemanticLabels = true,
    this.minTapTargetSize = 48,
    this.enableHighContrast = false,
    this.semanticLabelBuilder,
  });

  /// Standard accessibility settings
  static const standard = VAccessibilityConfig();

  /// Enhanced accessibility (larger tap targets, high contrast)
  static const enhanced = VAccessibilityConfig(
    minTapTargetSize: 56,
    enableHighContrast: true,
  );

  /// Minimal accessibility (smaller targets, no semantics)
  static const minimal = VAccessibilityConfig(
    enableSemanticLabels: false,
    minTapTargetSize: 40,
  );
  VAccessibilityConfig copyWith({
    bool? enableSemanticLabels,
    double? minTapTargetSize,
    bool? enableHighContrast,
    String Function(String messageType, String content)? semanticLabelBuilder,
  }) =>
      VAccessibilityConfig(
        enableSemanticLabels: enableSemanticLabels ?? this.enableSemanticLabels,
        minTapTargetSize: minTapTargetSize ?? this.minTapTargetSize,
        enableHighContrast: enableHighContrast ?? this.enableHighContrast,
        semanticLabelBuilder: semanticLabelBuilder ?? this.semanticLabelBuilder,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VAccessibilityConfig &&
          runtimeType == other.runtimeType &&
          enableSemanticLabels == other.enableSemanticLabels &&
          minTapTargetSize == other.minTapTargetSize &&
          enableHighContrast == other.enableHighContrast &&
          semanticLabelBuilder == other.semanticLabelBuilder;
  @override
  int get hashCode => Object.hash(
        enableSemanticLabels,
        minTapTargetSize,
        enableHighContrast,
        semanticLabelBuilder,
      );
}

/// Configuration for text pattern detection and formatting
///
/// Use this to configure custom patterns or enable/disable built-in patterns.
/// For full control, pass [customPatterns] directly.
@immutable
class VPatternConfig {
  /// Custom patterns to apply (order matters - first match wins)
  /// When provided, flag-based patterns are ignored
  final List<VCustomPattern>? customPatterns;

  /// Enable standard link detection
  final bool enableLinks;

  /// Enable phone detection
  final bool enablePhones;

  /// Enable email detection
  final bool enableEmails;

  /// Enable mention detection (@username)
  final bool enableMentions;

  /// Enable hashtag detection (#tag)
  final bool enableHashtags;

  /// Enable inline formatting patterns (bold, italic, inline code, strikethrough)
  final bool enableFormatting;

  // ===== BLOCK-LEVEL PATTERNS =====

  /// Enable code block parsing (```code```)
  final bool enableCodeBlocks;

  /// Enable blockquote parsing (> text)
  final bool enableBlockquotes;

  /// Enable bullet list parsing (- item or * item)
  final bool enableBulletLists;

  /// Enable numbered list parsing (1. item)
  final bool enableNumberedLists;

  /// Enable mention with ID pattern ([@DisplayName:userId])
  /// Displays @DisplayName but provides userId in callbacks via VPatternPresets.extractMentionId()
  final bool enableMentionWithId;
  const VPatternConfig({
    this.customPatterns,
    this.enableLinks = true,
    this.enablePhones = true,
    this.enableEmails = true,
    this.enableMentions = false,
    this.enableHashtags = false,
    this.enableFormatting = false,
    this.enableCodeBlocks = false,
    this.enableBlockquotes = false,
    this.enableBulletLists = false,
    this.enableNumberedLists = false,
    this.enableMentionWithId = false,
  });

  /// Use fully custom patterns
  factory VPatternConfig.custom(List<VCustomPattern> patterns) =>
      VPatternConfig(customPatterns: patterns);

  /// Standard detection (url, email, phone, mention)
  static const standard = VPatternConfig();

  /// No detection - plain text only
  static const none = VPatternConfig(
    enableLinks: false,
    enablePhones: false,
    enableEmails: false,
    enableMentions: false,
  );

  /// Links only
  static const linksOnly = VPatternConfig(
    enableLinks: true,
    enablePhones: false,
    enableEmails: false,
    enableMentions: false,
  );

  /// Inline formatting only (bold, italic, code, strikethrough)
  static const withFormatting = VPatternConfig(
    enableFormatting: true,
    enableHashtags: true,
  );

  /// Full markdown support - all inline + all block patterns
  static const markdown = VPatternConfig(
    enableFormatting: true,
    enableHashtags: true,
    enableCodeBlocks: true,
    enableBlockquotes: true,
    enableBulletLists: true,
    enableNumberedLists: true,
  );

  /// Block patterns only (code blocks, blockquotes, lists)
  static const blocksOnly = VPatternConfig(
    enableLinks: false,
    enablePhones: false,
    enableEmails: false,
    enableMentions: false,
    enableCodeBlocks: true,
    enableBlockquotes: true,
    enableBulletLists: true,
    enableNumberedLists: true,
  );

  /// Code blocks only
  static const codeBlocksOnly = VPatternConfig(
    enableCodeBlocks: true,
  );

  /// Check if any block patterns are enabled
  bool get hasBlockPatterns =>
      enableCodeBlocks ||
      enableBlockquotes ||
      enableBulletLists ||
      enableNumberedLists;

  /// Build effective patterns list based on config
  ///
  /// Custom patterns are added first (higher priority), then flag-based patterns
  List<VCustomPattern> buildPatterns({
    required TextStyle baseStyle,
    required TextStyle linkStyle,
    TextStyle? mentionStyle,
    TextStyle? mentionWithIdStyle,
  }) {
    final patterns = <VCustomPattern>[];
    // Add custom patterns first (they have higher priority)
    if (customPatterns != null) {
      patterns.addAll(customPatterns!);
    }
    // Add flag-based patterns
    if (enableLinks) {
      patterns.add(VPatternPresets.url(style: linkStyle));
    }
    if (enableEmails) {
      patterns.add(VPatternPresets.email(style: linkStyle));
    }
    if (enablePhones) {
      patterns.add(VPatternPresets.phone(style: linkStyle));
    }
    if (enableMentions) {
      patterns.add(VPatternPresets.mention(style: mentionStyle ?? linkStyle));
    }
    if (enableMentionWithId) {
      patterns.add(VPatternPresets.mentionWithId(
        style: mentionWithIdStyle ?? mentionStyle ?? linkStyle,
      ));
    }
    if (enableHashtags) {
      patterns.add(VPatternPresets.hashtag(style: linkStyle));
    }
    if (enableFormatting) {
      patterns.addAll(VPatternPresets.extendedFormatting(baseStyle: baseStyle));
    }
    return patterns;
  }

  VPatternConfig copyWith({
    List<VCustomPattern>? customPatterns,
    bool? enableLinks,
    bool? enablePhones,
    bool? enableEmails,
    bool? enableMentions,
    bool? enableHashtags,
    bool? enableFormatting,
    bool? enableCodeBlocks,
    bool? enableBlockquotes,
    bool? enableBulletLists,
    bool? enableNumberedLists,
    bool? enableMentionWithId,
  }) =>
      VPatternConfig(
        customPatterns: customPatterns ?? this.customPatterns,
        enableLinks: enableLinks ?? this.enableLinks,
        enablePhones: enablePhones ?? this.enablePhones,
        enableEmails: enableEmails ?? this.enableEmails,
        enableMentions: enableMentions ?? this.enableMentions,
        enableHashtags: enableHashtags ?? this.enableHashtags,
        enableFormatting: enableFormatting ?? this.enableFormatting,
        enableCodeBlocks: enableCodeBlocks ?? this.enableCodeBlocks,
        enableBlockquotes: enableBlockquotes ?? this.enableBlockquotes,
        enableBulletLists: enableBulletLists ?? this.enableBulletLists,
        enableNumberedLists: enableNumberedLists ?? this.enableNumberedLists,
        enableMentionWithId: enableMentionWithId ?? this.enableMentionWithId,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VPatternConfig &&
          runtimeType == other.runtimeType &&
          enableLinks == other.enableLinks &&
          enablePhones == other.enablePhones &&
          enableEmails == other.enableEmails &&
          enableMentions == other.enableMentions &&
          enableHashtags == other.enableHashtags &&
          enableFormatting == other.enableFormatting &&
          enableCodeBlocks == other.enableCodeBlocks &&
          enableBlockquotes == other.enableBlockquotes &&
          enableBulletLists == other.enableBulletLists &&
          enableNumberedLists == other.enableNumberedLists &&
          enableMentionWithId == other.enableMentionWithId;
  @override
  int get hashCode => Object.hash(
        enableLinks,
        enablePhones,
        enableEmails,
        enableMentions,
        enableHashtags,
        enableFormatting,
        enableCodeBlocks,
        enableBlockquotes,
        enableBulletLists,
        enableNumberedLists,
        enableMentionWithId,
      );
}

/// Configuration for gesture interactions
@immutable
class VGestureConfig {
  final bool enableSwipeToReply;
  final bool enableLongPress;
  final bool enableDoubleTapToReact;
  final bool enableHapticFeedback;
  final double swipeThreshold;
  const VGestureConfig({
    this.enableSwipeToReply = true,
    this.enableLongPress = true,
    this.enableDoubleTapToReact = false,
    this.enableHapticFeedback = true,
    this.swipeThreshold = 64,
  });

  /// All gestures enabled (default)
  static const all = VGestureConfig(enableDoubleTapToReact: true);

  /// No gestures - read-only mode
  static const none = VGestureConfig(
    enableSwipeToReply: false,
    enableLongPress: false,
    enableDoubleTapToReact: false,
    enableHapticFeedback: false,
  );
  VGestureConfig copyWith({
    bool? enableSwipeToReply,
    bool? enableLongPress,
    bool? enableDoubleTapToReact,
    bool? enableHapticFeedback,
    double? swipeThreshold,
  }) =>
      VGestureConfig(
        enableSwipeToReply: enableSwipeToReply ?? this.enableSwipeToReply,
        enableLongPress: enableLongPress ?? this.enableLongPress,
        enableDoubleTapToReact:
            enableDoubleTapToReact ?? this.enableDoubleTapToReact,
        enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
        swipeThreshold: swipeThreshold ?? this.swipeThreshold,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VGestureConfig &&
          runtimeType == other.runtimeType &&
          enableSwipeToReply == other.enableSwipeToReply &&
          enableLongPress == other.enableLongPress &&
          enableDoubleTapToReact == other.enableDoubleTapToReact &&
          enableHapticFeedback == other.enableHapticFeedback &&
          swipeThreshold == other.swipeThreshold;
  @override
  int get hashCode => Object.hash(
        enableSwipeToReply,
        enableLongPress,
        enableDoubleTapToReact,
        enableHapticFeedback,
        swipeThreshold,
      );
}

/// Configuration for avatar display
@immutable
class VAvatarConfig {
  final bool show;
  final VAvatarPosition position;
  final double size;
  const VAvatarConfig({
    this.show = true,
    this.position = VAvatarPosition.bottom,
    this.size = 32,
  });

  /// Show avatars (default)
  static const visible = VAvatarConfig();

  /// Hide avatars - 1:1 chat style
  static const hidden = VAvatarConfig(show: false);

  /// Small avatars (24px)
  static const small = VAvatarConfig(size: 24);

  /// Large avatars (40px)
  static const large = VAvatarConfig(size: 40);
  VAvatarConfig copyWith({
    bool? show,
    VAvatarPosition? position,
    double? size,
  }) =>
      VAvatarConfig(
        show: show ?? this.show,
        position: position ?? this.position,
        size: size ?? this.size,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VAvatarConfig &&
          runtimeType == other.runtimeType &&
          show == other.show &&
          position == other.position &&
          size == other.size;
  @override
  int get hashCode => Object.hash(show, position, size);
}

/// Configuration for bubble sizing constraints
@immutable
class VSizingConfig {
  final double maxWidthFraction;
  final double? maxWidth;
  final double minWidth;
  final double wideScreenBreakpoint;
  const VSizingConfig({
    this.maxWidthFraction = 0.75,
    this.maxWidth = 420,
    this.minWidth = 80,
    this.wideScreenBreakpoint = 600,
  });

  /// Default sizing (75% width, 420px max)
  static const standard = VSizingConfig();

  /// Compact sizing for dense layouts
  static const compact = VSizingConfig(
    maxWidthFraction: 0.65,
    maxWidth: 320,
    minWidth: 60,
  );

  /// Wide sizing for desktop/tablet
  static const wide = VSizingConfig(
    maxWidthFraction: 0.5,
    maxWidth: 600,
    wideScreenBreakpoint: 900,
  );

  /// Full width bubbles
  static const fullWidth = VSizingConfig(
    maxWidthFraction: 0.95,
    maxWidth: null,
    minWidth: 100,
  );

  /// Calculate effective max width based on screen width
  double getEffectiveMaxWidth(double screenWidth) {
    final fractionWidth = screenWidth * maxWidthFraction;
    if (maxWidth == null) return fractionWidth;
    if (screenWidth >= wideScreenBreakpoint) {
      return fractionWidth < maxWidth! ? fractionWidth : maxWidth!;
    }
    return fractionWidth;
  }

  VSizingConfig copyWith({
    double? maxWidthFraction,
    double? maxWidth,
    double? minWidth,
    double? wideScreenBreakpoint,
  }) =>
      VSizingConfig(
        maxWidthFraction: maxWidthFraction ?? this.maxWidthFraction,
        maxWidth: maxWidth ?? this.maxWidth,
        minWidth: minWidth ?? this.minWidth,
        wideScreenBreakpoint: wideScreenBreakpoint ?? this.wideScreenBreakpoint,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VSizingConfig &&
          runtimeType == other.runtimeType &&
          maxWidthFraction == other.maxWidthFraction &&
          maxWidth == other.maxWidth &&
          minWidth == other.minWidth &&
          wideScreenBreakpoint == other.wideScreenBreakpoint;
  @override
  int get hashCode =>
      Object.hash(maxWidthFraction, maxWidth, minWidth, wideScreenBreakpoint);
}

/// Configuration for bubble spacing and dimensions
@immutable
class VSpacingConfig {
  final double bubbleRadius;
  final double tailSize;

  /// Vertical spacing between consecutive messages from same sender (smaller gap)
  final double sameSenderSpacing;

  /// Vertical spacing before first message from different sender (larger gap)
  final double differentSenderSpacing;
  final double horizontalMargin;

  /// Vertical padding inside bubble (top + bottom)
  final double contentPaddingVertical;

  /// Horizontal padding inside bubble (left + right base, before tail adjustment)
  final double contentPaddingHorizontal;
  const VSpacingConfig({
    this.bubbleRadius = 13,
    this.tailSize = 1,
    this.sameSenderSpacing = 4,
    this.differentSenderSpacing = 1,
    this.horizontalMargin = 5,
    this.contentPaddingVertical = 6,
    this.contentPaddingHorizontal = 12,
  });

  /// Default spacing
  static const standard = VSpacingConfig();

  /// Compact spacing (tighter layout)
  static const compact = VSpacingConfig(
    bubbleRadius: 14,
    tailSize: 6,
    sameSenderSpacing: 0,
    differentSenderSpacing: 3,
    horizontalMargin: 4,
    contentPaddingVertical: 4,
    contentPaddingHorizontal: 8,
  );

  /// Loose spacing (more breathing room)
  static const loose = VSpacingConfig(
    bubbleRadius: 20,
    tailSize: 10,
    sameSenderSpacing: 2,
    differentSenderSpacing: 8,
    horizontalMargin: 12,
    contentPaddingVertical: 8,
    contentPaddingHorizontal: 12,
  );

  /// Minimal tails (iMessage-like)
  static const minimal = VSpacingConfig(bubbleRadius: 20, tailSize: 0);

  /// Dense spacing (minimal gaps between bubbles)
  static const dense = VSpacingConfig(
    bubbleRadius: 10,
    tailSize: 0,
    sameSenderSpacing: 0,
    differentSenderSpacing: 2,
    horizontalMargin: 5,
    contentPaddingVertical: 4,
    contentPaddingHorizontal: 8,
  );
  VSpacingConfig copyWith({
    double? bubbleRadius,
    double? tailSize,
    double? sameSenderSpacing,
    double? differentSenderSpacing,
    double? horizontalMargin,
    double? contentPaddingVertical,
    double? contentPaddingHorizontal,
  }) =>
      VSpacingConfig(
        bubbleRadius: bubbleRadius ?? this.bubbleRadius,
        tailSize: tailSize ?? this.tailSize,
        sameSenderSpacing: sameSenderSpacing ?? this.sameSenderSpacing,
        differentSenderSpacing:
            differentSenderSpacing ?? this.differentSenderSpacing,
        horizontalMargin: horizontalMargin ?? this.horizontalMargin,
        contentPaddingVertical:
            contentPaddingVertical ?? this.contentPaddingVertical,
        contentPaddingHorizontal:
            contentPaddingHorizontal ?? this.contentPaddingHorizontal,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VSpacingConfig &&
          runtimeType == other.runtimeType &&
          bubbleRadius == other.bubbleRadius &&
          tailSize == other.tailSize &&
          sameSenderSpacing == other.sameSenderSpacing &&
          differentSenderSpacing == other.differentSenderSpacing &&
          horizontalMargin == other.horizontalMargin &&
          contentPaddingVertical == other.contentPaddingVertical &&
          contentPaddingHorizontal == other.contentPaddingHorizontal;
  @override
  int get hashCode => Object.hash(
        bubbleRadius,
        tailSize,
        sameSenderSpacing,
        differentSenderSpacing,
        horizontalMargin,
        contentPaddingVertical,
        contentPaddingHorizontal,
      );
}

/// Configuration for media display
@immutable
class VMediaConfig {
  final double cornerRadius;
  final double gallerySpacing;
  final double imageMaxHeight;
  final double videoMaxHeight;
  final double voiceMessageWidth;
  final double fileMessageWidth;

  /// Enable disk caching for network images using cached_network_image
  final bool cacheNetworkImages;
  const VMediaConfig({
    this.cornerRadius = 12,
    this.gallerySpacing = 2,
    this.imageMaxHeight = 300,
    this.videoMaxHeight = 300,
    this.voiceMessageWidth = 240,
    this.fileMessageWidth = 260,
    this.cacheNetworkImages = true,
  });

  /// Default media sizing
  static const standard = VMediaConfig();

  /// Compact media (smaller images/videos)
  static const compact = VMediaConfig(
    cornerRadius: 8,
    gallerySpacing: 1,
    imageMaxHeight: 200,
    videoMaxHeight: 200,
    voiceMessageWidth: 200,
    fileMessageWidth: 220,
  );

  /// Large media (larger images/videos)
  static const large = VMediaConfig(
    cornerRadius: 16,
    gallerySpacing: 3,
    imageMaxHeight: 400,
    videoMaxHeight: 400,
    voiceMessageWidth: 280,
    fileMessageWidth: 300,
  );
  VMediaConfig copyWith({
    double? cornerRadius,
    double? gallerySpacing,
    double? imageMaxHeight,
    double? videoMaxHeight,
    double? voiceMessageWidth,
    double? fileMessageWidth,
    bool? cacheNetworkImages,
  }) =>
      VMediaConfig(
        cornerRadius: cornerRadius ?? this.cornerRadius,
        gallerySpacing: gallerySpacing ?? this.gallerySpacing,
        imageMaxHeight: imageMaxHeight ?? this.imageMaxHeight,
        videoMaxHeight: videoMaxHeight ?? this.videoMaxHeight,
        voiceMessageWidth: voiceMessageWidth ?? this.voiceMessageWidth,
        fileMessageWidth: fileMessageWidth ?? this.fileMessageWidth,
        cacheNetworkImages: cacheNetworkImages ?? this.cacheNetworkImages,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VMediaConfig &&
          runtimeType == other.runtimeType &&
          cornerRadius == other.cornerRadius &&
          gallerySpacing == other.gallerySpacing &&
          imageMaxHeight == other.imageMaxHeight &&
          videoMaxHeight == other.videoMaxHeight &&
          voiceMessageWidth == other.voiceMessageWidth &&
          fileMessageWidth == other.fileMessageWidth &&
          cacheNetworkImages == other.cacheNetworkImages;
  @override
  int get hashCode => Object.hash(
        cornerRadius,
        gallerySpacing,
        imageMaxHeight,
        videoMaxHeight,
        voiceMessageWidth,
        fileMessageWidth,
        cacheNetworkImages,
      );
}

/// Configuration for text expansion (See more/less)
@immutable
class VTextExpansionConfig {
  final bool enabled;
  final int characterThreshold;
  const VTextExpansionConfig({
    this.enabled = true,
    this.characterThreshold = 300,
  });

  /// Enable text expansion (default)
  static const standard = VTextExpansionConfig();

  /// Disable text expansion - show full text always
  static const disabled = VTextExpansionConfig(enabled: false);

  /// Short threshold (150 chars)
  static const short = VTextExpansionConfig(characterThreshold: 150);

  /// Long threshold (500 chars)
  static const long = VTextExpansionConfig(characterThreshold: 500);
  VTextExpansionConfig copyWith({bool? enabled, int? characterThreshold}) =>
      VTextExpansionConfig(
        enabled: enabled ?? this.enabled,
        characterThreshold: characterThreshold ?? this.characterThreshold,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VTextExpansionConfig &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled &&
          characterThreshold == other.characterThreshold;
  @override
  int get hashCode => Object.hash(enabled, characterThreshold);
}

/// Configuration for translatable strings in the package
///
/// All user-facing text is organized by category for easy localization.
/// Use static factory constructors for common language presets or customize
/// individual strings via [copyWith].
@immutable
class VTranslationConfig {
  // ============= Context Menu Actions =============
  final String actionReply;
  final String actionForward;
  final String actionCopy;
  final String actionDownload;
  final String actionEdit;
  final String actionDelete;
  final String actionPin;
  final String actionUnpin;
  final String actionStar;
  final String actionUnstar;
  final String actionReport;
  final String actionSelect;
  final String actionShare;
  final String actionSave;
  final String actionInfo;
  final String actionTranslate;
  final String actionSpeak;

  // ============= Message Status =============
  final String statusSent;
  final String statusReceived;
  final String statusEdited;
  final String statusPinned;
  final String statusStarred;

  // ============= Poll Labels =============
  final String pollQuiz;
  final String pollMultipleChoice;
  final String pollDefault;
  final String pollAnonymous;

  // ============= Call Labels =============
  final String callVideo;
  final String callVoice;
  final String callIncoming;
  final String callOutgoing;
  final String callMissed;
  final String callDeclined;
  final String callCancelled;
  final String callNotAnswered;
  final String callDeclinedStatus;
  final String callCancelledStatus;
  final String callTapToCallBack;

  // ============= Deleted Message =============
  final String deletedMessage;

  // ============= Unread Divider =============
  final String unreadSingular;
  final String unreadPlural;

  // ============= Location =============
  final String locationTapToOpen;

  // ============= Media Viewer =============
  final String viewerClose;
  final String viewerDownload;
  final String viewerShare;
  final String viewerRetry;

  // ============= Context Menu =============
  final String contextMenuCancel;

  // ============= Text Expansion =============
  final String seeMore;
  final String seeLess;

  // ============= Receipt Labels =============
  final String receiptTitle;
  final String receiptOrderPrefix;
  final String receiptSubtotal;
  final String receiptTax;
  final String receiptTotal;

  const VTranslationConfig({
    this.actionReply = 'Reply',
    this.actionForward = 'Forward',
    this.actionCopy = 'Copy',
    this.actionDownload = 'Download',
    this.actionEdit = 'Edit',
    this.actionDelete = 'Delete',
    this.actionPin = 'Pin',
    this.actionUnpin = 'Unpin',
    this.actionStar = 'Star',
    this.actionUnstar = 'Unstar',
    this.actionReport = 'Report',
    this.actionSelect = 'Select',
    this.actionShare = 'Share',
    this.actionSave = 'Save',
    this.actionInfo = 'Info',
    this.actionTranslate = 'Translate',
    this.actionSpeak = 'Speak',
    this.statusSent = 'Sent',
    this.statusReceived = 'Received',
    this.statusEdited = 'edited',
    this.statusPinned = 'pinned',
    this.statusStarred = 'starred',
    this.pollQuiz = 'Quiz',
    this.pollMultipleChoice = 'Multiple Choice Poll',
    this.pollDefault = 'Poll',
    this.pollAnonymous = 'Anonymous',
    this.callVideo = 'Video',
    this.callVoice = 'Voice',
    this.callIncoming = 'Incoming',
    this.callOutgoing = 'Outgoing',
    this.callMissed = 'Missed',
    this.callDeclined = 'Declined',
    this.callCancelled = 'Cancelled',
    this.callNotAnswered = 'Not answered',
    this.callDeclinedStatus = 'Call declined',
    this.callCancelledStatus = 'Call cancelled',
    this.callTapToCallBack = 'Tap to call back',
    this.deletedMessage = 'This message was deleted',
    this.unreadSingular = 'unread message',
    this.unreadPlural = 'unread messages',
    this.locationTapToOpen = 'Tap to open in maps',
    this.viewerClose = 'Close',
    this.viewerDownload = 'Download',
    this.viewerShare = 'Share',
    this.viewerRetry = 'Retry',
    this.contextMenuCancel = 'Cancel',
    this.seeMore = 'See more',
    this.seeLess = 'See less',
    this.receiptTitle = 'Receipt',
    this.receiptOrderPrefix = 'Order #',
    this.receiptSubtotal = 'Subtotal',
    this.receiptTax = 'Tax',
    this.receiptTotal = 'Total',
  });

  /// English (default)
  static const english = VTranslationConfig();

  /// Spanish translations
  static const spanish = VTranslationConfig(
    actionReply: 'Responder',
    actionForward: 'Reenviar',
    actionCopy: 'Copiar',
    actionDownload: 'Descargar',
    actionEdit: 'Editar',
    actionDelete: 'Eliminar',
    actionPin: 'Fijar',
    actionUnpin: 'Desfijar',
    actionStar: 'Marcar',
    actionUnstar: 'Desmarcar',
    actionReport: 'Reportar',
    actionSelect: 'Seleccionar',
    actionShare: 'Compartir',
    actionSave: 'Guardar',
    actionInfo: 'Información',
    actionTranslate: 'Traducir',
    actionSpeak: 'Hablar',
    statusSent: 'Enviado',
    statusReceived: 'Recibido',
    statusEdited: 'editado',
    statusPinned: 'fijado',
    statusStarred: 'marcado',
    pollQuiz: 'Cuestionario',
    pollMultipleChoice: 'Encuesta de opción múltiple',
    pollDefault: 'Encuesta',
    pollAnonymous: 'Anónimo',
    callVideo: 'Vídeo',
    callVoice: 'Voz',
    callIncoming: 'Entrante',
    callOutgoing: 'Saliente',
    callMissed: 'Perdida',
    callDeclined: 'Rechazada',
    callCancelled: 'Cancelada',
    callNotAnswered: 'No respondida',
    callDeclinedStatus: 'Llamada rechazada',
    callCancelledStatus: 'Llamada cancelada',
    callTapToCallBack: 'Toca para devolver la llamada',
    deletedMessage: 'Este mensaje fue eliminado',
    unreadSingular: 'mensaje no leído',
    unreadPlural: 'mensajes no leídos',
    locationTapToOpen: 'Toca para abrir en mapas',
    viewerClose: 'Cerrar',
    viewerDownload: 'Descargar',
    viewerShare: 'Compartir',
    viewerRetry: 'Reintentar',
    contextMenuCancel: 'Cancelar',
    seeMore: 'Ver más',
    seeLess: 'Ver menos',
    receiptTitle: 'Recepción',
    receiptOrderPrefix: 'Pedido #',
    receiptSubtotal: 'Subtotal',
    receiptTax: 'Impuesto',
    receiptTotal: 'Total',
  );

  /// French translations
  static const french = VTranslationConfig(
    actionReply: 'Répondre',
    actionForward: 'Transférer',
    actionCopy: 'Copier',
    actionDownload: 'Télécharger',
    actionEdit: 'Modifier',
    actionDelete: 'Supprimer',
    actionPin: 'Épingler',
    actionUnpin: 'Désépingler',
    actionStar: 'Marquer',
    actionUnstar: 'Démarquer',
    actionReport: 'Signaler',
    actionSelect: 'Sélectionner',
    actionShare: 'Partager',
    actionSave: 'Enregistrer',
    actionInfo: 'Infos',
    actionTranslate: 'Traduire',
    actionSpeak: 'Lire',
    statusSent: 'Envoyé',
    statusReceived: 'Reçu',
    statusEdited: 'modifié',
    statusPinned: 'épinglé',
    statusStarred: 'marqué',
    pollQuiz: 'Quiz',
    pollMultipleChoice: 'Sondage à choix multiples',
    pollDefault: 'Sondage',
    pollAnonymous: 'Anonyme',
    callVideo: 'Vidéo',
    callVoice: 'Voix',
    callIncoming: 'Entrant',
    callOutgoing: 'Sortant',
    callMissed: 'Manquée',
    callDeclined: 'Déclinée',
    callCancelled: 'Annulée',
    callNotAnswered: 'Non répondu',
    callDeclinedStatus: 'Appel décliné',
    callCancelledStatus: 'Appel annulé',
    callTapToCallBack: 'Appuyez pour rappeler',
    deletedMessage: 'Ce message a été supprimé',
    unreadSingular: 'message non lu',
    unreadPlural: 'messages non lus',
    locationTapToOpen: 'Appuyez pour ouvrir dans les cartes',
    viewerClose: 'Fermer',
    viewerDownload: 'Télécharger',
    viewerShare: 'Partager',
    viewerRetry: 'Réessayer',
    contextMenuCancel: 'Annuler',
    seeMore: 'Voir plus',
    seeLess: 'Voir moins',
    receiptTitle: 'Reçu',
    receiptOrderPrefix: 'Commande #',
    receiptSubtotal: 'Sous-total',
    receiptTax: 'Taxe',
    receiptTotal: 'Total',
  );

  /// German translations
  static const german = VTranslationConfig(
    actionReply: 'Antworten',
    actionForward: 'Weiterleiten',
    actionCopy: 'Kopieren',
    actionDownload: 'Herunterladen',
    actionEdit: 'Bearbeiten',
    actionDelete: 'Löschen',
    actionPin: 'Anheften',
    actionUnpin: 'Lösen',
    actionStar: 'Markieren',
    actionUnstar: 'Markierung aufheben',
    actionReport: 'Melden',
    actionSelect: 'Auswählen',
    actionShare: 'Teilen',
    actionSave: 'Speichern',
    actionInfo: 'Info',
    actionTranslate: 'Übersetzen',
    actionSpeak: 'Vorlesen',
    statusSent: 'Gesendet',
    statusReceived: 'Erhalten',
    statusEdited: 'bearbeitet',
    statusPinned: 'angeheftet',
    statusStarred: 'markiert',
    pollQuiz: 'Quiz',
    pollMultipleChoice: 'Mehrfachauswahlumfrage',
    pollDefault: 'Umfrage',
    pollAnonymous: 'Anonym',
    callVideo: 'Video',
    callVoice: 'Stimme',
    callIncoming: 'Eingehend',
    callOutgoing: 'Ausgehend',
    callMissed: 'Verpasst',
    callDeclined: 'Abgelehnt',
    callCancelled: 'Abgebrochen',
    callNotAnswered: 'Nicht beantwortet',
    callDeclinedStatus: 'Anruf abgelehnt',
    callCancelledStatus: 'Anruf abgebrochen',
    callTapToCallBack: 'Zum Zurückrufen tippen',
    deletedMessage: 'Diese Nachricht wurde gelöscht',
    unreadSingular: 'ungelesene Nachricht',
    unreadPlural: 'ungelesene Nachrichten',
    locationTapToOpen: 'Tippen Sie, um in Karten zu öffnen',
    viewerClose: 'Schließen',
    viewerDownload: 'Herunterladen',
    viewerShare: 'Teilen',
    viewerRetry: 'Erneut versuchen',
    contextMenuCancel: 'Abbrechen',
    seeMore: 'Mehr sehen',
    seeLess: 'Weniger sehen',
    receiptTitle: 'Quittung',
    receiptOrderPrefix: 'Bestellung #',
    receiptSubtotal: 'Summe',
    receiptTax: 'Steuern',
    receiptTotal: 'Gesamt',
  );

  /// Arabic translations
  static const arabic = VTranslationConfig(
    actionReply: 'رد',
    actionForward: 'إعادة توجيه',
    actionCopy: 'نسخ',
    actionDownload: 'تحميل',
    actionEdit: 'تحرير',
    actionDelete: 'حذف',
    actionPin: 'تثبيت',
    actionUnpin: 'إلغاء التثبيت',
    actionStar: 'تمييز',
    actionUnstar: 'إلغاء التمييز',
    actionReport: 'إبلاغ',
    actionSelect: 'تحديد',
    actionShare: 'مشاركة',
    actionSave: 'حفظ',
    actionInfo: 'معلومات',
    actionTranslate: 'ترجمة',
    actionSpeak: 'نطق',
    statusSent: 'تم الإرسال',
    statusReceived: 'تم الاستلام',
    statusEdited: 'تم تحريره',
    statusPinned: 'مثبت',
    statusStarred: 'معلم',
    pollQuiz: 'اختبار',
    pollMultipleChoice: 'استبيان الاختيار من متعدد',
    pollDefault: 'استبيان',
    pollAnonymous: 'مجهول',
    callVideo: 'فيديو',
    callVoice: 'صوت',
    callIncoming: 'وارد',
    callOutgoing: 'صادر',
    callMissed: 'مفقود',
    callDeclined: 'تم الرفض',
    callCancelled: 'تم الإلغاء',
    callNotAnswered: 'لم يتم الرد',
    callDeclinedStatus: 'تم رفض المكالمة',
    callCancelledStatus: 'تم إلغاء المكالمة',
    callTapToCallBack: 'اضغط للاتصال بالعودة',
    deletedMessage: 'تم حذف هذه الرسالة',
    unreadSingular: 'رسالة غير مقروءة',
    unreadPlural: 'رسائل غير مقروءة',
    locationTapToOpen: 'اضغط للفتح في الخرائط',
    viewerClose: 'إغلاق',
    viewerDownload: 'تحميل',
    viewerShare: 'مشاركة',
    viewerRetry: 'إعادة المحاولة',
    contextMenuCancel: 'إلغاء',
    seeMore: 'عرض المزيد',
    seeLess: 'عرض أقل',
    receiptTitle: 'إيصال',
    receiptOrderPrefix: 'الطلب #',
    receiptSubtotal: 'المجموع الفرعي',
    receiptTax: 'الضريبة',
    receiptTotal: 'الإجمالي',
  );

  /// Get translations for a specific locale
  ///
  /// Supports: en, ar, es, fr, de
  /// Falls back to English for unsupported locales
  static VTranslationConfig forLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return arabic;
      case 'es':
        return spanish;
      case 'fr':
        return french;
      case 'de':
        return german;
      case 'en':
      default:
        return english;
    }
  }

  /// Get translated label for a menu item id
  ///
  /// Returns the translated label if the id matches a known action,
  /// otherwise returns the fallback (typically the original label)
  String labelForMenuItemId(String id, {String? fallback}) {
    switch (id) {
      case 'reply':
        return actionReply;
      case 'forward':
        return actionForward;
      case 'copy':
        return actionCopy;
      case 'download':
        return actionDownload;
      case 'edit':
        return actionEdit;
      case 'delete':
        return actionDelete;
      case 'pin':
        return actionPin;
      case 'star':
        return actionStar;
      case 'report':
        return actionReport;
      case 'select':
        return actionSelect;
      case 'share':
        return actionShare;
      case 'save':
        return actionSave;
      case 'info':
        return actionInfo;
      case 'translate':
        return actionTranslate;
      case 'speak':
        return actionSpeak;
      case 'unpin':
        return actionUnpin;
      case 'unstar':
        return actionUnstar;
      default:
        return fallback ?? id;
    }
  }

  VTranslationConfig copyWith({
    String? actionReply,
    String? actionForward,
    String? actionCopy,
    String? actionDownload,
    String? actionEdit,
    String? actionDelete,
    String? actionPin,
    String? actionUnpin,
    String? actionStar,
    String? actionUnstar,
    String? actionReport,
    String? actionSelect,
    String? actionShare,
    String? actionSave,
    String? actionInfo,
    String? actionTranslate,
    String? actionSpeak,
    String? statusSent,
    String? statusReceived,
    String? statusEdited,
    String? statusPinned,
    String? statusStarred,
    String? pollQuiz,
    String? pollMultipleChoice,
    String? pollDefault,
    String? pollAnonymous,
    String? callVideo,
    String? callVoice,
    String? callIncoming,
    String? callOutgoing,
    String? callMissed,
    String? callDeclined,
    String? callCancelled,
    String? callNotAnswered,
    String? callDeclinedStatus,
    String? callCancelledStatus,
    String? callTapToCallBack,
    String? deletedMessage,
    String? unreadSingular,
    String? unreadPlural,
    String? locationTapToOpen,
    String? viewerClose,
    String? viewerDownload,
    String? viewerShare,
    String? viewerRetry,
    String? contextMenuCancel,
    String? receiptTitle,
    String? receiptOrderPrefix,
    String? receiptSubtotal,
    String? receiptTax,
    String? receiptTotal,
  }) =>
      VTranslationConfig(
        actionReply: actionReply ?? this.actionReply,
        actionForward: actionForward ?? this.actionForward,
        actionCopy: actionCopy ?? this.actionCopy,
        actionDownload: actionDownload ?? this.actionDownload,
        actionEdit: actionEdit ?? this.actionEdit,
        actionDelete: actionDelete ?? this.actionDelete,
        actionPin: actionPin ?? this.actionPin,
        actionUnpin: actionUnpin ?? this.actionUnpin,
        actionStar: actionStar ?? this.actionStar,
        actionUnstar: actionUnstar ?? this.actionUnstar,
        actionReport: actionReport ?? this.actionReport,
        actionSelect: actionSelect ?? this.actionSelect,
        actionShare: actionShare ?? this.actionShare,
        actionSave: actionSave ?? this.actionSave,
        actionInfo: actionInfo ?? this.actionInfo,
        actionTranslate: actionTranslate ?? this.actionTranslate,
        actionSpeak: actionSpeak ?? this.actionSpeak,
        statusSent: statusSent ?? this.statusSent,
        statusReceived: statusReceived ?? this.statusReceived,
        statusEdited: statusEdited ?? this.statusEdited,
        statusPinned: statusPinned ?? this.statusPinned,
        statusStarred: statusStarred ?? this.statusStarred,
        pollQuiz: pollQuiz ?? this.pollQuiz,
        pollMultipleChoice: pollMultipleChoice ?? this.pollMultipleChoice,
        pollDefault: pollDefault ?? this.pollDefault,
        pollAnonymous: pollAnonymous ?? this.pollAnonymous,
        callVideo: callVideo ?? this.callVideo,
        callVoice: callVoice ?? this.callVoice,
        callIncoming: callIncoming ?? this.callIncoming,
        callOutgoing: callOutgoing ?? this.callOutgoing,
        callMissed: callMissed ?? this.callMissed,
        callDeclined: callDeclined ?? this.callDeclined,
        callCancelled: callCancelled ?? this.callCancelled,
        callNotAnswered: callNotAnswered ?? this.callNotAnswered,
        callDeclinedStatus: callDeclinedStatus ?? this.callDeclinedStatus,
        callCancelledStatus: callCancelledStatus ?? this.callCancelledStatus,
        callTapToCallBack: callTapToCallBack ?? this.callTapToCallBack,
        deletedMessage: deletedMessage ?? this.deletedMessage,
        unreadSingular: unreadSingular ?? this.unreadSingular,
        unreadPlural: unreadPlural ?? this.unreadPlural,
        locationTapToOpen: locationTapToOpen ?? this.locationTapToOpen,
        viewerClose: viewerClose ?? this.viewerClose,
        viewerDownload: viewerDownload ?? this.viewerDownload,
        viewerShare: viewerShare ?? this.viewerShare,
        viewerRetry: viewerRetry ?? this.viewerRetry,
        contextMenuCancel: contextMenuCancel ?? this.contextMenuCancel,
        receiptTitle: receiptTitle ?? this.receiptTitle,
        receiptOrderPrefix: receiptOrderPrefix ?? this.receiptOrderPrefix,
        receiptSubtotal: receiptSubtotal ?? this.receiptSubtotal,
        receiptTax: receiptTax ?? this.receiptTax,
        receiptTotal: receiptTotal ?? this.receiptTotal,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VTranslationConfig &&
          runtimeType == other.runtimeType &&
          actionReply == other.actionReply &&
          actionForward == other.actionForward &&
          actionCopy == other.actionCopy &&
          actionDownload == other.actionDownload &&
          actionEdit == other.actionEdit &&
          actionDelete == other.actionDelete &&
          actionPin == other.actionPin &&
          actionUnpin == other.actionUnpin &&
          actionStar == other.actionStar &&
          actionUnstar == other.actionUnstar &&
          actionReport == other.actionReport &&
          actionSelect == other.actionSelect &&
          actionShare == other.actionShare &&
          actionSave == other.actionSave &&
          actionInfo == other.actionInfo &&
          actionTranslate == other.actionTranslate &&
          actionSpeak == other.actionSpeak &&
          statusSent == other.statusSent &&
          statusReceived == other.statusReceived &&
          statusEdited == other.statusEdited &&
          statusPinned == other.statusPinned &&
          statusStarred == other.statusStarred &&
          pollQuiz == other.pollQuiz &&
          pollMultipleChoice == other.pollMultipleChoice &&
          pollDefault == other.pollDefault &&
          pollAnonymous == other.pollAnonymous &&
          callVideo == other.callVideo &&
          callVoice == other.callVoice &&
          callIncoming == other.callIncoming &&
          callOutgoing == other.callOutgoing &&
          callMissed == other.callMissed &&
          callDeclined == other.callDeclined &&
          callCancelled == other.callCancelled &&
          callNotAnswered == other.callNotAnswered &&
          callDeclinedStatus == other.callDeclinedStatus &&
          callCancelledStatus == other.callCancelledStatus &&
          callTapToCallBack == other.callTapToCallBack &&
          deletedMessage == other.deletedMessage &&
          unreadSingular == other.unreadSingular &&
          unreadPlural == other.unreadPlural &&
          locationTapToOpen == other.locationTapToOpen &&
          viewerClose == other.viewerClose &&
          viewerDownload == other.viewerDownload &&
          viewerShare == other.viewerShare &&
          viewerRetry == other.viewerRetry &&
          contextMenuCancel == other.contextMenuCancel &&
          receiptTitle == other.receiptTitle &&
          receiptOrderPrefix == other.receiptOrderPrefix &&
          receiptSubtotal == other.receiptSubtotal &&
          receiptTax == other.receiptTax &&
          receiptTotal == other.receiptTotal;

  @override
  int get hashCode => Object.hashAll([
        actionReply,
        actionForward,
        actionCopy,
        actionDownload,
        actionEdit,
        actionDelete,
        actionPin,
        actionUnpin,
        actionStar,
        actionUnstar,
        actionReport,
        actionSelect,
        actionShare,
        actionSave,
        actionInfo,
        actionTranslate,
        actionSpeak,
        statusSent,
        statusReceived,
        statusEdited,
        statusPinned,
        statusStarred,
        pollQuiz,
        pollMultipleChoice,
        pollDefault,
        pollAnonymous,
        callVideo,
        callVoice,
        callIncoming,
        callOutgoing,
        callMissed,
        callDeclined,
        callCancelled,
        callNotAnswered,
        callDeclinedStatus,
        callCancelledStatus,
        callTapToCallBack,
        deletedMessage,
        unreadSingular,
        unreadPlural,
        locationTapToOpen,
        viewerClose,
        viewerDownload,
        viewerShare,
        viewerRetry,
        contextMenuCancel,
        receiptTitle,
        receiptOrderPrefix,
        receiptSubtotal,
        receiptTax,
        receiptTotal,
      ]);
}

/// Configuration for bubble behavior
@immutable
class VBubbleConfig {
  /// Pattern detection and formatting settings
  final VPatternConfig patterns;

  /// Gesture settings
  final VGestureConfig gestures;

  /// Avatar display settings
  final VAvatarConfig avatar;

  /// Bubble sizing constraints
  final VSizingConfig sizing;

  /// Bubble spacing and dimensions
  final VSpacingConfig spacing;

  /// Media display settings
  final VMediaConfig media;

  /// Text expansion settings
  final VTextExpansionConfig textExpansion;

  /// Animation settings
  final VAnimationConfig animation;

  /// Accessibility settings
  final VAccessibilityConfig accessibility;

  /// Context menu settings for long press behavior
  final VContextMenuConfig contextMenu;

  /// Localization/translation strings for all user-facing text
  final VTranslationConfig translations;

  /// Time threshold for grouping consecutive messages from same sender
  final Duration groupingTimeThreshold;
  const VBubbleConfig({
    this.patterns = const VPatternConfig(),
    this.gestures = const VGestureConfig(),
    this.avatar = const VAvatarConfig(),
    this.sizing = const VSizingConfig(),
    this.spacing = const VSpacingConfig(),
    this.media = const VMediaConfig(),
    this.textExpansion = const VTextExpansionConfig(),
    this.animation = const VAnimationConfig(),
    this.accessibility = const VAccessibilityConfig(),
    this.contextMenu = const VContextMenuConfig(),
    this.translations = const VTranslationConfig(),
    this.groupingTimeThreshold = const Duration(minutes: 1),
  });

  /// Calculate effective max width based on screen width
  double getEffectiveMaxWidth(double screenWidth) =>
      sizing.getEffectiveMaxWidth(screenWidth);

  /// Preset for compact chat (dense layout, smaller elements)
  factory VBubbleConfig.compact() => const VBubbleConfig(
        sizing: VSizingConfig.compact,
        spacing: VSpacingConfig.compact,
        media: VMediaConfig.compact,
        avatar: VAvatarConfig.small,
        textExpansion: VTextExpansionConfig.short,
        animation: VAnimationConfig.fast,
      );

  /// Preset for desktop/tablet (wider bubbles, more space)
  factory VBubbleConfig.desktop() => const VBubbleConfig(
        sizing: VSizingConfig.wide,
        spacing: VSpacingConfig.loose,
        media: VMediaConfig.large,
        avatar: VAvatarConfig.large,
      );

  /// Preset for read-only mode (no gestures)
  factory VBubbleConfig.readOnly() =>
      const VBubbleConfig(gestures: VGestureConfig.none);

  /// Preset for 1:1 chat (no avatars)
  factory VBubbleConfig.directChat() =>
      const VBubbleConfig(avatar: VAvatarConfig.hidden);

  /// Preset for minimal iMessage-like style (no tails, clean look)
  factory VBubbleConfig.minimal() => const VBubbleConfig(
        spacing: VSpacingConfig.minimal,
        avatar: VAvatarConfig.hidden,
        textExpansion: VTextExpansionConfig.disabled,
      );

  /// Preset for group chat (always show avatars and names)
  factory VBubbleConfig.groupChat() => const VBubbleConfig(
        avatar: VAvatarConfig.visible,
        spacing: VSpacingConfig.loose,
      );

  /// Preset with enhanced accessibility
  factory VBubbleConfig.accessible() => const VBubbleConfig(
        accessibility: VAccessibilityConfig.enhanced,
        animation: VAnimationConfig.slow,
        spacing: VSpacingConfig.loose,
      );

  /// Preset for performance (no animations, minimal processing)
  factory VBubbleConfig.performance() => const VBubbleConfig(
        animation: VAnimationConfig.none,
        patterns: VPatternConfig.none,
        textExpansion: VTextExpansionConfig.disabled,
      );
  VBubbleConfig copyWith({
    VPatternConfig? patterns,
    VGestureConfig? gestures,
    VAvatarConfig? avatar,
    VSizingConfig? sizing,
    VSpacingConfig? spacing,
    VMediaConfig? media,
    VTextExpansionConfig? textExpansion,
    VAnimationConfig? animation,
    VAccessibilityConfig? accessibility,
    VContextMenuConfig? contextMenu,
    VTranslationConfig? translations,
    Duration? groupingTimeThreshold,
  }) =>
      VBubbleConfig(
        patterns: patterns ?? this.patterns,
        gestures: gestures ?? this.gestures,
        avatar: avatar ?? this.avatar,
        sizing: sizing ?? this.sizing,
        spacing: spacing ?? this.spacing,
        media: media ?? this.media,
        textExpansion: textExpansion ?? this.textExpansion,
        animation: animation ?? this.animation,
        accessibility: accessibility ?? this.accessibility,
        contextMenu: contextMenu ?? this.contextMenu,
        translations: translations ?? this.translations,
        groupingTimeThreshold:
            groupingTimeThreshold ?? this.groupingTimeThreshold,
      );

  /// Overrides this config with values from another config.
  /// Note: This performs a shallow override - entire nested configs are replaced.
  VBubbleConfig overrideWith(VBubbleConfig? other) {
    if (other == null) return this;
    return copyWith(
      patterns: other.patterns,
      gestures: other.gestures,
      avatar: other.avatar,
      sizing: other.sizing,
      spacing: other.spacing,
      media: other.media,
      textExpansion: other.textExpansion,
      animation: other.animation,
      accessibility: other.accessibility,
      contextMenu: other.contextMenu,
      translations: other.translations,
      groupingTimeThreshold: other.groupingTimeThreshold,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBubbleConfig &&
        runtimeType == other.runtimeType &&
        patterns == other.patterns &&
        gestures == other.gestures &&
        avatar == other.avatar &&
        sizing == other.sizing &&
        spacing == other.spacing &&
        media == other.media &&
        textExpansion == other.textExpansion &&
        animation == other.animation &&
        accessibility == other.accessibility &&
        contextMenu == other.contextMenu &&
        translations == other.translations &&
        groupingTimeThreshold == other.groupingTimeThreshold;
  }

  @override
  int get hashCode => Object.hash(
        patterns,
        gestures,
        avatar,
        sizing,
        spacing,
        media,
        textExpansion,
        animation,
        accessibility,
        contextMenu,
        translations,
        groupingTimeThreshold,
      );
}
