part of 'text_bubble.dart';

extension _TextBubbleParsing on _ExpandableTextWithPreviewState {
  List<VCustomPattern> _getCachedPatterns(
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

  List<InlineSpan> _parseInlineText(
    String text,
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextStyle mentionStyle,
    VBubbleConfig config,
    void Function(VPatternMatch match)? onPatternTap,
  ) {
    final patterns =
        _getCachedPatterns(baseStyle, linkStyle, mentionStyle, config);
    return VTextParser.parseWithPatterns(
      text,
      baseStyle: baseStyle,
      patterns: patterns,
      onPatternTap: onPatternTap,
      messageId: widget.messageId,
    );
  }

  List<Widget> _parseBlockWidgets(
    String text,
    TextStyle baseStyle,
    TextStyle linkStyle,
    TextStyle mentionStyle,
    Color linkColor,
    VBubbleConfig config,
    void Function(VPatternMatch match)? onPatternTap,
  ) {
    final brightness = widget.textColor.computeLuminance() > 0.5
        ? Brightness.dark
        : Brightness.light;
    final blockStyle = VBlockFormatStyle.fromColors(
      textColor: widget.textColor,
      accentColor: linkColor,
      brightness: brightness,
    );
    final blockConfig = VBlockParseConfig(
      enableCodeBlocks: config.patterns.enableCodeBlocks,
      enableBlockquotes: config.patterns.enableBlockquotes,
      enableBulletLists: config.patterns.enableBulletLists,
      enableNumberedLists: config.patterns.enableNumberedLists,
      style: blockStyle,
      maxWidth: config.sizing.maxWidth ?? double.infinity,
    );
    final patterns =
        _getCachedPatterns(baseStyle, linkStyle, mentionStyle, config);
    return VTextParser.parseWithBlocks(
      text,
      baseStyle: baseStyle,
      inlinePatterns: patterns,
      blockConfig: blockConfig,
      onPatternTap: onPatternTap,
      messageId: widget.messageId,
    );
  }
}
