# Changelog

All notable changes to this project will be documented in this file.

## 1.2.0

### Breaking Changes - Theme System Refactor

The `VBubbleTheme` has been refactored from a flat 49-property class into a nested architecture with 12 specialized sub-theme models. This provides better organization and more granular customization.

#### New Nested Theme Structure

```dart
VBubbleTheme (root - 12 nested models)
├── core: VBubbleCoreTheme (bubble colors)
├── text: VBubbleTextTheme (text colors & styles)
├── status: VBubbleStatusTheme (message status icons & colors)
├── reply: VBubbleReplyTheme (reply preview styling)
├── forward: VBubbleForwardTheme (forward header styling)
├── voice: VBubbleVoiceTheme (voice message styling)
├── media: VBubbleMediaTheme (media shimmer & progress)
├── reaction: VBubbleReactionTheme (reaction pills)
├── menu: VBubbleMenuTheme (context menu)
├── selection: VBubbleSelectionTheme (selection mode)
├── systemMessages: VBubbleSystemTheme (system messages)
└── dateChip: VBubbleDateChipTheme (date separators)
```

#### Migration Guide

```dart
// Before (1.1.0) - flat properties
theme.outgoingBubbleColor
theme.incomingTextColor

// After (1.2.0) - nested access
theme.core.outgoing.bubbleColor
theme.text.incoming.primaryColor

// Or use convenience helpers
theme.bubbleColor(isMeSender)
theme.textColor(isMeSender)
```

### New Features

#### Complete Sizing Properties
All theme models now include hardcoded sizing properties for full customization:

- **VBubbleMenuTheme**: `fontSize`, `iconSize`, `itemPadding`, `borderRadius`, `elevation`
- **VBubbleReactionTheme**: `countFontSize`, `emojiSize`, `pillPadding`, `pillBorderRadius`, `pillSpacing`, `rowHeight`
- **VBubbleSelectionTheme**: `checkmarkSize`, `checkmarkBackgroundSize`, `overlayBorderRadius`
- **VBubbleForwardTheme**: `textStyle`, `iconSize`, `padding`, `borderRadius`
- **VBubbleReplyTheme**: `barWidth`, `padding`, `borderRadius`, `senderNameStyle`, `messageStyle`, `maxLines`

#### Selection Mode Behavior
When `isSelectionMode` is enabled, all interactive elements inside bubbles are now properly disabled:
- Pattern taps (links, mentions, emails, phones)
- Reaction taps
- Avatar taps
- Reply preview taps
- Media taps
- Gallery image taps

Only the tap to select/unselect the message works in selection mode.

#### New Pattern Config Option
- Added `enableMentionWithId` to `VPatternConfig` for enabling/disabling mention patterns with embedded user IDs

### Other Changes

- Renamed `system` property to `systemMessages` in `VBubbleTheme` for clarity
- All theme presets (Telegram, WhatsApp, Messenger, iMessage - light/dark) updated with nested structure
- Backward compatibility getters maintained for common properties

---

## 1.1.0

### Breaking Changes - Callback Renames

The following callbacks have been renamed for improved clarity:

| Old Name | New Name | Reason |
|----------|----------|--------|
| `onSelect` | `onSelectionChanged` | Better reflects state change semantics |
| `onReplyTap` | `onReplyPreviewTap` | Clarifies it's for tapping the reply preview widget |
| `onReactionInfoTap` | `onReactionTap` | Simplified, clearer naming |
| `onMenuItemTap` | `onMenuItemSelected` | More semantic - item is "selected" not just "tapped" |
| `onMediaTransferAction` | `onTransferStateChanged` | Reflects state change pattern |

**VReplyData** now requires `originalMessageId` field (for navigating to original message when tapping reply preview).

### Migration Guide

Update your `VBubbleCallbacks` usage:

```dart
// Before (1.0.0)
VBubbleCallbacks(
  onSelect: (messageId, isSelected) { },
  onReplyTap: (originalMessageId) { },
  onReactionInfoTap: (messageId, emoji, position) { },
  onMenuItemTap: (messageId, item) { },
  onMediaTransferAction: (messageId, action) { },
)

// After (1.1.0)
VBubbleCallbacks(
  onSelectionChanged: (messageId, isSelected) { },
  onReplyPreviewTap: (originalMessageId) { },
  onReactionTap: (messageId, emoji, position) { },
  onMenuItemSelected: (messageId, item) { },
  onTransferStateChanged: (messageId, action) { },
)

// VReplyData now requires originalMessageId
VReplyData(
  originalMessageId: 'msg_123',  // NEW - required
  senderId: 'user_1',
  senderName: 'John',
  previewText: 'Original message text',
)
```

