import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import 'enums.dart';

const _sentinel = Object();

/// Reaction model
@immutable
class VBubbleReaction {
  final String emoji;
  final int count;
  final bool isSelected;
  const VBubbleReaction({
    required this.emoji,
    this.count = 1,
    this.isSelected = false,
  });
  VBubbleReaction copyWith({String? emoji, int? count, bool? isSelected}) =>
      VBubbleReaction(
        emoji: emoji ?? this.emoji,
        count: count ?? this.count,
        isSelected: isSelected ?? this.isSelected,
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBubbleReaction &&
        other.emoji == emoji &&
        other.count == count &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode => Object.hash(emoji, count, isSelected);
}

/// Menu item for long press menu
@immutable
class VBubbleMenuItem {
  final String id;
  final String label;
  final IconData icon;
  final bool isDestructive;
  const VBubbleMenuItem({
    required this.id,
    required this.label,
    required this.icon,
    this.isDestructive = false,
  });
  VBubbleMenuItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    bool? isDestructive,
  }) {
    return VBubbleMenuItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      isDestructive: isDestructive ?? this.isDestructive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VBubbleMenuItem &&
        other.id == id &&
        other.label == label &&
        other.icon == icon &&
        other.isDestructive == isDestructive;
  }

  @override
  int get hashCode => Object.hash(id, label, icon, isDestructive);
}

/// Builder function for dynamic menu items per message
///
/// Parameters:
/// - [messageId]: The unique identifier of the message
/// - [messageType]: The type of message (text, image, video, etc.)
/// - [isMeSender]: Whether the message was sent by the current user
///
/// Return null to use default menu items, or return a list to override
typedef VMenuItemsBuilder = List<VBubbleMenuItem>? Function(
  String messageId,
  String messageType,
  bool isMeSender,
);

/// Default menu items for context menu
class VDefaultMenuItems {
  VDefaultMenuItems._();

  static const reply = VBubbleMenuItem(
    id: 'reply',
    label: 'Reply',
    icon: Icons.reply,
  );

  static const forward = VBubbleMenuItem(
    id: 'forward',
    label: 'Forward',
    icon: Icons.forward,
  );

  static const copy = VBubbleMenuItem(
    id: 'copy',
    label: 'Copy',
    icon: Icons.copy,
  );

  static const delete = VBubbleMenuItem(
    id: 'delete',
    label: 'Delete',
    icon: Icons.delete,
    isDestructive: true,
  );

  static const download = VBubbleMenuItem(
    id: 'download',
    label: 'Download',
    icon: Icons.download,
  );

  static const pin = VBubbleMenuItem(
    id: 'pin',
    label: 'Pin',
    icon: Icons.push_pin,
  );

  static const star = VBubbleMenuItem(
    id: 'star',
    label: 'Star',
    icon: Icons.star_border,
  );

  static const select = VBubbleMenuItem(
    id: 'select',
    label: 'Select',
    icon: Icons.check_circle_outline,
  );

  static const edit = VBubbleMenuItem(
    id: 'edit',
    label: 'Edit',
    icon: Icons.edit_outlined,
  );

  static const report = VBubbleMenuItem(
    id: 'report',
    label: 'Report',
    icon: Icons.flag_outlined,
    isDestructive: true,
  );

  /// Default items for text messages
  static const List<VBubbleMenuItem> textDefaults = [
    reply,
    forward,
    copy,
    edit,
    pin,
    delete,
    select,
  ];

  /// Default items for media messages (image, video, voice, file)
  static const List<VBubbleMenuItem> mediaDefaults = [
    reply,
    forward,
    download,
    pin,
    delete,
  ];

  /// Get default items based on message type
  static List<VBubbleMenuItem> forMessageType(String messageType) {
    switch (messageType) {
      case 'image':
      case 'video':
      case 'voice':
      case 'file':
      case 'gallery':
        return mediaDefaults;
      default:
        return textDefaults;
    }
  }
}

