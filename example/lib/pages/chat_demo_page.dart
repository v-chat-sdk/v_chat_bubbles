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

  @override
  void initState() {
    super.initState();
    _style = widget.initialStyle;
    _brightness = widget.initialBrightness;
    _locale = widget.initialLocale;
    _messages = widget.isGroupChat
        ? SampleMessages.buildGroupChat()
        : SampleMessages.buildDirectChat();
  }

  @override
  void dispose() {
    MessageBuilder.disposeAll();
    super.dispose();
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

  VBubbleCallbacks _buildCallbacks() {
    return VBubbleCallbacks(
      onTap: (messageId) {
        debugPrint('Tapped: $messageId');
      },

      onMediaTransferAction: (messageId, action) {
        debugPrint('onMediaTransferAction: $messageId on $action');
      },
      onReactionInfoTap: (messageId, emoji, position) {
        debugPrint('Reaction info: $emoji on $messageId');
        _showSnackBar('Tapped reaction: $emoji');
      },
      onSwipeReply: (messageId) {
        debugPrint('Swipe reply: $messageId');
        _showSnackBar('Reply to message: $messageId');
      },
      onSelect: _onMessageSelect,
      onAvatarTap: (senderId) {
        debugPrint('Avatar tap: $senderId');
        _showSnackBar('Tapped avatar of: $senderId');
      },
      onReplyTap: (originalMessageId) {
        debugPrint('Reply tap: $originalMessageId');
        _showSnackBar('Navigating to original message: $originalMessageId');
      },
      onReaction: (messageId, emoji, action) {
        debugPrint('Reaction: $emoji ($action) on $messageId');
      },
      onMenuItemTap: (messageId, item) {
        debugPrint('Menu item: ${item.id} (${item.label}) on $messageId');
        _showSnackBar('${item.label} on message: $messageId');
        if (item.id == "select") {
          print("selectselectselectselectselect");
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
        ),
        body: VBubbleScope(
          style: _style,
          theme: theme,
          config: _buildConfig(),
          callbacks: _buildCallbacks(),
          isSelectionMode: _isSelectionMode,
          selectedIds: _selectedIds,
          customBubbleBuilders: {
            // Example: Product bubble builder
            'product': (context, messageId, isMeSender, time, data, props) {
              final productData = data as VProductData;
              return VProductBubble(
                messageId: messageId,
                isMeSender: isMeSender,
                time: time,
                productData: productData,
                status: props.status,
                isSameSender: props.isSameSender,
                avatar: props.avatar,
                senderName: props.senderName,
                senderColor: props.senderColor,
                onActionTap: () {
                  _showSnackBar('View product: ${productData.name}');
                },
              );
            },
          },
          menuItemsBuilder: (messageId, messageType, isMeSender) {
            return [...VDefaultMenuItems.textDefaults];
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return MessageBuilder.build(context, message);
            },
          ),
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