### Other Changes

- Fixed: CupertinoContextMenu animation lifecycle error when tapping reactions
- Fixed: RenderFlex overflow issues in file, call, and poll bubbles
- Fixed: `onLongPress` callback now properly replaces built-in context menu when set
- Removed: `customBubbleBuilders` and `menuItems` parameters from `VBubbleScope` (use `menuItemsBuilder` instead)

---

## 1.0.0

Initial stable release of v_chat_bubbles.

### Features

#### Bubble Styles
- **Telegram** - Gradient bubbles with distinctive curved tails
- **WhatsApp** - Classic green/white bubbles with triangular tails
- **Messenger** - Blue gradient outgoing, gray incoming bubbles
- **iMessage** - Minimal design with subtle tails
- **Custom** - Fully customizable styling

#### Bubble Widgets
- `VTextBubble` - Text messages with link preview support
- `VImageBubble` - Single image messages
- `VVideoBubble` - Video messages with thumbnail and duration
- `VVoiceBubble` - Voice messages with waveform visualization
- `VFileBubble` - File attachments with type icons
- `VLocationBubble` - Location sharing with map preview
- `VContactBubble` - Contact card sharing
- `VPollBubble` - Interactive polls (single/multiple choice)
- `VCallBubble` - Voice/video call history
- `VGalleryBubble` - Multi-image gallery grid
- `VStickerBubble` - Sticker messages
- `VQuotedContentBubble` - Quoted/shared content
- `VSystemBubble` - System messages
- `VDateChip` - Date separator chips
- `VDeletedBubble` - Deleted message placeholder
- `VCustomBubble<T>` - Extensible custom bubble types

#### Text Formatting
- Inline formatting: `*bold*`, `_italic_`, `~strikethrough~`, `` `code` ``
- Block formatting: code blocks, blockquotes, bullet lists, numbered lists
- Pattern detection: URLs, emails, phone numbers, mentions, hashtags
- Custom patterns with regex support

#### Configuration System
- `VBubbleConfig` - Master configuration object
- `VPatternConfig` - Text pattern settings
- `VGestureConfig` - Touch gesture settings
- `VAvatarConfig` - Avatar display settings
- `VSizingConfig` - Bubble dimension settings
- `VSpacingConfig` - Spacing and padding settings
- `VMediaConfig` - Media display settings
- `VTextExpansionConfig` - Expandable text settings
- `VAnimationConfig` - Animation timing settings
- `VAccessibilityConfig` - Accessibility settings
- `VTranslationConfig` - Localization strings

#### Theming
- Pre-built themes for all styles (light/dark variants)
- `VBubbleTheme.custom()` for easy custom theming
- Full color, typography, and gradient customization
- Style-specific reaction emoji sets

#### Callbacks
- Core: tap, long press, swipe reply, select, avatar tap, reply tap
- Grouped: reactions, pattern tap, media tap, menu item tap
- Type-specific: poll vote, location tap, contact tap, call tap, expand toggle, download

#### Custom Bubbles
- `VCustomBubbleData` base class for custom data models
- `CustomBubbleBuilder` typedef for builder functions
- `customBubbleBuilders` map for registering builders
- Built-in examples: `VProductBubble`, `VReceiptBubble`

#### Selection Mode
- Multi-select support with `isSelectionMode` and `selectedIds`
- `VDefaultMenuItems.select` for triggering selection from context menu
- Visual selection indicators on bubbles

#### Performance
- Span caching for parsed text
- Pattern list caching
- Block widget caching
- Text direction caching
- Optimized `shouldRepaint` in all painters
- `IntrinsicWidth` for proper bubble sizing

#### Accessibility
- Semantic labels for screen readers
- Configurable minimum tap target sizes
- High contrast mode support
- RTL text direction detection

#### Localization
- Built-in English and Arabic translations
- `VTranslationConfig.forLocale()` factory
- All user-facing strings configurable

### Dependencies
- `v_platform` - Cross-platform file handling
- `v_chat_voice_player` - Voice message playback
- `video_player` - Video playback support
- `intl` - Date/time formatting