/// Reply preview data
@immutable
class VReplyData {
  final String senderId;
  final String senderName;
  final Color? senderColor;
  final String previewText;
  final VPlatformFile? previewImage;
  final VMessageType originalType;
  const VReplyData({
    required this.senderId,
    required this.senderName,
    this.senderColor,
    required this.previewText,
    this.previewImage,
    this.originalType = VMessageType.text,
  });
  VReplyData copyWith({
    String? senderId,
    String? senderName,
    Object? senderColor = _sentinel,
    String? previewText,
    Object? previewImage = _sentinel,
    VMessageType? originalType,
  }) {
    return VReplyData(
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderColor:
          senderColor == _sentinel ? this.senderColor : senderColor as Color?,
      previewText: previewText ?? this.previewText,
      previewImage: previewImage == _sentinel
          ? this.previewImage
          : previewImage as VPlatformFile?,
      originalType: originalType ?? this.originalType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VReplyData &&
        other.senderId == senderId &&
        other.senderName == senderName &&
        other.senderColor == senderColor &&
        other.previewText == previewText &&
        other.previewImage == previewImage &&
        other.originalType == originalType;
  }

  @override
  int get hashCode => Object.hash(
        senderId,
        senderName,
        senderColor,
        previewText,
        previewImage,
        originalType,
      );
}

/// Quoted content data for sharing external content (stories, products, posts)
@immutable
class QuotedContentData {
  final String? title;
  final String? subtitle;
  final VPlatformFile? image;
  final String? contentId;
  final Map<String, dynamic>? extraData;
  const QuotedContentData({
    this.title,
    this.subtitle,
    this.image,
    this.contentId,
    this.extraData,
  }) : assert(
          title != null || subtitle != null,
          'At least one of title or subtitle must be provided',
        );
  QuotedContentData copyWith({
    Object? title = _sentinel,
    Object? subtitle = _sentinel,
    Object? image = _sentinel,
    Object? contentId = _sentinel,
    Object? extraData = _sentinel,
  }) {
    return QuotedContentData(
      title: title == _sentinel ? this.title : title as String?,
      subtitle: subtitle == _sentinel ? this.subtitle : subtitle as String?,
      image: image == _sentinel ? this.image : image as VPlatformFile?,
      contentId: contentId == _sentinel ? this.contentId : contentId as String?,
      extraData: extraData == _sentinel
          ? this.extraData
          : extraData as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuotedContentData &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.image == image &&
        other.contentId == contentId &&
        other.extraData == extraData;
  }

  @override
  int get hashCode => Object.hash(title, subtitle, image, contentId, extraData);
}

/// Forward info
@immutable
class VForwardData {
  final String originalMessageId;
  final String originalSenderName;
  final DateTime? originalTime;
  const VForwardData({
    required this.originalMessageId,
    required this.originalSenderName,
    this.originalTime,
  });
  VForwardData copyWith({
    String? originalMessageId,
    String? originalSenderName,
    Object? originalTime = _sentinel,
  }) {
    return VForwardData(
      originalMessageId: originalMessageId ?? this.originalMessageId,
      originalSenderName: originalSenderName ?? this.originalSenderName,
      originalTime: originalTime == _sentinel
          ? this.originalTime
          : originalTime as DateTime?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VForwardData &&
        other.originalMessageId == originalMessageId &&
        other.originalSenderName == originalSenderName &&
        other.originalTime == originalTime;
  }

  @override
  int get hashCode =>
      Object.hash(originalMessageId, originalSenderName, originalTime);
}

/// Link preview data
@immutable
class VLinkPreviewData {
  final String url;
  final String? siteName;
  final String? title;
  final String? description;
  final VPlatformFile? image;
  const VLinkPreviewData({
    required this.url,
    this.siteName,
    this.title,
    this.description,
    this.image,
  });
  VLinkPreviewData copyWith({
    String? url,
    Object? siteName = _sentinel,
    Object? title = _sentinel,
    Object? description = _sentinel,
    Object? image = _sentinel,
  }) {
    return VLinkPreviewData(
      url: url ?? this.url,
      siteName: siteName == _sentinel ? this.siteName : siteName as String?,
      title: title == _sentinel ? this.title : title as String?,
      description:
          description == _sentinel ? this.description : description as String?,
      image: image == _sentinel ? this.image : image as VPlatformFile?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VLinkPreviewData &&
        other.url == url &&
        other.siteName == siteName &&
        other.title == title &&
        other.description == description &&
        other.image == image;
  }

  @override
  int get hashCode => Object.hash(url, siteName, title, description, image);
}

/// Contact data
@immutable
class VContactData {
  final String name;
  final String? phoneNumber;
  final VPlatformFile? avatar;
  const VContactData({required this.name, this.phoneNumber, this.avatar});
  VContactData copyWith({
    String? name,
    Object? phoneNumber = _sentinel,
    Object? avatar = _sentinel,
  }) {
    return VContactData(
      name: name ?? this.name,
      phoneNumber:
          phoneNumber == _sentinel ? this.phoneNumber : phoneNumber as String?,
      avatar: avatar == _sentinel ? this.avatar : avatar as VPlatformFile?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VContactData &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.avatar == avatar;
  }

  @override
  int get hashCode => Object.hash(name, phoneNumber, avatar);
}

/// Location data
@immutable
class VLocationData {
  final double latitude;
  final double longitude;
  final String? address;
  final String? staticMapUrl;
  const VLocationData({
    required this.latitude,
    required this.longitude,
    this.address,
    this.staticMapUrl,
  });
  VLocationData copyWith({
    double? latitude,
    double? longitude,
    Object? address = _sentinel,
    Object? staticMapUrl = _sentinel,
  }) {
    return VLocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address == _sentinel ? this.address : address as String?,
      staticMapUrl: staticMapUrl == _sentinel
          ? this.staticMapUrl
          : staticMapUrl as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VLocationData &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.address == address &&
        other.staticMapUrl == staticMapUrl;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude, address, staticMapUrl);
}

/// Poll option
@immutable
class VPollOption {
  final String id;
  final String text;
  final int voteCount;
  final double percentage;
  final bool isSelected;
  final bool isCorrect; // For quiz mode
  const VPollOption({
    required this.id,
    required this.text,
    this.voteCount = 0,
    this.percentage = 0.0,
    this.isSelected = false,
    this.isCorrect = false,
  });
  VPollOption copyWith({
    String? id,
    String? text,
    int? voteCount,
    double? percentage,
    bool? isSelected,
    bool? isCorrect,
  }) {
    return VPollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      voteCount: voteCount ?? this.voteCount,
      percentage: percentage ?? this.percentage,
      isSelected: isSelected ?? this.isSelected,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VPollOption &&
        other.id == id &&
        other.text == text &&
        other.voteCount == voteCount &&
        other.percentage == percentage &&
        other.isSelected == isSelected &&
        other.isCorrect == isCorrect;
  }

