# WhatsApp-Style Inline Timestamp Problem

## Problem Description

In chat bubble widgets, timestamps are rendering on a **separate line below the text** instead of being **inline with the last line of text** when there is sufficient space (WhatsApp-style behavior).

### Issues Identified

1. **Timestamp on separate line**: Even when there's space available on the last line of text, the timestamp appears on a new line below

2. **Single character/word messages**: Messages like "f" or "Hi" show timestamp on a new line despite having plenty of space for inline placement

3. **Missing timestamps**: Some bubble types (e.g., Call bubbles) accept `time` parameter but never display it

4. **Link preview bubbles**: Text with link previews show timestamp on separate line

5. **Truncated text ("See more")**: Timestamp position incorrect after "See more/less" link

### Expected Behavior (WhatsApp-style)

```
Short text + timestamp fits on same line:
┌─────────────────────────────┐
│ Hello world!    10:26 ✓✓   │
└─────────────────────────────┘

Long text + timestamp doesn't fit:
┌─────────────────────────────┐
│ This is a very long message│
│ that wraps to multiple     │
│ lines in the bubble        │
│                  10:26 ✓✓  │  <- Right-aligned on new line
└─────────────────────────────┘
```

## Technical Challenge

Flutter does not have native support for inline-aligned widgets at the end of text spans. The timestamp needs to:
- Flow with text if space permits on last line
- Fall back to right-aligned new line if not enough space
- Preserve `GestureRecognizer` functionality for tappable links/mentions

## Resources for Implementation

### 1. Custom RenderObject Approach (Recommended)
**Craig Labenz's WhatsApp-style Chat Bubble Gist**
- URL: https://gist.github.com/craiglabenz/c6fc52e3e61f66c51f7a858115bfce51
- Demonstrates custom `RenderObject` that draws chat messages with timestamp tucked into last line
- Uses `TextPainter` for measurement and positioning

### 2. Flutter Feature Request
**Issue #154946: Add a way to inline align Widgets to the end of TextSpans**
- URL: https://github.com/flutter/flutter/issues/154946
- Describes the exact use case for chat apps
- Lists proposed solutions and workarounds
- Status: Open (no native Flutter support yet)

### 3. Flutter Documentation
**WidgetSpan Class**
- URL: https://api.flutter.dev/flutter/widgets/WidgetSpan-class.html
- Can embed widgets inline with text
- Useful for the "invisible spacer" approach

### 4. Related Flutter Issues
**Get size and position of TextSpan within RichText**
- URL: https://github.com/flutter/flutter/issues/126775
- Related to measuring text for positioning

## Implementation Approaches

### Approach A: Custom RenderObject
- Full control over layout and positioning
- Requires implementing hit testing for text spans
- Most accurate WhatsApp-like behavior

### Approach B: Stack + WidgetSpan Spacer
- Add invisible `WidgetSpan` at end of text to reserve space
- Overlay actual timestamp with `Positioned` widget
- Preserves `GestureRecognizer` for tappable text
- Simpler but may have edge cases

### Approach C: Measurement + Conditional Layout
- Measure text and timestamp sizes
- Choose layout based on available space
- May cause visual flicker during measurement pass

## Files Typically Affected

- Text bubble widget (main text message display)
- Call bubble widget (missing timestamp)
- Contact bubble widget (timestamp layout)
- File bubble widget (inline timestamp)
- Base bubble class (shared timestamp/meta rendering)
- New shared widget for timestamped text layout
