# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`v_chat_bubbles` is a Flutter package providing chat bubble widgets with support for Telegram, WhatsApp, Messenger, and iMessage visual styles. It includes full theming, callbacks, and customization support for building chat interfaces.

## Common Commands

```bash
# Run static analysis (preferred over build for quick checks)
flutter analyze

# Run tests
flutter test

# Run a single test file
flutter test test/v_chat_bubbles_test.dart

# Check dependencies
flutter pub get
```

## Architecture

### Core Layer (`lib/src/core/`)
- `enums.dart` - Message status, bubble styles, message types, call/poll/transfer states, action enums (MessageAction, ReactionAction)
- `models.dart` - Data models: BubbleReaction, ReplyData, ForwardData, PollData, FileData, LocationTapData, ContactTapData, MediaTapData, PatternMatch, CustomPattern, etc.
- `config.dart` - `VBubbleConfig` with nested configs (PatternConfig, GestureConfig, AvatarConfig, SizingConfig, SpacingConfig, MediaConfig, TextExpansionConfig, AnimationConfig, AccessibilityConfig)
- `callbacks.dart` - `VBubbleCallbacks` with grouped callbacks (17 total: 6 core, 5 grouped, 6 type-specific)

### Config Structure (Nested)
```dart
VBubbleConfig(
  patterns: PatternConfig.standard,             // enableLinks, enablePhones, enableEmails, enableMentions, enableHashtags, enableFormatting, customPatterns
  gestures: GestureConfig.all,                  // enableSwipeToReply, enableLongPress, etc.
  avatar: AvatarConfig.visible,                 // show, position, size
  sizing: SizingConfig.standard,                // maxWidthFraction, maxWidth, minWidth
  spacing: SpacingConfig.standard,              // bubbleRadius, tailSize, sameSenderSpacing, differentSenderSpacing
  media: MediaConfig.standard,                  // cornerRadius, imageMaxHeight, etc.
  textExpansion: TextExpansionConfig.standard,  // enabled, characterThreshold
  animation: AnimationConfig.standard,          // fadeIn, fadeOut, expand, collapse
  accessibility: AccessibilityConfig.standard,  // enableSemanticLabels, minTapTargetSize
)
```

### Config Presets
- `VBubbleConfig.compact()` - Dense layout, smaller elements
- `VBubbleConfig.desktop()` - Wider bubbles, more space
- `VBubbleConfig.readOnly()` - No gestures
- `VBubbleConfig.directChat()` - No avatars (1:1 chat)
- `VBubbleConfig.minimal()` - No tails, clean iMessage-like look
- `VBubbleConfig.groupChat()` - Always show avatars
- `VBubbleConfig.accessible()` - Enhanced accessibility
- `VBubbleConfig.performance()` - No animations, minimal processing

### Callbacks Structure (Grouped)
```dart
VBubbleCallbacks(
  // Core (6)
  onTap: (messageId) => ..., // Universal tap handler - use messageId to lookup message data
  onLongPress: (messageId, position) => ...,
  onSwipeReply: (messageId) => ...,
  onSelect: (messageId, isSelected) => ...,
  onAvatarTap: (senderId) => ...,
  onReplyTap: (originalMessageId) => ...,

  // Grouped (5) - use action enums
  onReaction: (messageId, emoji, ReactionAction.add) => ..., // From context menu
  onReactionInfoTap: (messageId, emoji, position) => ..., // Tap on reaction pill to show who reacted
  onPatternTap: (PatternMatch(patternId: 'url', matchedText: url, ...)) => ..., // Links, mentions, phones, emails, custom patterns
  onMediaTap: (MediaTapData(messageId: id, index: 0)) => ...,
  onMenuItemTap: (messageId, menuItemId) => ...,

  // Type-specific (4)
  onPollVote: (messageId, optionId) => ..., // Returns specific optionId for poll voting
  onExpandToggle: (messageId, isExpanded) => ...,
  onQuotedContentTap: (messageId, contentId) => ...,
  onDownload: (messageId) => ..., // For media files (image, video, file, voice)
)
```

**Note**: Location, Contact, and Call bubbles use `onTap(messageId)` - lookup message in your database to get full details.

### Theme Layer (`lib/src/theme/`)
- `VBubbleTheme` - Complete color/typography theming with factory constructors
- Style factories: `telegramLight()`, `whatsappDark()`, `messengerLight()`, `imessageDark()`, etc.
- `VBubbleTheme.custom()` - Easy custom theme with just essential colors
- `VBubbleTheme.fromStyle()` - Get theme by style enum
- `copyWith()` method for easy customization
- Pre-defined reactions per style via `VBubbleTheme.reactionsForStyle()`

