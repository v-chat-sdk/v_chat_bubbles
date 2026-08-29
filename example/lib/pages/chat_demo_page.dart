import 'package:flutter/material.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

import '../data/sample_messages.dart';
import '../models/demo_message.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/message_builder.dart';

class ChatDemoPage extends StatefulWidget {
  final VBubbleStyle initialStyle;
  final Brightness initialBrightness;
  final Locale initialLocale;
  final bool isGroupChat;
  final ValueChanged<Brightness>? onBrightnessChanged;
  final ValueChanged<Locale>? onLocaleChanged;

  const ChatDemoPage({
    super.key,
    required this.initialStyle,
    required this.initialBrightness,
    required this.initialLocale,
    this.isGroupChat = true,
    this.onBrightnessChanged,
    this.onLocaleChanged,
  });

  @override
  State<ChatDemoPage> createState() => _ChatDemoPageState();
}

class _ChatDemoPageState extends State<ChatDemoPage> {
  late VBubbleStyle _style;
  late Brightness _brightness;
  late Locale _locale;
  late List<DemoMessage> _messages;
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _messageIdCounter = 1000;

  // Search state
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  String _searchQuery = '';
  int _currentMatchIndex = 0;
  List<int> _matchingIndices = [];

  @override
  void initState() {
    super.initState();
    _style = widget.initialStyle;
    _brightness = widget.initialBrightness;
    _locale = widget.initialLocale;
    // Reverse so newest messages are at bottom (for reverse ListView)
    _messages =
        (widget.isGroupChat
                ? SampleMessages.buildGroupChat()
                : SampleMessages.buildDirectChat())
            .reversed
            .toList();
  }

  @override
  void dispose() {
    _textController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    MessageBuilder.disposeAll();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    setState(() {
      _messages.insert(
        0,
        DemoMessage.text(
          id: 'msg_${_messageIdCounter++}',
          text: text,
          time: timeStr,
          isOutgoing: true,
          status: VMessageStatus.sent,
        ),
      );
    });
    _textController.clear();
  }

  void _cycleStyle() {
    setState(() {
      final styles = [
        VBubbleStyle.telegram,
        VBubbleStyle.whatsapp,
        VBubbleStyle.messenger,
        VBubbleStyle.imessage,
      ];
      final currentIndex = styles.indexOf(_style);
      _style = styles[(currentIndex + 1) % styles.length];
    });
  }

