/// Message delivery status
enum VMessageStatus {
  sending,
  sent,
  delivered,
  read,
  error,
}

/// Bubble visual style
enum VBubbleStyle {
  telegram,
  whatsapp,
  messenger,
  imessage,
  custom,
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
}

/// Avatar position relative to bubble group
enum VAvatarPosition {
  top,
  center,
  bottom,
}

/// Call status for call messages
enum VCallStatus {
  incoming,
  outgoing,
  missed,
  declined,
  cancelled,
}

/// Call type
enum VCallType {
  voice,
  video,
}

/// Poll mode
enum VPollMode {
  single,
  multiple,
  quiz,
}

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
enum VReactionAction {
  add,
  remove,
}
