part of 'text_bubble.dart';

extension _TextBubbleBuild on _ExpandableTextWithPreviewState {
  Widget _buildMessageContent(BuildContext context) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    final callbacks = context.bubbleCallbacks;
    final expandManager = context.expandStateManager;
    final isSelectionMode = context.bubbleScope.isSelectionMode;
    final isExpanded = expandManager.isExpanded(widget.messageId);
    final shouldTruncate = _shouldTruncateText(config);
    final displayText = _getDisplayText(
      config: config,
      shouldTruncate: shouldTruncate,
      isExpanded: isExpanded,
    );

    _resetParseCacheIfNeeded(config, isSelectionMode);

    final linkColor = _getLinkColor(theme);
    final baseStyle = theme.messageTextStyle.copyWith(color: widget.textColor);
    final linkStyle = theme.linkTextStyle.copyWith(color: linkColor);
    final mentionStyle = theme.messageTextStyle.copyWith(
      color: linkColor,
      fontWeight: FontWeight.w600,
    );
    final enableTextSelection = config.textExpansion.enableTextSelection;
    final linkPreviewWidget = _buildLinkPreviewWidget(linkColor);
    final textDirection = _getTextDirection();
    final effectiveOnPatternTap =
        isSelectionMode ? null : callbacks.onPatternTap;

    if (config.patterns.hasBlockPatterns && !shouldTruncate) {
      return _buildBlockLayout(
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

    final spans = _getInlineSpans(
      shouldTruncate: shouldTruncate,
      isExpanded: isExpanded,
      displayText: displayText,
      baseStyle: baseStyle,
      linkStyle: linkStyle,
      mentionStyle: mentionStyle,
      config: config,
      onPatternTap: effectiveOnPatternTap,
    );

    if (!shouldTruncate) {
      return _buildFullTextLayout(
        textDirection: textDirection,
        enableTextSelection: enableTextSelection,
        spans: spans,
        linkPreviewWidget: linkPreviewWidget,
      );
    }

    return _buildCollapsedTextLayout(
      theme: theme,
      config: config,
      isExpanded: isExpanded,
      textDirection: textDirection,
      enableTextSelection: enableTextSelection,
      spans: spans,
      linkPreviewWidget: linkPreviewWidget,
      linkColor: linkColor,
    );
  }

  bool _shouldTruncateText(VBubbleConfig config) {
    return config.textExpansion.enabled &&
        widget.text.length > config.textExpansion.characterThreshold;
  }

  String _getDisplayText({
    required VBubbleConfig config,
    required bool shouldTruncate,
    required bool isExpanded,
  }) {
    if (shouldTruncate && !isExpanded) {
      return widget.text.substring(0, config.textExpansion.characterThreshold);
    }
    return widget.text;
  }

  void _resetParseCacheIfNeeded(VBubbleConfig config, bool isSelectionMode) {
    final newCacheKey =
        '${widget.text}_${widget.textColor.hashCode}_${widget.isMeSender}_${config.patterns.hashCode}_$isSelectionMode';
    if (_cacheKey != newCacheKey) {
      _cacheKey = newCacheKey;
      _cachedSpans = null;
      _cachedTruncatedSpans = null;
      _cachedBlockWidgets = null;
    }
  }

  Color _getLinkColor(VBubbleTheme theme) {
    return widget.isMeSender
        ? theme.outgoingLinkColor
        : theme.incomingLinkColor;
  }

  Widget? _buildLinkPreviewWidget(Color linkColor) {
    if (widget.linkPreview == null) return null;
    return VLinkPreviewWidget(
      linkPreview: widget.linkPreview!,
      linkColor: linkColor,
      textColor: widget.textColor,
      isMeSender: widget.isMeSender,
      messageId: widget.messageId,
    );
  }

  TextDirection _getTextDirection() {
    _cachedTextDirection ??= VTextParser.getTextDirection(widget.text);
    return _cachedTextDirection!;
  }

  List<InlineSpan> _getInlineSpans({
    required bool shouldTruncate,
    required bool isExpanded,
    required String displayText,
    required TextStyle baseStyle,
    required TextStyle linkStyle,
    required TextStyle mentionStyle,
    required VBubbleConfig config,
    required void Function(VPatternMatch match)? onPatternTap,
  }) {
    if (shouldTruncate && !isExpanded) {
      _cachedTruncatedSpans ??= _parseInlineText(
        displayText,
        baseStyle,
        linkStyle,
        mentionStyle,
        config,
        onPatternTap,
      );
      return _cachedTruncatedSpans!;
    }

    _cachedSpans ??= _parseInlineText(
      widget.text,
      baseStyle,
      linkStyle,
      mentionStyle,
      config,
      onPatternTap,
    );
    return _cachedSpans!;
  }

  Widget _buildFullTextLayout({
    required TextDirection textDirection,
    required bool enableTextSelection,
    required List<InlineSpan> spans,
    required Widget? linkPreviewWidget,
  }) {
    final textRow = _buildTextRowWithMeta(
      spans: spans,
      textDirection: textDirection,
      enableTextSelection: enableTextSelection,
    );
    if (widget.header == null && linkPreviewWidget == null) {
      return textRow;
    }
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

  Widget _buildCollapsedTextLayout({
    required VBubbleTheme theme,
    required VBubbleConfig config,
    required bool isExpanded,
    required TextDirection textDirection,
    required bool enableTextSelection,
    required List<InlineSpan> spans,
    required Widget? linkPreviewWidget,
    required Color linkColor,
  }) {
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
              child: _buildTextWidget(
                spans: spans,
                textDirection: textDirection,
                enableSelection: enableTextSelection,
              ),
            ),
            secondChild: _buildTextWidget(
              spans: spans,
              textDirection: textDirection,
              enableSelection: enableTextSelection,
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
              _buildMeta(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextRowWithMeta({
    required List<InlineSpan> spans,
    required TextDirection textDirection,
    required bool enableTextSelection,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: _buildTextWidget(
            spans: spans,
            textDirection: textDirection,
            enableSelection: enableTextSelection,
          ),
        ),
        BubbleSpacing.gapM,
        _buildMeta(),
      ],
    );
  }

  //build normal text bubble
  Widget _buildBlockLayout(
    String text,
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextStyle mentionStyle,
    void Function(VPatternMatch match)? onPatternTap,
    Widget? linkPreviewWidget,
    Color linkColor,
    VBubbleConfig config,
  ) {
    _cachedBlockWidgets ??= _parseBlockWidgets(
      text,
      baseStyle,
      linkStyle,
      mentionStyle,
      linkColor,
      config,
      onPatternTap,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.header != null) widget.header!,
        if (linkPreviewWidget != null) ...[
          linkPreviewWidget,
          BubbleSpacing.gapM,
        ],
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          runAlignment: WrapAlignment.end,
          alignment: WrapAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _cachedBlockWidgets!,
            ),
            BubbleSpacing.gapM,
            _buildMeta(),
          ],
        )
      ],
    );
  }

  Widget _buildTextWidget({
    required List<InlineSpan> spans,
    required TextDirection textDirection,
    required bool enableSelection,
  }) {
    final textSpan = TextSpan(children: spans);
    if (enableSelection) {
      return SelectableText.rich(
        textSpan,
        textDirection: textDirection,
      );
    }
    return RichText(
      text: textSpan,
      textDirection: textDirection,
    );
  }
}
