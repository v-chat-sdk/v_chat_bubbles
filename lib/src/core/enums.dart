/// Message delivery status
enum VMessageStatus { sending, sent, delivered, read, error }

/// Detailed transport stage for lifecycle timelines and retry UI.
enum VMessageLifecycleStage { queued, sending, sent, delivered, read, error }

/// Visibility policy for protected message content.
enum VContentProtectionMode { spoiler, viewOnce, expiring }

/// State of an on-device or server-side message translation.
enum VTranslationState { translating, translated, error }

/// State of voice-message speech recognition.
enum VTranscriptState { transcribing, ready, error, unavailable }

/// Image placement used by rich link previews.
enum VLinkPreviewLayout { compact, largeMedia, sideMedia }

/// Requested or delivered quality for shared media.
enum VMediaQuality { standard, highDefinition, original }

/// Current user's response to a shared event.
enum VEventResponse { none, going, maybe, declined }

/// Bubble visual style
enum VBubbleStyle { telegram, whatsapp, messenger, imessage, custom }

/// Position of a message inside an automatically resolved sender group.
enum VMessageGroupPosition {
  /// The message has no adjacent messages in the same group.
  single,

  /// The first message in a group of two or more messages.
  first,

  /// A message between the first and last messages in a group.
  middle,

  /// The final message in a group of two or more messages.
  last,
}

/// Convenience properties used when rendering grouped messages.
extension VMessageGroupPositionX on VMessageGroupPosition {
  /// Whether this message is visually joined to the previous message.
  bool get joinsPrevious =>
      this == VMessageGroupPosition.middle ||
      this == VMessageGroupPosition.last;

  /// Whether this message is visually joined to the next message.
  bool get joinsNext =>
      this == VMessageGroupPosition.first ||
      this == VMessageGroupPosition.middle;

  /// Whether the terminal bubble tail and avatar should be displayed.
  bool get showsGroupEnd =>
      this == VMessageGroupPosition.single ||
      this == VMessageGroupPosition.last;
}

/// Message type for internal routing
enum VMessageType {
  text,
  image,
  gallery,
  video,
  voice,
  file,
  location,
  contact,
  poll,
  call,
  sticker,
  gif,
  linkPreview,
  forwarded,
  reply,
  system,
  dateChip,
  typing,
  deleted,
  checklist,
  event,
  liveLocation,
}

/// Avatar position relative to bubble group
enum VAvatarPosition { top, center, bottom }

/// Call status for call messages
enum VCallStatus { incoming, outgoing, missed, declined, cancelled }

/// Call type
enum VCallType { voice, video }

/// Poll mode
enum VPollMode { single, multiple, quiz }

/// File download/upload state
enum VTransferState {
  idle,
  downloading,
  uploading,
  completed,
  error,
  cancelled,
}

/// Media transfer action triggered by user interaction
enum VMediaTransferAction {
  /// User tapped download button (idle -> downloading)
  download,

  /// User tapped cancel button during transfer
  cancel,

  /// User tapped retry button after error
  retry,
}

/// Message menu actions
enum VMessageAction {
  /// Reply to message
  reply,

  /// Forward message to another chat
  forward,

  /// Edit message (own messages only)
  edit,

  /// Delete message
  delete,

  /// Copy text content
  copy,

  /// Download media/file
  download,

  /// Pin message to chat
  pin,

  /// Unpin message
  unpin,

  /// Star/favorite message
  star,

  /// Remove star from message
  unstar,

  /// Report message
  report,

  /// Share message externally
  share,

  /// Select message for multi-select
  select,

  /// View message info (read receipts, delivery status)
  info,

  /// Save to device (images, files)
  save,

  /// Translate message
  translate,

  /// Speak message (text-to-speech)
  speak,
}

/// Reaction action types
enum VReactionAction { add, remove }
