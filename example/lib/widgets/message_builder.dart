import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

import '../models/demo_message.dart';

class MessageBuilder {
  MessageBuilder._();

  /// Map of message ID to voice controller for voice messages
  static final Map<String, VVoiceMessageController> _voiceControllers = {};

  /// Get or create voice controller for a message
  static VVoiceMessageController _getVoiceController(DemoMessage message) {
    return _voiceControllers.putIfAbsent(
      message.id,
      () => VVoiceMessageController(
        id: message.id,
        audioSrc: VPlatformFile.fromUrl(networkUrl: message.voiceUrl ?? ''),
        maxDuration: message.voiceDuration,
      ),
    );
  }

  /// Dispose all voice controllers (call when page is disposed)
  static void disposeAll() {
    for (final controller in _voiceControllers.values) {
      controller.dispose();
    }
    _voiceControllers.clear();
  }

  /// Compute isSameSender based on previous message
  static bool computeIsSameSender(
    DemoMessage message,
    DemoMessage? previousMessage,
  ) {
    if (previousMessage == null) return false;
    // Skip system messages and date chips for grouping
    if (previousMessage.type == DemoMessageType.system ||
        previousMessage.type == DemoMessageType.dateChip) {
      return false;
    }
    return message.isOutgoing == previousMessage.isOutgoing;
  }

  /// Build the appropriate bubble widget for a DemoMessage
  static Widget build(
    BuildContext context,
    DemoMessage message, {
    DemoMessage? previousMessage,
  }) {
    final isSameSender = computeIsSameSender(message, previousMessage);
    switch (message.type) {
      case DemoMessageType.text:
        return VTextBubble(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          text: message.text ?? '',
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
          replyTo: message.replyTo,
          forwardedFrom: message.forwardedFrom,
          reactions: message.reactions,
          isEdited: message.isEdited,
          isPinned: message.isPinned,
          isStarred: message.isStarred,
        );
      case DemoMessageType.image:
        return VImageBubble(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          imageFile: VPlatformFile.fromUrl(networkUrl: message.imageUrl ?? ''),
          caption: message.caption,
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
          reactions: message.reactions,
        );
      case DemoMessageType.gallery:
        final urls = message.galleryUrls ?? [];
        return VGalleryBubble(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          items: urls.asMap().entries.map((entry) {
            return VGalleryItemData(
              messageId: '${message.id}_${entry.key}',
              file: VPlatformFile.fromUrl(networkUrl: entry.value),
              time: message.time,
              status: message.status,
            );
          }).toList(),
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
        );
      case DemoMessageType.video:
        return VVideoBubble(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          videoFile: VPlatformFile.fromUrl(
            networkUrl: message.videoUrl ?? '',
            fileSize: message.videoFileSize ?? 0,
          ),
          thumbnailFile: message.videoThumbnailUrl != null
              ? VPlatformFile.fromUrl(networkUrl: message.videoThumbnailUrl!)
              : null,
          duration: message.videoDuration ?? Duration.zero,
          caption: message.caption,
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
        );
      case DemoMessageType.voice:
        return VVoiceBubble(
          messageId: message.id,
          isSameSender: isSameSender,
          isMeSender: message.isOutgoing,
          time: message.time,
          controller: _getVoiceController(message),
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
        );
      case DemoMessageType.file:
        return VFileBubble(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          file: message.file ?? VPlatformFile.fromPath(fileLocalPath: ''),
          transferState: message.transferState,
          progress: message.transferProgress,
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
        );
      case DemoMessageType.poll:
        return VPollBubble(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          pollData:
              message.pollData ?? const VPollData(question: '', options: []),
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
        );
      case DemoMessageType.location:
        return VLocationBubble(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          locationData:
              message.locationData ??
              const VLocationData(latitude: 0, longitude: 0),
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
        );
      case DemoMessageType.contact:
        return VContactBubble(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          contactData:
              message.contactData ?? const VContactData(name: 'Unknown'),
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
        );
      case DemoMessageType.call:
        return VCallBubble(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          callData:
              message.callData ??
              const VCallData(
                type: VCallType.voice,
                status: VCallStatus.missed,
              ),
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
        );
      case DemoMessageType.linkPreview:
        return VTextBubble(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          text: message.text ?? '',
          linkPreview: message.linkPreviewData,
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
        );
      case DemoMessageType.quotedContent:
        return VQuotedContentBubble(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          contentData:
              message.quotedContentData ??
              const QuotedContentData(title: 'Shared Content'),
          text: message.text,
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
        );
      case DemoMessageType.system:
        return VSystemBubble(text: message.text ?? '');
      case DemoMessageType.deleted:
        return VDeletedBubble(
          isMeSender: message.isOutgoing,
          time: message.time,
        );
      case DemoMessageType.dateChip:
        final date = message.dateChipDate ?? DateTime.now();
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(days: 1));
        String dateText;
        if (_isSameDay(date, now)) {
          dateText = 'Today';
        } else if (_isSameDay(date, yesterday)) {
          dateText = 'Yesterday';
        } else {
          dateText = DateFormat('MMMM d, yyyy').format(date);
        }
        return VDateChip(date: dateText);
      case DemoMessageType.product:
        // Use VCustomBubble to demonstrate customBubbleBuilders
        return VCustomBubble<VProductData>(
          messageId: message.id,
          isMeSender: message.isOutgoing,
          isSameSender: isSameSender,
          time: message.time,
          data: message.productData!,
          status: message.status,
          avatar: message.avatar,
          senderName: message.senderName,
          senderColor: message.senderColor,
          builder: (context, data) {
            // This builder is used if no customBubbleBuilder is registered
            // But since we registered 'product' in VBubbleScope, this won't be used
            return const SizedBox();
          },
        );
    }
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
