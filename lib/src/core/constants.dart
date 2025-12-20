import 'package:flutter/material.dart';

/// Spacing constants used throughout bubble widgets.
abstract final class BubbleSpacing {
  // EdgeInsets
  static const chipPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  static const chipMargin = EdgeInsets.symmetric(vertical: 8);
  static const overlayInfoPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const iconButtonPadding = EdgeInsets.all(8);
  static const mediaOverlayPadding = EdgeInsets.all(16);
  static const smallPadding = EdgeInsets.all(4);
  static const standardPadding = EdgeInsets.all(8);
  static const largePadding = EdgeInsets.all(16);
  static const listItemPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const captionPadding = EdgeInsets.only(bottom: 4);
  static const reactionPillPadding =
      EdgeInsets.symmetric(horizontal: 6, vertical: 2);
  // Raw spacing values
  static const double inlineXS = 2;
  static const double inlineS = 4;
  static const double inlineM = 6;
  static const double inlineL = 8;
  static const double inlineXL = 12;
  static const double inlineXXL = 16;
  // Horizontal SizedBox shortcuts
  static const timeStatusSpacing = SizedBox(width: 4);
  static const gapXS = SizedBox(width: 2);
  static const gapS = SizedBox(width: 4);
  static const gapM = SizedBox(width: 6);
  static const gapL = SizedBox(width: 8);
  static const gapXL = SizedBox(width: 12);
  static const gapXXL = SizedBox(width: 16);
  // Named horizontal shortcuts
  static const horizontalTiny = SizedBox(width: 4);
  static const horizontalSmall = SizedBox(width: 8);
  static const horizontalMedium = SizedBox(width: 12);
  // Vertical SizedBox shortcuts
  static const vGapXS = SizedBox(height: 2);
  static const vGapS = SizedBox(height: 4);
  static const vGapM = SizedBox(height: 6);
  static const vGapL = SizedBox(height: 8);
  static const vGapXL = SizedBox(height: 12);
  // Named vertical shortcuts
  static const verticalTiny = SizedBox(height: 4);
  static const verticalSmall = SizedBox(height: 8);
  static const verticalMedium = SizedBox(height: 12);
  static const verticalLarge = SizedBox(height: 16);
}

/// Border radius constants used throughout bubble widgets.
abstract final class BubbleRadius {
  static const extraSmall = BorderRadius.all(Radius.circular(2));
  static const chip = BorderRadius.all(Radius.circular(16));
  static const standard = BorderRadius.all(Radius.circular(12));
  static const small = BorderRadius.all(Radius.circular(8));
  static const tiny = BorderRadius.all(Radius.circular(4));
  static const circle = BorderRadius.all(Radius.circular(100));
  static BorderRadius circular(double radius) =>
      BorderRadius.all(Radius.circular(radius));
}

/// Common gradient definitions.
abstract final class BubbleGradients {
  static const mediaOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0x80000000)],
  );
}

/// Common sizes.
abstract final class BubbleSizes {
  // Avatar sizes
  static const double avatarSize = 40;
  static const double smallAvatarSize = 32;
  static const double largeAvatarSize = 48;
  // Legacy icon sizes (kept for backward compatibility)
  static const double statusIconSize = 14;
  static const double playButtonSize = 64;
  static const double smallIconSize = 16;
  static const double standardIconSize = 24;
  // Unified icon scale
  static const double iconTiny = 12; // metadata (star, pin, forward)
  static const double iconSmall = 14; // status, inline
  static const double iconMedium = 16; // small actions
  static const double iconStandard = 18; // poll, close buttons
  static const double iconDefault = 20; // action buttons
  static const double iconLarge = 24; // file icons
  static const double iconXL = 32; // location overlay
  static const double iconXXL = 40; // play buttons
  static const double iconHuge = 48; // placeholders
  // Additional icon sizes
  static const double tinyIconSize = 12;
  static const double smallMediumIconSize = 18;
  static const double mediumIconSize = 40;
  static const double largeIconSize = 48;
  static const double iconContainerSize = 48;
  // Image sizes
  static const double replyPreviewImageSize = 36;
  // Media heights
  static const double mediaHeightSmall = 100;
  static const double mediaHeightMedium = 150;
  static const double mediaHeightLarge = 200;
  // Container sizes
  static const double selectionCircle = 24;
  static const double progressRing = 40;
  static const double callIconContainer = 44;
  static const double fileIconContainer = 48;
  static const double transferButton = 56;
}

/// Opacity constants used throughout bubble widgets.
abstract final class BubbleOpacity {
  static const double light = 0.1;
  static const double light2 = 0.2;
  static const double medium = 0.3;
  static const double half = 0.5;
  static const double dark = 0.6;
  static const double heavy = 0.7;
}
