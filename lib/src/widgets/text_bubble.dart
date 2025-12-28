import 'package:flutter/material.dart';

import '../core/config.dart';
import '../core/constants.dart';
import '../core/models.dart';
import '../utils/text_parser.dart';
import 'base_bubble.dart';
import 'bubble_scope.dart';
import 'bubble_wrapper.dart';
import 'shared/block_format_widgets.dart';
import 'shared/color_selector_mixin.dart';
import 'shared/unified_image.dart';

/// Simple text message bubble
///
/// Renders text content with support for:
/// - Link, email, phone, and mention detection
/// - Expandable text with "See more/less" for long messages
/// - Link preview (optional) with image, title, description
/// - Reply preview, forward header, and sender name (handled by BaseBubble)
class VTextBubble extends BaseBubble {
  /// Message text content
  final String text;

  /// Optional link preview data
  final VLinkPreviewData? linkPreview;

  @override
  String get messageType => 'text message';

  const VTextBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.text,
    this.linkPreview,
    super.status,
    super.isSameSender,
    super.avatar,
    super.senderName,
    super.senderColor,
    super.replyTo,
    super.forwardedFrom,
    super.reactions,
    super.isEdited,
    super.isPinned,
    super.isStarred,
    super.isHighlighted,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = context.bubbleTheme;
    final textColor = selectTextColor(theme);
    final header = buildBubbleHeader(context);
    final showTail = !isSameSender;
    return VBubbleWrapper(
      isMeSender: isMeSender,
      showTail: showTail,
      child: _ExpandableTextWithPreview(
        messageId: messageId,
        text: text,
        linkPreview: linkPreview,
        isMeSender: isMeSender,
        textColor: textColor,
        metaBuilder: () => buildMeta(context),
        header: header,
      ),
    );
  }
}

/// Internal stateful widget for expandable text with link preview
class _ExpandableTextWithPreview extends StatefulWidget {
  final String messageId;
  final String text;
  final VLinkPreviewData? linkPreview;
  final bool isMeSender;
  final Color textColor;
  final Widget Function() metaBuilder;
  final Widget? header;

  const _ExpandableTextWithPreview({
    required this.messageId,
    required this.text,
    this.linkPreview,
    required this.isMeSender,
    required this.textColor,
    required this.metaBuilder,
    this.header,
  });

  @override
  State<_ExpandableTextWithPreview> createState() =>
      _ExpandableTextWithPreviewState();
}

