import 'package:flutter/foundation.dart';
import 'package:v_platform/v_platform.dart';

import 'enums.dart';

/// Delivery event for one conversation participant.
@immutable
class VMessageReceipt {
  final String recipientId;
  final String? displayName;
  final VPlatformFile? avatar;
  final VMessageLifecycleStage stage;
  final DateTime occurredAt;

  const VMessageReceipt({
    required this.recipientId,
    required this.stage,
    required this.occurredAt,
    this.displayName,
    this.avatar,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VMessageReceipt &&
          recipientId == other.recipientId &&
          displayName == other.displayName &&
          avatar == other.avatar &&
          stage == other.stage &&
          occurredAt == other.occurredAt;

  @override
  int get hashCode =>
      Object.hash(recipientId, displayName, avatar, stage, occurredAt);
}

/// One immutable revision in a message edit history.
@immutable
class VMessageEditRevision {
  final String text;
  final DateTime editedAt;
  final String? editorId;

  const VMessageEditRevision({
    required this.text,
    required this.editedAt,
    this.editorId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VMessageEditRevision &&
          text == other.text &&
          editedAt == other.editedAt &&
          editorId == other.editorId;

  @override
  int get hashCode => Object.hash(text, editedAt, editorId);
}

/// Optional detailed lifecycle metadata for a message.
@immutable
class VMessageLifecycleData {
  final VMessageLifecycleStage stage;
  final DateTime? queuedAt;
  final DateTime? sentAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  final DateTime? failedAt;
  final String? errorCode;
  final String? errorMessage;
  final int retryCount;
  final DateTime? nextRetryAt;
  final List<VMessageReceipt> receipts;
  final List<VMessageEditRevision> editHistory;

  const VMessageLifecycleData({
    required this.stage,
    this.queuedAt,
    this.sentAt,
    this.deliveredAt,
    this.readAt,
    this.failedAt,
    this.errorCode,
    this.errorMessage,
    this.retryCount = 0,
    this.nextRetryAt,
    this.receipts = const [],
    this.editHistory = const [],
  }) : assert(retryCount >= 0, 'retryCount must not be negative');

  bool get canRetry => stage == VMessageLifecycleStage.error;

  int get deliveredRecipientCount => receipts
      .where(
        (receipt) =>
            receipt.stage == VMessageLifecycleStage.delivered ||
            receipt.stage == VMessageLifecycleStage.read,
      )
      .length;

  int get readRecipientCount => receipts
      .where((receipt) => receipt.stage == VMessageLifecycleStage.read)
      .length;

  String get semanticLabel {
    final details = <String>[stage.name];
    if (readRecipientCount > 0) {
      details.add('$readRecipientCount read');
    } else if (deliveredRecipientCount > 0) {
      details.add('$deliveredRecipientCount delivered');
    }
    if (retryCount > 0) details.add('$retryCount retries');
    if (errorMessage != null && errorMessage!.isNotEmpty) {
      details.add(errorMessage!);
    }
    return details.join(', ');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VMessageLifecycleData &&
          stage == other.stage &&
          queuedAt == other.queuedAt &&
          sentAt == other.sentAt &&
          deliveredAt == other.deliveredAt &&
          readAt == other.readAt &&
          failedAt == other.failedAt &&
          errorCode == other.errorCode &&
          errorMessage == other.errorMessage &&
          retryCount == other.retryCount &&
          nextRetryAt == other.nextRetryAt &&
          listEquals(receipts, other.receipts) &&
          listEquals(editHistory, other.editHistory);

  @override
  int get hashCode => Object.hash(
    stage,
    queuedAt,
    sentAt,
    deliveredAt,
    readAt,
    failedAt,
    errorCode,
    errorMessage,
    retryCount,
    nextRetryAt,
    Object.hashAll(receipts),
    Object.hashAll(editHistory),
  );
}

/// Policy and state for spoiler, view-once, or expiring content.
@immutable
class VContentProtectionData {
  final VContentProtectionMode mode;
  final DateTime? expiresAt;
  final DateTime? viewedAt;
  final bool initiallyRevealed;
  final String revealLabel;
  final String expiredLabel;

  const VContentProtectionData({
    required this.mode,
    this.expiresAt,
    this.viewedAt,
    this.initiallyRevealed = false,
    this.revealLabel = 'Tap to reveal',
    this.expiredLabel = 'Content expired',
  }) : assert(
         mode != VContentProtectionMode.expiring || expiresAt != null,
         'Expiring content requires expiresAt',
       );

  const VContentProtectionData.spoiler({
    this.initiallyRevealed = false,
    this.revealLabel = 'Tap to reveal',
    this.expiredLabel = 'Content expired',
  }) : mode = VContentProtectionMode.spoiler,
       expiresAt = null,
       viewedAt = null;

  const VContentProtectionData.viewOnce({
    this.viewedAt,
    this.initiallyRevealed = false,
    this.revealLabel = 'View once',
    this.expiredLabel = 'Already viewed',
  }) : mode = VContentProtectionMode.viewOnce,
       expiresAt = null;

  bool isExpiredAt(DateTime now) {
    if (mode == VContentProtectionMode.viewOnce && viewedAt != null) {
      return true;
    }
    return expiresAt != null && !now.isBefore(expiresAt!);
  }

  Duration? remainingAt(DateTime now) {
    if (expiresAt == null) return null;
    final remaining = expiresAt!.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VContentProtectionData &&
          mode == other.mode &&
          expiresAt == other.expiresAt &&
          viewedAt == other.viewedAt &&
          initiallyRevealed == other.initiallyRevealed &&
          revealLabel == other.revealLabel &&
          expiredLabel == other.expiredLabel;

  @override
  int get hashCode => Object.hash(
    mode,
    expiresAt,
    viewedAt,
    initiallyRevealed,
    revealLabel,
    expiredLabel,
  );
}

/// Participant represented in reaction details.
@immutable
class VReactionActor {
  final String id;
  final String displayName;
  final VPlatformFile? avatar;
  final DateTime? reactedAt;
  final bool isCurrentUser;

  const VReactionActor({
    required this.id,
    required this.displayName,
    this.avatar,
    this.reactedAt,
    this.isCurrentUser = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VReactionActor &&
          id == other.id &&
          displayName == other.displayName &&
          avatar == other.avatar &&
          reactedAt == other.reactedAt &&
          isCurrentUser == other.isCurrentUser;

  @override
  int get hashCode =>
      Object.hash(id, displayName, avatar, reactedAt, isCurrentUser);
}

/// Selected character range used by selective quote replies.
@immutable
class VReplyQuoteRange {
  final int start;
  final int end;
  final String text;

  const VReplyQuoteRange({
    required this.start,
    required this.end,
    required this.text,
  }) : assert(start >= 0, 'start must not be negative'),
       assert(end >= start, 'end must be greater than or equal to start');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VReplyQuoteRange &&
          start == other.start &&
          end == other.end &&
          text == other.text;

  @override
  int get hashCode => Object.hash(start, end, text);
}

/// Compact thread state displayed beneath a reply preview.
@immutable
class VThreadSummary {
  final String threadId;
  final int replyCount;
  final List<VReactionActor> participants;
  final DateTime? lastReplyAt;
  final String? lastReplyPreview;

  const VThreadSummary({
    required this.threadId,
    required this.replyCount,
    this.participants = const [],
    this.lastReplyAt,
    this.lastReplyPreview,
  }) : assert(replyCount >= 0, 'replyCount must not be negative');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VThreadSummary &&
          threadId == other.threadId &&
          replyCount == other.replyCount &&
          listEquals(participants, other.participants) &&
          lastReplyAt == other.lastReplyAt &&
          lastReplyPreview == other.lastReplyPreview;

  @override
  int get hashCode => Object.hash(
    threadId,
    replyCount,
    Object.hashAll(participants),
    lastReplyAt,
    lastReplyPreview,
  );
}

/// Translation result and its presentation state.
@immutable
class VMessageTranslationData {
  final VTranslationState state;
  final String sourceLanguageCode;
  final String targetLanguageCode;
  final String? translatedText;
  final String? errorMessage;
  final bool showTranslation;

  const VMessageTranslationData({
    required this.state,
    required this.sourceLanguageCode,
    required this.targetLanguageCode,
    this.translatedText,
    this.errorMessage,
    this.showTranslation = true,
  }) : assert(
         state != VTranslationState.translated || translatedText != null,
         'A translated state requires translatedText',
       );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VMessageTranslationData &&
          state == other.state &&
          sourceLanguageCode == other.sourceLanguageCode &&
          targetLanguageCode == other.targetLanguageCode &&
          translatedText == other.translatedText &&
          errorMessage == other.errorMessage &&
          showTranslation == other.showTranslation;

  @override
  int get hashCode => Object.hash(
    state,
    sourceLanguageCode,
    targetLanguageCode,
    translatedText,
    errorMessage,
    showTranslation,
  );
}

/// Time-aligned segment in a voice transcript.
@immutable
class VTranscriptSegment {
  final Duration start;
  final Duration? end;
  final String text;
  final double? confidence;

  const VTranscriptSegment({
    required this.start,
    required this.text,
    this.end,
    this.confidence,
  }) : assert(
         confidence == null || (confidence >= 0 && confidence <= 1),
         'confidence must be between zero and one',
       );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VTranscriptSegment &&
          start == other.start &&
          end == other.end &&
          text == other.text &&
          confidence == other.confidence;

  @override
  int get hashCode => Object.hash(start, end, text, confidence);
}

/// Speech-recognition state displayed with a voice message.
@immutable
class VVoiceTranscriptData {
  final VTranscriptState state;
  final String? text;
  final String? languageCode;
  final double? confidence;
  final String? errorMessage;
  final bool isExpanded;
  final List<VTranscriptSegment> segments;

  const VVoiceTranscriptData({
    required this.state,
    this.text,
    this.languageCode,
    this.confidence,
    this.errorMessage,
    this.isExpanded = false,
    this.segments = const [],
  }) : assert(
         state != VTranscriptState.ready || text != null,
         'A ready transcript requires text',
       ),
       assert(
         confidence == null || (confidence >= 0 && confidence <= 1),
         'confidence must be between zero and one',
       );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VVoiceTranscriptData &&
          state == other.state &&
          text == other.text &&
          languageCode == other.languageCode &&
          confidence == other.confidence &&
          errorMessage == other.errorMessage &&
          isExpanded == other.isExpanded &&
          listEquals(segments, other.segments);

  @override
  int get hashCode => Object.hash(
    state,
    text,
    languageCode,
    confidence,
    errorMessage,
    isExpanded,
    Object.hashAll(segments),
  );
}

/// Metadata for a shared album or media collection.
@immutable
class VMediaCollectionData {
  final String collectionId;
  final String? title;
  final int totalItemCount;
  final VMediaQuality quality;
  final List<VReactionActor> contributors;
  final bool canAddItems;
  final DateTime? createdAt;

  const VMediaCollectionData({
    required this.collectionId,
    required this.totalItemCount,
    this.title,
    this.quality = VMediaQuality.standard,
    this.contributors = const [],
    this.canAddItems = false,
    this.createdAt,
  }) : assert(totalItemCount >= 0, 'totalItemCount must not be negative');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VMediaCollectionData &&
          collectionId == other.collectionId &&
          title == other.title &&
          totalItemCount == other.totalItemCount &&
          quality == other.quality &&
          listEquals(contributors, other.contributors) &&
          canAddItems == other.canAddItems &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(
    collectionId,
    title,
    totalItemCount,
    quality,
    Object.hashAll(contributors),
    canAddItems,
    createdAt,
  );
}

/// One item in a collaborative checklist message.
@immutable
class VChecklistItem {
  final String id;
  final String text;
  final bool isCompleted;
  final String? assigneeId;
  final String? assigneeName;
  final DateTime? completedAt;

  const VChecklistItem({
    required this.id,
    required this.text,
    this.isCompleted = false,
    this.assigneeId,
    this.assigneeName,
    this.completedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VChecklistItem &&
          id == other.id &&
          text == other.text &&
          isCompleted == other.isCompleted &&
          assigneeId == other.assigneeId &&
          assigneeName == other.assigneeName &&
          completedAt == other.completedAt;

  @override
  int get hashCode =>
      Object.hash(id, text, isCompleted, assigneeId, assigneeName, completedAt);
}

/// Collaborative checklist with controlled item state.
@immutable
class VChecklistData {
  final String title;
  final List<VChecklistItem> items;
  final bool canEdit;
  final bool canAddItems;

  const VChecklistData({
    required this.title,
    required this.items,
    this.canEdit = true,
    this.canAddItems = false,
  });

  int get completedCount => items.where((item) => item.isCompleted).length;

  double get progress => items.isEmpty ? 0 : completedCount / items.length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VChecklistData &&
          title == other.title &&
          listEquals(items, other.items) &&
          canEdit == other.canEdit &&
          canAddItems == other.canAddItems;

  @override
  int get hashCode =>
      Object.hash(title, Object.hashAll(items), canEdit, canAddItems);
}

/// Calendar-style event shared inside a conversation.
@immutable
class VEventData {
  final String eventId;
  final String title;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String? description;
  final String? location;
  final int attendeeCount;
  final VEventResponse response;
  final bool isCancelled;

  const VEventData({
    required this.eventId,
    required this.title,
    required this.startsAt,
    this.endsAt,
    this.description,
    this.location,
    this.attendeeCount = 0,
    this.response = VEventResponse.none,
    this.isCancelled = false,
  }) : assert(attendeeCount >= 0, 'attendeeCount must not be negative');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VEventData &&
          eventId == other.eventId &&
          title == other.title &&
          startsAt == other.startsAt &&
          endsAt == other.endsAt &&
          description == other.description &&
          location == other.location &&
          attendeeCount == other.attendeeCount &&
          response == other.response &&
          isCancelled == other.isCancelled;

  @override
  int get hashCode => Object.hash(
    eventId,
    title,
    startsAt,
    endsAt,
    description,
    location,
    attendeeCount,
    response,
    isCancelled,
  );
}

/// One recorded point in a live-location trail.
@immutable
class VLocationPoint {
  final double latitude;
  final double longitude;
  final DateTime recordedAt;

  const VLocationPoint({
    required this.latitude,
    required this.longitude,
    required this.recordedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VLocationPoint &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          recordedAt == other.recordedAt;

  @override
  int get hashCode => Object.hash(latitude, longitude, recordedAt);
}

/// Controlled live-location state with expiry and optional trail metadata.
@immutable
class VLiveLocationData {
  final String sessionId;
  final double latitude;
  final double longitude;
  final DateTime startedAt;
  final DateTime expiresAt;
  final DateTime lastUpdatedAt;
  final String? address;
  final String? staticMapUrl;
  final double? accuracyMeters;
  final double? headingDegrees;
  final List<VLocationPoint> trail;

  const VLiveLocationData({
    required this.sessionId,
    required this.latitude,
    required this.longitude,
    required this.startedAt,
    required this.expiresAt,
    required this.lastUpdatedAt,
    this.address,
    this.staticMapUrl,
    this.accuracyMeters,
    this.headingDegrees,
    this.trail = const [],
  });

  bool isActiveAt(DateTime now) => now.isBefore(expiresAt);

  Duration remainingAt(DateTime now) {
    final value = expiresAt.difference(now);
    return value.isNegative ? Duration.zero : value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VLiveLocationData &&
          sessionId == other.sessionId &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          startedAt == other.startedAt &&
          expiresAt == other.expiresAt &&
          lastUpdatedAt == other.lastUpdatedAt &&
          address == other.address &&
          staticMapUrl == other.staticMapUrl &&
          accuracyMeters == other.accuracyMeters &&
          headingDegrees == other.headingDegrees &&
          listEquals(trail, other.trail);

  @override
  int get hashCode => Object.hash(
    sessionId,
    latitude,
    longitude,
    startedAt,
    expiresAt,
    lastUpdatedAt,
    address,
    staticMapUrl,
    accuracyMeters,
    headingDegrees,
    Object.hashAll(trail),
  );
}