### Widget Layer (`lib/src/widgets/`)
- `VBubbleScaffold` - Root widget providing `VBubbleScope` (InheritedWidget) for config propagation
- `BaseBubble` - Abstract base class with `avatarUrl` support and auto-placeholder (letter + color)
- `BubbleWrapper` - Applies style-specific CustomPainter for bubble shape
- Concrete bubbles: `VTextBubble`, `VImageBubble`, `VVoiceBubble`, `VVideoBubble`, `VFileBubble`, `VLocationBubble`, `VContactBubble`, `VPollBubble`, `VCallBubble`, `VLinkPreviewBubble`, `VStickerBubble`, `VGalleryBubble`, `VSystemBubble`

### Painters Layer (`lib/src/painters/`)
- `BubblePainter` - Abstract base with factory for style-specific painters
- Style implementations: `TelegramBubblePainter`, `WhatsAppBubblePainter`, `MessengerBubblePainter`, `IMessageBubblePainter`
- Each uses CustomPainter with precise bezier curves for authentic bubble shapes
- `WaveformPainter` - For voice message visualizations

### Utils Layer (`lib/src/utils/`)
- `TextParser` - Parses text for links, mentions, emails, phone numbers; detects RTL

## Usage Pattern

Wrap chat list with `VBubbleScaffold`, then use specific bubble widgets:

```dart
VBubbleScaffold(
  style: BubbleStyle.telegram,
  config: VBubbleConfig.groupChat(),
  callbacks: VBubbleCallbacks(
    onTap: (id) => print('Tapped: $id'),
    onReaction: (id, emoji, action) => print('$action $emoji on $id'),
    onPatternTap: (match) => print('${match.patternId}: ${match.matchedText}'),
    onMediaTap: (data) => print('Media: ${data.messageId}'),
  ),
  child: ListView(
    children: [
      VTextBubble(
        messageId: '1',
        isMeSender: true,
        time: '12:30',
        text: 'Hello!',
        isSameSender: false, // First message or different sender -> shows tail & avatar
        avatarUrl: 'https://example.com/avatar.jpg', // Auto-generates placeholder if null
      ),
      VTextBubble(
        messageId: '2',
        isMeSender: true,
        time: '12:30',
        text: 'How are you?',
        isSameSender: true, // Same sender as previous -> no tail, smaller spacing
      ),
      VImageBubble(
        messageId: '3',
        isMeSender: false,
        time: '12:31',
        imageFile: VPlatformFile.fromUrl(networkUrl: '...'),
      ),
    ],
  ),
)
```

## Context Extensions

Access scope data via BuildContext extensions:
- `context.bubbleScope` - Full VBubbleScope
- `context.bubbleTheme` - Current VBubbleTheme
- `context.bubbleConfig` - Current VBubbleConfig
- `context.bubbleCallbacks` - Current VBubbleCallbacks
- `context.bubbleStyle` - Current BubbleStyle enum
- `context.expandStateManager` - Text expansion state manager

## Convenience Methods

### Config & Callbacks
```dart
// Merge configs
final merged = baseConfig.merge(overrideConfig);

// Merge callbacks
final merged = baseCallbacks.merge(additionalCallbacks);

// Copy with modifications
final updated = config.copyWith(avatar: AvatarConfig.hidden);
```

### Custom Theme
```dart
final theme = VBubbleTheme.custom(
  outgoingBubbleColor: Colors.blue,
  incomingBubbleColor: Colors.grey[200]!,
  accentColor: Colors.blue,
  brightness: Brightness.light,
);
```

## Dependencies

- `v_platform: ^2.1.4` - Re-exported for VPlatformFile access
- `v_chat_voice_player` - Re-exported for voice message controller
- Uses `flutter_lints` for analysis

## Key Patterns

- All bubble widgets extend `BaseBubble` and implement `buildContent(BuildContext context)`
- Config/theme/callbacks flow down via `VBubbleScope` InheritedWidget
- Bubble painters use factory pattern: `BubblePainter.forStyle()`
- All data models are immutable with `copyWith` methods
- Nested config structure: access via `config.sizing.maxWidthFraction`, `config.avatar.show`, etc.
- Grouped callbacks use action enums: `onReaction(id, emoji, ReactionAction.add)`

## Message Grouping (`isSameSender`)

The `isSameSender` parameter controls message grouping behavior:

```dart
// isSameSender = false (different sender or first message)
// - Shows bubble tail
// - Shows avatar (in group chats)
// - Uses differentSenderSpacing (default: 8px)

// isSameSender = true (same sender as previous message)
// - No bubble tail
// - No avatar
// - Uses sameSenderSpacing (default: 2px)
```

SpacingConfig parameters:
- `sameSenderSpacing` - Space between consecutive messages from same sender (default: 2)
- `differentSenderSpacing` - Space before message from different sender (default: 8)

## Custom Bubble Extension System

The SDK provides an extensible system for creating custom bubble widgets.