class _ExpandableTextWithPreviewState
    extends State<_ExpandableTextWithPreview> {
  // ═══════════════════════════════════════════════════════════════════════════
  // PERFORMANCE CACHE - Avoid re-parsing on every scroll/build
  // ═══════════════════════════════════════════════════════════════════════════
  /// Cached inline spans (parsed once, reused on rebuilds)
  List<InlineSpan>? _cachedSpans;
  List<InlineSpan>? _cachedTruncatedSpans;

  /// Cached block widgets (for block-level formatting)
  List<Widget>? _cachedBlockWidgets;

  /// Cached pattern list (built once per config)
  List<VCustomPattern>? _cachedPatterns;

  /// Cache key to detect when re-parsing is needed
  String? _cacheKey;

  /// Cached text direction
  TextDirection? _cachedTextDirection;

  @override
  void didUpdateWidget(covariant _ExpandableTextWithPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Invalidate cache if text changes
    if (oldWidget.text != widget.text ||
        oldWidget.textColor != widget.textColor ||
        oldWidget.isMeSender != widget.isMeSender) {
      _invalidateCache();
    }
  }

  void _invalidateCache() {
    _cachedSpans = null;
    _cachedTruncatedSpans = null;
    _cachedBlockWidgets = null;
    _cachedPatterns = null;
    _cacheKey = null;
    _cachedTextDirection = null;
  }

  void _toggleExpand() {
    final manager = context.expandStateManager;
    manager.toggle(widget.messageId);
    context.bubbleCallbacks.onExpandToggle?.call(
      widget.messageId,
      manager.isExpanded(widget.messageId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expandManager = context.expandStateManager;
    return ListenableBuilder(
      listenable: expandManager,
      builder: (context, _) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    final callbacks = context.bubbleCallbacks;
    final expandManager = context.expandStateManager;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    final isExpanded = expandManager.isExpanded(widget.messageId);
    final shouldTruncate = config.textExpansion.enabled &&
        widget.text.length > config.textExpansion.characterThreshold;
    final displayText = shouldTruncate && !isExpanded
        ? widget.text.substring(0, config.textExpansion.characterThreshold)
        : widget.text;
    // Generate cache key from relevant config values
    // Include isSelectionMode since it affects whether pattern taps are enabled
    final newCacheKey =
        '${widget.text}_${widget.textColor.hashCode}_${widget.isMeSender}_${config.patterns.hashCode}_$isSelectionMode';
    final needsReParse = _cacheKey != newCacheKey;
    if (needsReParse) {
      _cacheKey = newCacheKey;
      _cachedSpans = null;
      _cachedTruncatedSpans = null;
      _cachedBlockWidgets = null;
    }
    final linkColor =
        widget.isMeSender ? theme.outgoingLinkColor : theme.incomingLinkColor;
    final baseStyle = theme.messageTextStyle.copyWith(color: widget.textColor);
    final linkStyle = theme.linkTextStyle.copyWith(color: linkColor);
    final mentionStyle = theme.messageTextStyle.copyWith(
      color: linkColor,
      fontWeight: FontWeight.w600,
    );
    // Check if block patterns are enabled
    final hasBlockPatterns = config.patterns.hasBlockPatterns;
    // Build link preview widget if available
    Widget? linkPreviewWidget;
    if (widget.linkPreview != null) {
      linkPreviewWidget =
          _buildLinkPreview(context, widget.linkPreview!, linkColor);
    }
    // Cache text direction
    _cachedTextDirection ??= VTextParser.getTextDirection(widget.text);
    final textDirection = _cachedTextDirection!;
    // Disable pattern taps when in selection mode
    final effectiveOnPatternTap =
        isSelectionMode ? null : callbacks.onPatternTap;
    // Use block parsing if block patterns are enabled
    if (hasBlockPatterns && !shouldTruncate) {
      return _buildBlockContent(
        context,
        displayText,
        baseStyle,
        linkStyle,
        mentionStyle,
        effectiveOnPatternTap,
        linkPreviewWidget,
        linkColor,
        config,
      );
    }
    // ═══════════════════════════════════════════════════════════════════════
    // CACHED INLINE PARSING - Only parse once per text/config combination
    // ═══════════════════════════════════════════════════════════════════════
    List<InlineSpan> spans;
    if (shouldTruncate && !isExpanded) {
      // Use truncated cache
      _cachedTruncatedSpans ??= _parseText(
        displayText,
        baseStyle,
        linkStyle,
        mentionStyle,
        config,
        effectiveOnPatternTap,
      );
      spans = _cachedTruncatedSpans!;
    } else {
      // Use full text cache
      _cachedSpans ??= _parseText(
        widget.text,
        baseStyle,
        linkStyle,
        mentionStyle,
        config,
        effectiveOnPatternTap,
      );
      spans = _cachedSpans!;
    }
    if (!shouldTruncate) {
      final textRow = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: RichText(
              text: TextSpan(children: spans),
              textDirection: textDirection,
            ),
          ),
          BubbleSpacing.gapM,
          widget.metaBuilder(),
        ],
      );
      if (widget.header == null && linkPreviewWidget == null) return textRow;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.header != null) widget.header!,
          if (linkPreviewWidget != null) ...[
            linkPreviewWidget,
            BubbleSpacing.gapM,
          ],
          textRow,
        ],
      );
    }
    // Truncated text with gradient fade and "See more/less"
    final animDuration =
        isExpanded ? config.animation.expand : config.animation.collapse;
    final animCurve = config.animation.defaultCurve;
    return AnimatedSize(
      duration: animDuration,
      curve: animCurve,
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.header != null) widget.header!,
          if (linkPreviewWidget != null) ...[
            linkPreviewWidget,
            BubbleSpacing.gapM,
          ],
          AnimatedCrossFade(
            duration: animDuration,
            firstCurve: animCurve,
            secondCurve: animCurve,
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.textColor,
                  widget.textColor.withValues(alpha: 0),
                ],
                stops: const [0.7, 1.0],
              ).createShader(bounds),
              blendMode: BlendMode.dstIn,
              child: RichText(
                text: TextSpan(children: spans),
                textDirection: textDirection,
              ),
            ),
            secondChild: RichText(
              text: TextSpan(children: spans),
              textDirection: textDirection,
            ),
          ),
          BubbleSpacing.vGapS,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: _toggleExpand,
                  child: Text(
                    isExpanded
                        ? config.translations.seeLess
                        : config.translations.seeMore,
                    style: theme.linkTextStyle.copyWith(
                      color: linkColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              widget.metaBuilder(),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS - Cached parsing
  // ═══════════════════════════════════════════════════════════════════════════
  /// Build and cache patterns list
  List<VCustomPattern> _getPatterns(
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextStyle mentionStyle,
    VBubbleConfig config,
  ) {
    return _cachedPatterns ??= config.patterns.buildPatterns(
      baseStyle: baseStyle,
      linkStyle: linkStyle,
      mentionStyle: mentionStyle,
    );
  }

  /// Parse text and return spans (used for caching)
  List<InlineSpan> _parseText(
    String text,
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextStyle mentionStyle,
    VBubbleConfig config,
    void Function(VPatternMatch match)? onPatternTap,
  ) {
    final patterns = _getPatterns(baseStyle, linkStyle, mentionStyle, config);
    return VTextParser.parseWithPatterns(
      text,
      baseStyle: baseStyle,
      patterns: patterns,
      onPatternTap: onPatternTap,
      messageId: widget.messageId,
    );
  }

  /// Build content with block-level formatting support (code blocks, blockquotes, lists)
  /// Uses cached block widgets to avoid re-parsing on every build
  Widget _buildBlockContent(
    BuildContext context,
    String text,
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextStyle mentionStyle,
    void Function(VPatternMatch match)? onPatternTap,
    Widget? linkPreviewWidget,
    Color linkColor,
    VBubbleConfig config,
  ) {
    // Use cached block widgets if available
    _cachedBlockWidgets ??= _parseBlockContent(
      text,
      baseStyle,
      linkStyle,
      mentionStyle,
      linkColor,
      config,
      onPatternTap,
    );
    // Build the column with all content
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.header != null) widget.header!,
        if (linkPreviewWidget != null) ...[
          linkPreviewWidget,
          BubbleSpacing.gapM,
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _cachedBlockWidgets!,
              ),
            ),
            BubbleSpacing.gapM,
            widget.metaBuilder(),
          ],
        ),
      ],
    );
  }

  /// Parse block content (expensive operation - only called once per text)
  List<Widget> _parseBlockContent(
    String text,
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextStyle mentionStyle,
    Color linkColor,
    VBubbleConfig config,
    void Function(VPatternMatch match)? onPatternTap,
  ) {
    // Derive brightness from text color luminance
    final brightness = widget.textColor.computeLuminance() > 0.5
        ? Brightness.dark
        : Brightness.light;
    // Create block style based on theme
    final blockStyle = VBlockFormatStyle.fromColors(
      textColor: widget.textColor,
      accentColor: linkColor,
      brightness: brightness,
    );
    // Create block config from pattern config
    final blockConfig = VBlockParseConfig(
      enableCodeBlocks: config.patterns.enableCodeBlocks,
      enableBlockquotes: config.patterns.enableBlockquotes,
      enableBulletLists: config.patterns.enableBulletLists,
      enableNumberedLists: config.patterns.enableNumberedLists,
      style: blockStyle,
      maxWidth: config.sizing.maxWidth ?? double.infinity,
    );
    // Use cached patterns
    final patterns = _getPatterns(baseStyle, linkStyle, mentionStyle, config);
    // Parse text with block support
    return VTextParser.parseWithBlocks(
      text,
      baseStyle: baseStyle,
      inlinePatterns: patterns,
      blockConfig: blockConfig,
      onPatternTap: onPatternTap,
      messageId: widget.messageId,
    );
  }

  Widget _buildLinkPreview(
    BuildContext context,
    VLinkPreviewData linkPreview,
    Color linkColor,
  ) {
    final theme = context.bubbleTheme;
    final callbacks = context.bubbleCallbacks;
    final textColor = widget.textColor;
    final replyBarColor =
        ColorSelectorMixin.getReplyBarColor(theme, widget.isMeSender);
    return GestureDetector(
      onTap: context.bubbleScope.isSelectionMode
          ? null
          : () {
              callbacks.onPatternTap?.call(VPatternMatch(
                patternId: 'url',
                matchedText: linkPreview.url,
                rawText: linkPreview.url,
                messageId: widget.messageId,
              ));
            },
      child: Container(
        padding: const EdgeInsets.only(left: 8, bottom: 8),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: replyBarColor, width: 2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (linkPreview.siteName != null)
              Text(
                linkPreview.siteName!,
                style: theme.timeTextStyle.copyWith(
                  color: linkColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            if (linkPreview.title != null) ...[
              BubbleSpacing.vGapXS,
              Text(
                linkPreview.title!,
                style: theme.messageTextStyle.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textDirection: VTextParser.getTextDirection(linkPreview.title!),
              ),
            ],
            if (linkPreview.description != null) ...[
              BubbleSpacing.vGapXS,
              Text(
                linkPreview.description!,
                style: theme.captionTextStyle.copyWith(
                  color: textColor.withValues(alpha: BubbleOpacity.heavy),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textDirection:
                    VTextParser.getTextDirection(linkPreview.description!),
              ),
            ],
            if (linkPreview.image != null) ...[
              BubbleSpacing.gapM,
              ClipRRect(
                borderRadius: BubbleRadius.small,
                child: VUnifiedImage(
                  imageSource: linkPreview.image!,
                  height: BubbleSizes.mediaHeightMedium,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 250),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
