import 'package:flutter/material.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

enum DemoMessageType {
  text,
  image,
  video,
  voice,
  file,
  gallery,
  poll,
  location,
  contact,
  call,
  linkPreview,
  quotedContent,
  system,
  deleted,
  dateChip,
  product,
}

class DemoMessage {
  final String id;
  final DemoMessageType type;
  final bool isOutgoing;
  final String time;
  final VMessageStatus status;
  // Sender info (for incoming messages)
  final String? senderName;
  final VPlatformFile? avatar;
  final Color? senderColor;
  // Message features
  final VReplyData? replyTo;
  final VForwardData? forwardedFrom;
  final List<VBubbleReaction> reactions;
  final bool isEdited;
  final bool isPinned;
  final bool isStarred;
  // Type-specific data
  final String? text;
  final String? imageUrl;
  final String? caption;
  final List<String>? galleryUrls;
  final String? videoThumbnailUrl;
  final Duration? videoDuration;
  final int? videoFileSize;
  final String? voiceUrl;
  final Duration? voiceDuration;
  final List<double>? waveform;
  final VPlatformFile? file;
  final VTransferState transferState;
  final double? transferProgress;
  final String? videoUrl;
  final VPollData? pollData;
  final VLocationData? locationData;
  final VContactData? contactData;
  final VCallData? callData;
  final VLinkPreviewData? linkPreviewData;
  final QuotedContentData? quotedContentData;
  final DateTime? dateChipDate;
  final VProductData? productData;
  const DemoMessage({
    required this.id,
    required this.type,
    this.isOutgoing = true,
    required this.time,
    this.status = VMessageStatus.sent,
    this.senderName,
    this.avatar,
    this.senderColor,
    this.replyTo,
    this.forwardedFrom,
    this.reactions = const [],
    this.isEdited = false,
    this.isPinned = false,
    this.isStarred = false,
    this.text,
    this.imageUrl,
    this.caption,
    this.galleryUrls,
    this.videoThumbnailUrl,
    this.videoDuration,
    this.videoFileSize,
    this.voiceUrl,
    this.voiceDuration,
    this.waveform,
    this.file,
    this.transferState = VTransferState.completed,
    this.transferProgress,
    this.videoUrl,
    this.pollData,
    this.locationData,
    this.contactData,
    this.callData,
    this.linkPreviewData,
    this.quotedContentData,
    this.dateChipDate,
    this.productData,
  });
  // Factory constructors for convenience
  factory DemoMessage.text({
    required String id,
    required String text,
    required String time,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
    VReplyData? replyTo,
    VForwardData? forwardedFrom,
    List<VBubbleReaction> reactions = const [],
    bool isEdited = false,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.text,
      text: text,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
      replyTo: replyTo,
      forwardedFrom: forwardedFrom,
      reactions: reactions,
      isEdited: isEdited,
    );
  }
  factory DemoMessage.image({
    required String id,
    required String imageUrl,
    required String time,
    String? caption,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
    List<VBubbleReaction> reactions = const [],
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.image,
      imageUrl: imageUrl,
      caption: caption,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
      reactions: reactions,
    );
  }
  factory DemoMessage.gallery({
    required String id,
    required List<String> galleryUrls,
    required String time,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.gallery,
      galleryUrls: galleryUrls,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
    );
  }
  factory DemoMessage.video({
    required String id,
    required String videoUrl,
    String? thumbnailUrl,
    required Duration duration,
    required String time,
    String? caption,
    int? fileSize,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.video,
      videoUrl: videoUrl,
      videoThumbnailUrl: thumbnailUrl,
      videoDuration: duration,
      videoFileSize: fileSize,
      caption: caption,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
    );
  }
  factory DemoMessage.voice({
    required String id,
    required String voiceUrl,
    required Duration duration,
    required String time,
    List<double>? waveform,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.voice,
      voiceUrl: voiceUrl,
      voiceDuration: duration,
      waveform: waveform,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
    );
  }
  factory DemoMessage.file({
    required String id,
    required VPlatformFile file,
    required String time,
    VTransferState transferState = VTransferState.completed,
    double? transferProgress,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.file,
      file: file,
      transferState: transferState,
      transferProgress: transferProgress,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
    );
  }
  factory DemoMessage.poll({
    required String id,
    required VPollData pollData,
    required String time,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.poll,
      pollData: pollData,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
    );
  }
  factory DemoMessage.location({
    required String id,
    required VLocationData locationData,
    required String time,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.location,
      locationData: locationData,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
    );
  }
  factory DemoMessage.contact({
    required String id,
    required VContactData contactData,
    required String time,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.contact,
      contactData: contactData,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
    );
  }
  factory DemoMessage.call({
    required String id,
    required VCallData callData,
    required String time,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.call,
      callData: callData,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
    );
  }
  factory DemoMessage.linkPreview({
    required String id,
    required String text,
    required VLinkPreviewData linkPreviewData,
    required String time,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.linkPreview,
      text: text,
      linkPreviewData: linkPreviewData,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
    );
  }
  factory DemoMessage.quotedContent({
    required String id,
    required QuotedContentData quotedContentData,
    required String time,
    String? text,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.quotedContent,
      quotedContentData: quotedContentData,
      text: text,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
    );
  }
  factory DemoMessage.system({required String id, required String text}) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.system,
      text: text,
      time: '',
    );
  }
  factory DemoMessage.deleted({
    required String id,
    required String time,
    bool isOutgoing = true,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.deleted,
      time: time,
      isOutgoing: isOutgoing,
    );
  }
  factory DemoMessage.dateChip({required String id, required DateTime date}) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.dateChip,
      dateChipDate: date,
      time: '',
    );
  }
  factory DemoMessage.product({
    required String id,
    required VProductData productData,
    required String time,
    bool isOutgoing = true,
    VMessageStatus status = VMessageStatus.sent,
    String? senderName,
    VPlatformFile? avatar,
    Color? senderColor,
  }) {
    return DemoMessage(
      id: id,
      type: DemoMessageType.product,
      productData: productData,
      time: time,
      isOutgoing: isOutgoing,
      status: status,
      senderName: senderName,
      avatar: avatar,
      senderColor: senderColor,
    );
  }
}
