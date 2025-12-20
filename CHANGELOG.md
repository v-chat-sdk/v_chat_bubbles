# Changelog

All notable changes to this project will be documented in this file.

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