### Approach 1: Using VCustomBubble (Quick & Easy)

```dart
// 1. Define your data model
class PaymentData extends CustomBubbleData {
  final double amount;
  final String currency;

  const PaymentData({required this.amount, required this.currency});

  @override
  String get contentType => 'payment';
}

// 2. Use VCustomBubble with a builder
VCustomBubble<PaymentData>(
  messageId: 'msg_123',
  isMeSender: true,
  time: '12:30',
  data: PaymentData(amount: 50.0, currency: 'USD'),
  builder: (context, data) {
    final theme = context.bubbleTheme;
    return Row(
      children: [
        Icon(Icons.payment, color: Colors.green),
        Text('\$${data.amount} ${data.currency}'),
      ],
    );
  },
)
```

### Approach 2: Extending BaseBubble (Full Control)

```dart
class VPaymentBubble extends BaseBubble {
  final PaymentData paymentData;

  const VPaymentBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.paymentData,
    // ... other BaseBubble params
  });

  @override
  String get messageType => 'payment';

  @override
  Widget buildContent(BuildContext context) {
    final theme = context.bubbleTheme;
    final header = buildBubbleHeader(context);

    return buildBubbleContainer(
      context: context,
      showTail: !isSameSender,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) header,
          // Your custom content here
          Text('\$${paymentData.amount}'),
          buildMeta(context),
        ],
      ),
    );
  }
}
```

### Protected Helper Methods in BaseBubble

When extending `BaseBubble`, these protected methods are available:

| Method | Description |
|--------|-------------|
| `buildBubbleContainer()` | Wraps content in styled BubbleWrapper |
| `buildBubbleHeader()` | Forward header + sender name + reply preview |
| `buildMeta()` | Timestamp + status + flags (starred, pinned, edited) |
| `buildTimestamp()` | Just the timestamp widget |
| `buildStatusIcon()` | Just the status indicator |
| `buildAvatarWidget()` | Avatar with fallbacks |
| `buildAvatarPlaceholder()` | Default avatar placeholder |
| `buildForwardHeader()` | Forward indicator |
| `buildSenderName()` | Sender name display |
| `buildReplyPreview()` | Reply quote box |
| `buildReactionsWidget()` | Reaction pills row |
| `generateColorFromName()` | Hash-based color from name |
| `getEffectiveReactions()` | Merge external + internal reactions |

### Registering Custom Builders in VBubbleScope

```dart
VBubbleScope(
  customBubbleBuilders: {
    'receipt': (context, messageId, isMeSender, time, data, props) {
      return VReceiptBubble(
        messageId: messageId,
        isMeSender: isMeSender,
        time: time,
        receiptData: data as ReceiptData,
        status: props.status,
        isSameSender: props.isSameSender,
      );
    },
    'product': (context, messageId, isMeSender, time, data, props) {
      return VProductBubble(
        messageId: messageId,
        isMeSender: isMeSender,
        time: time,
        productData: data as ProductData,
      );
    },
  },
  child: ListView(...),
)
```

### Using Custom Builders

```dart
// Check if builder exists
if (context.hasCustomBubbleBuilder('receipt')) {
  final builder = context.getCustomBubbleBuilder('receipt');
  return builder!(context, messageId, isMeSender, time, data, props);
}

// Or use VBubbleScopeData.buildCustomBubble
final widget = context.bubbleScope.buildCustomBubble(
  context: context,
  contentType: 'receipt',
  messageId: messageId,
  isMeSender: isMeSender,
  time: time,
  data: receiptData,
  props: CommonBubbleProps(status: MessageStatus.sent),
);
```

### Example Custom Bubbles

The SDK includes example implementations in `lib/src/widgets/examples/`:

- `VReceiptBubble` - Order receipt with items, subtotal, tax, total
- `VProductBubble` - Product card with image, price, rating, action button

```dart
// Receipt example
VReceiptBubble(
  messageId: 'msg_123',
  isMeSender: true,
  time: '12:30 PM',
  receiptData: ReceiptData(
    orderId: 'ORD-12345',
    storeName: 'Coffee Shop',
    items: [
      ReceiptItem(name: 'Latte', quantity: 2, price: 4.50),
    ],
    subtotal: 9.00,
    tax: 0.90,
    total: 9.90,
  ),
)

// Product example
VProductBubble(
  messageId: 'msg_456',
  isMeSender: false,
  time: '12:31 PM',
  productData: ProductData(
    productId: 'SKU-001',
    name: 'Wireless Headphones',
    price: 299.99,
    originalPrice: 399.99,
    image: VPlatformFile.fromUrl(networkUrl: 'https://...'),
    actionLabel: 'View Product',
    rating: 4.5,
    reviewCount: 128,
  ),
  onActionTap: () => openProductPage(),
)
```
