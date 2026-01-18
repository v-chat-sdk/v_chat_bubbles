part of 'text_bubble.dart';

/// Internal stateful widget for expandable text with link preview.
class _ExpandableTextWithPreview extends StatefulWidget {
  final String messageId;
  final String text;
  final VLinkPreviewData? linkPreview;
  final bool isMeSender;
  final Color textColor;
  final Widget? header;
  // Meta values for proper comparison in didUpdateWidget.
  final String time;
  final VMessageStatus status;
  final bool isEdited;
  final bool isPinned;
  final bool isStarred;

  const _ExpandableTextWithPreview({
    required this.messageId,
    required this.text,
    this.linkPreview,
    required this.isMeSender,
    required this.textColor,
    this.header,
    required this.time,
    required this.status,
    required this.isEdited,
    required this.isPinned,
    required this.isStarred,
  });

  @override
  State<_ExpandableTextWithPreview> createState() =>
      _ExpandableTextWithPreviewState();
}

class _ExpandableTextWithPreviewState
    extends State<_ExpandableTextWithPreview> {
  // Cache to avoid re-parsing on every scroll/build.
  List<InlineSpan>? _cachedSpans;
  List<InlineSpan>? _cachedTruncatedSpans;
  List<Widget>? _cachedBlockWidgets;
  List<VCustomPattern>? _cachedPatterns;
  String? _cacheKey;
  TextDirection? _cachedTextDirection;

  @override
  void didUpdateWidget(covariant _ExpandableTextWithPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only invalidate for properties that affect text parsing.
    if (oldWidget.text != widget.text ||
        oldWidget.textColor != widget.textColor ||
        oldWidget.isMeSender != widget.isMeSender) {
      _clearParseCache();
    }
  }

  void _clearParseCache() {
    _cachedSpans = null;
    _cachedTruncatedSpans = null;
    _cachedBlockWidgets = null;
    _cachedPatterns = null;
    _cacheKey = null;
    _cachedTextDirection = null;
  }

  Widget _buildMeta() {
    return VBubbleFooter(
      isMeSender: widget.isMeSender,
      time: widget.time,
      status: widget.status,
      isStarred: widget.isStarred,
      isPinned: widget.isPinned,
      isEdited: widget.isEdited,
    );
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
      builder: (context, _) => _buildMessageContent(context),
    );
  }
}