  @override
  int get hashCode =>
      Object.hash(id, text, voteCount, percentage, isSelected, isCorrect);
}

/// Poll data
@immutable
class VPollData {
  final String question;
  final List<VPollOption> options;
  final VPollMode mode;
  final int totalVotes;
  final bool isClosed;
  final bool isAnonymous;
  final bool hasVoted;
  const VPollData({
    required this.question,
    required this.options,
    this.mode = VPollMode.single,
    this.totalVotes = 0,
    this.isClosed = false,
    this.isAnonymous = true,
    this.hasVoted = false,
  });
  VPollData copyWith({
    String? question,
    List<VPollOption>? options,
    VPollMode? mode,
    int? totalVotes,
    bool? isClosed,
    bool? isAnonymous,
    bool? hasVoted,
  }) {
    return VPollData(
      question: question ?? this.question,
      options: options ?? this.options,
      mode: mode ?? this.mode,
      totalVotes: totalVotes ?? this.totalVotes,
      isClosed: isClosed ?? this.isClosed,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      hasVoted: hasVoted ?? this.hasVoted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VPollData &&
        other.question == question &&
        _listEquals(other.options, options) &&
        other.mode == mode &&
        other.totalVotes == totalVotes &&
        other.isClosed == isClosed &&
        other.isAnonymous == isAnonymous &&
        other.hasVoted == hasVoted;
  }

  @override
  int get hashCode => Object.hash(
        question,
        Object.hashAll(options),
        mode,
        totalVotes,
        isClosed,
        isAnonymous,
        hasVoted,
      );
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Call data
@immutable
class VCallData {
  final VCallType type;
  final VCallStatus status;
  final Duration? duration;
  const VCallData({required this.type, required this.status, this.duration});
  VCallData copyWith({
    VCallType? type,
    VCallStatus? status,
    Duration? duration,
  }) {
    return VCallData(
      type: type ?? this.type,
      status: status ?? this.status,
      duration: duration ?? this.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VCallData &&
        other.type == type &&
        other.status == status &&
        other.duration == duration;
  }

  @override
  int get hashCode => Object.hash(type, status, duration);
}

/// Gallery item data - represents a single image in a gallery
/// Each image is a separate message with its own unique identity
@immutable
class VGalleryItemData {
  final String messageId;
  final VPlatformFile file;
  final int? width;
  final int? height;
  final int? fileSize;
  final String time;
  final VMessageStatus status;
  final bool isEdited;
  final String? caption;
  const VGalleryItemData({
    required this.messageId,
    required this.file,
    this.width,
    this.height,
    this.fileSize,
    required this.time,
    this.status = VMessageStatus.sent,
    this.isEdited = false,
    this.caption,
  });
  VGalleryItemData copyWith({
    String? messageId,
    VPlatformFile? file,
    Object? width = _sentinel,
    Object? height = _sentinel,
    Object? fileSize = _sentinel,
    String? time,
    VMessageStatus? status,
    bool? isEdited,
    Object? caption = _sentinel,
  }) =>
      VGalleryItemData(
        messageId: messageId ?? this.messageId,
        file: file ?? this.file,
        width: width == _sentinel ? this.width : width as int?,
        height: height == _sentinel ? this.height : height as int?,
        fileSize: fileSize == _sentinel ? this.fileSize : fileSize as int?,
        time: time ?? this.time,
        status: status ?? this.status,
        isEdited: isEdited ?? this.isEdited,
        caption: caption == _sentinel ? this.caption : caption as String?,
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VGalleryItemData &&
        other.messageId == messageId &&
        other.file == file &&
        other.width == width &&
        other.height == height &&
        other.fileSize == fileSize &&
        other.time == time &&
        other.status == status &&
        other.isEdited == isEdited &&
        other.caption == caption;
  }

  @override
  int get hashCode => Object.hash(
        messageId,
        file,
        width,
        height,
        fileSize,
        time,
        status,
        isEdited,
        caption,
      );
}

/// Data for media tap callback (unified for images, videos, galleries)
@immutable
class VMediaTapData {
  final String messageId;
  final int? index;
  final VGalleryItemData? galleryItem;
  const VMediaTapData({required this.messageId, this.index, this.galleryItem});
  VMediaTapData copyWith({
    String? messageId,
    Object? index = _sentinel,
    Object? galleryItem = _sentinel,
  }) =>
      VMediaTapData(
        messageId: messageId ?? this.messageId,
        index: index == _sentinel ? this.index : index as int?,
        galleryItem: galleryItem == _sentinel
            ? this.galleryItem
            : galleryItem as VGalleryItemData?,
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VMediaTapData &&
        other.messageId == messageId &&
        other.index == index &&
        other.galleryItem == galleryItem;
  }

  @override
  int get hashCode => Object.hash(messageId, index, galleryItem);
}

/// Custom pattern for text detection and styling
@immutable
class VCustomPattern {
  /// Unique identifier for this pattern (e.g., 'url', 'bold', 'ticket')
  final String id;

  /// RegExp pattern to match
  final RegExp pattern;

  /// TextStyle to apply to matched text
  final TextStyle style;

  /// Whether to remove markers from display (e.g., *bold* -> bold)
  final bool removeMarkers;

  /// Number of characters to strip from start/end when removeMarkers=true
  final int markerLength;

  /// Whether this pattern is tappable (triggers callback)
  final bool isTappable;

  /// Optional value transformer (e.g., strip @ from mentions)
  final String Function(String matchedText)? valueTransformer;
  const VCustomPattern({
    required this.id,
    required this.pattern,
    required this.style,
    this.removeMarkers = false,
    this.markerLength = 1,
    this.isTappable = true,
    this.valueTransformer,
  });
  VCustomPattern copyWith({
    String? id,
    RegExp? pattern,
    TextStyle? style,
    bool? removeMarkers,
    int? markerLength,
    bool? isTappable,
    String Function(String)? valueTransformer,
  }) =>
      VCustomPattern(
        id: id ?? this.id,
        pattern: pattern ?? this.pattern,
        style: style ?? this.style,
        removeMarkers: removeMarkers ?? this.removeMarkers,
        markerLength: markerLength ?? this.markerLength,
        isTappable: isTappable ?? this.isTappable,
        valueTransformer: valueTransformer ?? this.valueTransformer,
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VCustomPattern &&
        other.id == id &&
        other.pattern.pattern == pattern.pattern &&
        other.style == style &&
        other.removeMarkers == removeMarkers &&
        other.markerLength == markerLength &&
        other.isTappable == isTappable;
  }

  @override
  int get hashCode => Object.hash(
        id,
        pattern.pattern,
        style,
        removeMarkers,
        markerLength,
        isTappable,
      );
}

/// Data for full-screen media viewer
@immutable
class VMediaViewerData {
  final String messageId;
  final VPlatformFile file;
  final bool isVideo;
  final String? caption;
  final String? senderName;
  final String time;
  final int? index;
  final List<VGalleryItemData>? items;
  const VMediaViewerData({
    required this.messageId,
    required this.file,
    this.isVideo = false,
    this.caption,
    this.senderName,
    required this.time,
    this.index,
    this.items,
  });
  VMediaViewerData copyWith({
    String? messageId,
    VPlatformFile? file,
    bool? isVideo,
    Object? caption = _sentinel,
    Object? senderName = _sentinel,
    String? time,
    Object? index = _sentinel,
    Object? items = _sentinel,
  }) =>
      VMediaViewerData(
        messageId: messageId ?? this.messageId,
        file: file ?? this.file,
        isVideo: isVideo ?? this.isVideo,
        caption: caption == _sentinel ? this.caption : caption as String?,
        senderName:
            senderName == _sentinel ? this.senderName : senderName as String?,
        time: time ?? this.time,
        index: index == _sentinel ? this.index : index as int?,
        items:
            items == _sentinel ? this.items : items as List<VGalleryItemData>?,
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VMediaViewerData &&
        other.messageId == messageId &&
        other.file == file &&
        other.isVideo == isVideo &&
        other.caption == caption &&
        other.senderName == senderName &&
        other.time == time &&
        other.index == index &&
        _listEquals(other.items, items);
  }

  @override
  int get hashCode => Object.hash(
        messageId,
        file,
        isVideo,
        caption,
        senderName,
        time,
        index,
        items != null ? Object.hashAll(items!) : null,
      );
}

/// Data passed to pattern tap callback
@immutable
class VPatternMatch {
  /// The pattern ID that matched
  final String patternId;

  /// The matched text (after transformation if valueTransformer applied)
  final String matchedText;

  /// The raw matched text (before any transformation)
  final String rawText;

  /// The message ID containing this match
  final String? messageId;
  const VPatternMatch({
    required this.patternId,
    required this.matchedText,
    required this.rawText,
    this.messageId,
  });
  VPatternMatch copyWith({
    String? patternId,
    String? matchedText,
    String? rawText,
    Object? messageId = _sentinel,
  }) =>
      VPatternMatch(
        patternId: patternId ?? this.patternId,
        matchedText: matchedText ?? this.matchedText,
        rawText: rawText ?? this.rawText,
        messageId:
            messageId == _sentinel ? this.messageId : messageId as String?,
      );
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VPatternMatch &&
        other.patternId == patternId &&
        other.matchedText == matchedText &&
        other.rawText == rawText &&
        other.messageId == messageId;
  }

  @override
  int get hashCode => Object.hash(patternId, matchedText, rawText, messageId);
}