  void _toggleBrightness() {
    setState(() {
      _brightness = _brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light;
    });
    widget.onBrightnessChanged?.call(_brightness);
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedIds.clear();
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });
  }

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'en'
          ? const Locale('ar')
          : const Locale('en');
    });
    widget.onLocaleChanged?.call(_locale);
  }

  void _onMessageSelect(String messageId, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedIds.add(messageId);
        // Enable selection mode when first item is selected
        if (!_isSelectionMode) {
          _isSelectionMode = true;
        }
      } else {
        _selectedIds.remove(messageId);
      }
      // Disable selection mode when no items selected
      if (_selectedIds.isEmpty && _isSelectionMode) {
        _isSelectionMode = false;
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchQuery = '';
        _searchController.clear();
        _matchingIndices = [];
        _currentMatchIndex = 0;
        Future.delayed(const Duration(milliseconds: 100), () {
          _searchFocusNode.requestFocus();
        });
      } else {
        _searchQuery = '';
        _searchController.clear();
        _matchingIndices.clear();
      }
    });
  }

  void _closeSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
      _searchController.clear();
      _matchingIndices.clear();
      _currentMatchIndex = 0;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _updateSearchMatches();
    });
  }

  void _updateSearchMatches() {
    if (_searchQuery.isEmpty) {
      _matchingIndices = [];
      _currentMatchIndex = 0;
      return;
    }
    final q = _searchQuery.toLowerCase();
    final List<int> matches = [];
    for (int i = 0; i < _messages.length; i++) {
      final m = _messages[i];
      bool isMatch = false;
      // Check text, caption, file name, etc.
      if (m.text != null && m.text!.toLowerCase().contains(q)) {
        isMatch = true;
      }
      if (m.caption != null && m.caption!.toLowerCase().contains(q)) {
        isMatch = true;
      }
      if (m.imageUrl != null && m.imageUrl!.toLowerCase().contains(q)) {
        isMatch = false; // ignore url
      }
      // For file name
      if (m.file != null && m.file!.name.toLowerCase().contains(q)) {
        isMatch = true;
      }
      // Poll question
      if (m.pollData != null && m.pollData!.question.toLowerCase().contains(q)) {
        isMatch = true;
      }
      // Contact name
      if (m.contactData != null &&
          m.contactData!.name.toLowerCase().contains(q)) {
        isMatch = true;
      }
      // Also check gallery? Skip
      if (isMatch) {
        matches.add(i);
      }
    }
    _matchingIndices = matches;
    if (_matchingIndices.isEmpty) {
      _currentMatchIndex = 0;
    } else if (_currentMatchIndex >= _matchingIndices.length) {
      _currentMatchIndex = 0;
    }
  }

  void _goToNextMatch() {
    if (_matchingIndices.isEmpty) return;
    setState(() {
      _currentMatchIndex = (_currentMatchIndex + 1) % _matchingIndices.length;
    });
    _scrollToCurrentMatch();
  }

  void _goToPrevMatch() {
    if (_matchingIndices.isEmpty) return;
    setState(() {
      _currentMatchIndex =
          (_currentMatchIndex - 1 + _matchingIndices.length) %
          _matchingIndices.length;
    });
    _scrollToCurrentMatch();
  }

  void _scrollToCurrentMatch() {
    if (_matchingIndices.isEmpty) return;
    final targetIndex = _matchingIndices[_currentMatchIndex];
    // Estimate scroll offset for reverse ListView. Each item ~80-120px, use 100 average.
    // In reverse ListView, index 0 is at bottom. Scroll offset 0 is bottom.
    // To bring target into view, animate to its offset.
    // Use a simple approach: jump to show target near middle.
    if (_scrollController.hasClients) {
      // Approximate
      final estimatedOffset = targetIndex * 90.0;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final targetOffset = (maxScroll - estimatedOffset).clamp(0.0, maxScroll);
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  VBubbleCallbacks _buildCallbacks() {
    return VBubbleCallbacks(
      onTap: (messageId) {
        debugPrint('Tapped: $messageId');
      },

      onTransferStateChanged: (messageId, action) {
        debugPrint('onTransferStateChanged: $messageId on $action');
      },
      onReactionTap: (messageId, emoji, position) {
        debugPrint('Reaction info: $emoji on $messageId');
        _showSnackBar('Tapped reaction: $emoji');
      },
      onSwipeReply: (messageId) {
        debugPrint('Swipe reply: $messageId');
        _showSnackBar('Reply to message: $messageId');
      },
      onSelectionChanged: _onMessageSelect,
      onAvatarTap: (senderId) {
        debugPrint('Avatar tap: $senderId');
        _showSnackBar('Tapped avatar of: $senderId');
      },
      onReplyPreviewTap: (originalMessageId) {
        debugPrint('Reply tap: $originalMessageId');
        _showSnackBar('Navigating to original message: $originalMessageId');
      },
      onReaction: (messageId, emoji, action) {
        debugPrint('Reaction: $emoji ($action) on $messageId');
      },
      onMenuItemSelected: (messageId, item) {
        debugPrint('Menu item: ${item.id} (${item.label}) on $messageId');
        _showSnackBar('${item.label} on message: $messageId');
        if (item.id == "select") {
          debugPrint("selectselectselectselectselect");
          _onMessageSelect(messageId, true);
        }
      },
      onDownload: (messageId) {
        debugPrint('Download: $messageId');
        _showSnackBar('Downloading: $messageId');
      },
      onPatternTap: (match) {
        debugPrint('Pattern tap: ${match.patternId} - ${match.matchedText}');
        _showSnackBar(
          'Pattern: ${match.patternId}\nMatched: ${match.matchedText}',
        );
      },
      onPollVote: (messageId, optionId) {
        debugPrint('Poll vote: $optionId on $messageId');
        _showSnackBar('Voted option: $optionId');
      },
      onExpandToggle: (messageId, isExpanded) {
        debugPrint('Expand toggle: $messageId, expanded: $isExpanded');
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  VBubbleConfig _buildConfig() {
    // Get translations based on current locale
    final translations = VTranslationConfig.forLocale(_locale);
    // Base config with patterns and translations
    // Enable full markdown support including block patterns
    final baseConfig = VBubbleConfig(
      translations: translations,

      patterns: VPatternConfig(
        // Enable standard detection patterns
        enableLinks: true,
        enableEmails: true,
        enablePhones: true,
        // Enable inline formatting (bold, italic, strikethrough, inline code)
        enableFormatting: true,
        // Enable block-level patterns (code blocks, blockquotes, lists)
        enableCodeBlocks: true,
        enableBlockquotes: true,
        enableBulletLists: true,
        enableNumberedLists: true,
        // Enable mention with ID pattern: [@DisplayName:userId] -> displays @DisplayName
        enableMentionWithId: true,
        // Custom patterns for tickets, orders, invoices (added on top of flag-based)
        customPatterns: [
          // Custom ticket pattern: TKT-123
          VCustomPattern(
            id: 'ticket',
            pattern: RegExp(r'TKT-\d+'),
            style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            isTappable: true,
          ),
          // Custom order pattern: ORD#12345
          VCustomPattern(
            id: 'order',
            pattern: RegExp(r'ORD#\d+'),
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            isTappable: true,
          ),
          // Custom invoice pattern: INV-2024-001
          VCustomPattern(
            id: 'invoice',
            pattern: RegExp(r'INV-\d{4}-\d+'),
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
            isTappable: true,
          ),
        ],
      ),
    );
    // Apply chat type specific config (only override avatar, keep patterns intact)
    if (widget.isGroupChat) {
      // Group chat: show avatars and sender names
      return baseConfig.copyWith(avatar: VAvatarConfig.visible);
    } else {
      // Direct chat: no avatars, no sender names
      return baseConfig.copyWith(avatar: VAvatarConfig.hidden);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = VBubbleTheme.fromStyle(_style, brightness: _brightness);

    final x = theme.copyWith(
      text: theme.text.copyWith(
        messageTextStyle: TextStyle(fontSize: 15),
        linkTextStyle: TextStyle(fontSize: 15),
      ),
      core: theme.core.copyWith(),
      media: theme.media.copyWith(),
      menu: theme.menu.copyWith(),
      reactions: theme.reactions.copyWith(backgroundColor: Colors.red),
      systemMessages: theme.systemMessages.copyWith(
        backgroundColor: Colors.red,
      ),
    );

    final backgroundColor = _brightness == Brightness.dark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF5F5F5);
    final chatTitle = widget.isGroupChat ? 'Group Chat' : 'Direct Chat';
    final chatSubtitle = widget.isGroupChat ? '5 members' : 'Online';
    return Theme(
      data: ThemeData(
        brightness: _brightness,
        colorSchemeSeed: _getStyleColor(_style),
        useMaterial3: true,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: ChatAppBar(
          style: _style,
          brightness: _brightness,
          isSelectionMode: _isSelectionMode,
          selectedCount: _selectedIds.length,
          onStyleChanged: _cycleStyle,
          onBrightnessToggle: _toggleBrightness,
          onSelectionModeToggle: _toggleSelectionMode,
          onLocaleToggle: _toggleLocale,
          onClearSelection: _clearSelection,
          locale: _locale,
          title: chatTitle,
          subtitle: chatSubtitle,
          isGroupChat: widget.isGroupChat,
          onSearchTap: _toggleSearch,
        ),
        body: VBubbleScope(
          style: _style,
          theme: x,
          config: _buildConfig(),
          callbacks: _buildCallbacks(),
          isSelectionMode: _isSelectionMode,
          selectedIds: _selectedIds,
          menuItemsBuilder: (messageId, messageType, isMeSender) {
            return [...VDefaultMenuItems.textDefaults];
          },
          child: Column(
            children: [
              if (_isSearching) _buildSearchBar(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    // Since list is reversed, "previous" message is at index + 1
                    final previousMessage = index + 1 < _messages.length
                        ? _messages[index + 1]
                        : null;
                    return MessageBuilder.build(
                      context,
                      message,
                      previousMessage: previousMessage,
                      searchQuery: _searchQuery,
                    );
                  },
                ),
              ),
              _buildInputField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final isDark = _brightness == Brightness.dark;
    final count = _matchingIndices.length;
    final current = count == 0 ? 0 : _currentMatchIndex + 1;
    return Container(
      color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.search, size: 22, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              tooltip: 'Clear',
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
          if (_searchQuery.isNotEmpty) ...[
            Text(
              '$current of $count',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_upward, size: 20),
              tooltip: 'Previous',
              onPressed: count == 0 ? null : _goToPrevMatch,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward, size: 20),
              tooltip: 'Next',
              onPressed: count == 0 ? null : _goToNextMatch,
            ),
          ],
          TextButton(
            onPressed: _closeSearch,
            child: const Text(
              'Done',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    final isDark = _brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStyleColor(VBubbleStyle style) {
    switch (style) {
      case VBubbleStyle.telegram:
        return const Color(0xFF0088CC);
      case VBubbleStyle.whatsapp:
        return const Color(0xFF25D366);
      case VBubbleStyle.messenger:
        return const Color(0xFF0084FF);
      case VBubbleStyle.imessage:
        return const Color(0xFF007AFF);
      case VBubbleStyle.custom:
        return Colors.purple;
    }
  }
}
