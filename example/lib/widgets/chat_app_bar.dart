import 'package:flutter/material.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VBubbleStyle style;
  final Brightness brightness;
  final bool isSelectionMode;
  final int selectedCount;
  final VoidCallback onStyleChanged;
  final VoidCallback onBrightnessToggle;
  final VoidCallback onSelectionModeToggle;
  final VoidCallback onLocaleToggle;
  final VoidCallback? onClearSelection;
  final Locale locale;
  final String? title;
  final String? subtitle;
  final bool isGroupChat;
  const ChatAppBar({
    super.key,
    required this.style,
    required this.brightness,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onStyleChanged,
    required this.onBrightnessToggle,
    required this.onSelectionModeToggle,
    required this.onLocaleToggle,
    required this.locale,
    this.onClearSelection,
    this.title,
    this.subtitle,
    this.isGroupChat = true,
  });
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    if (isSelectionMode) {
      return AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClearSelection ?? onSelectionModeToggle,
          tooltip: 'Exit selection',
        ),
        title: Text('$selectedCount selected'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: selectedCount > 0 ? () {} : null,
            tooltip: 'Delete selected',
          ),
          IconButton(
            icon: const Icon(Icons.forward),
            onPressed: selectedCount > 0 ? () {} : null,
            tooltip: 'Forward selected',
          ),
        ],
      );
    }
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: _getStyleColor(style).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isGroupChat ? Icons.group : Icons.person,
              color: _getStyleColor(style),
              size: 22,
            ),
          ),
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      title ?? _getStyleName(style),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStyleColor(style).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStyleIcon(style),
                            size: 12,
                            color: _getStyleColor(style),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            _getStyleName(style),
                            style: TextStyle(
                              fontSize: 10,
                              color: _getStyleColor(style),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Style selector
        PopupMenuButton<VBubbleStyle>(
          icon: const Icon(Icons.palette_outlined),
          tooltip: 'Change style',
          onSelected: (_) => onStyleChanged(),
          itemBuilder: (context) => [
            _buildStyleItem(
              context,
              VBubbleStyle.telegram,
              Icons.send,
              'Telegram',
            ),
            _buildStyleItem(
              context,
              VBubbleStyle.whatsapp,
              Icons.chat,
              'WhatsApp',
            ),
            _buildStyleItem(
              context,
              VBubbleStyle.messenger,
              Icons.messenger_outline,
              'Messenger',
            ),
            _buildStyleItem(
              context,
              VBubbleStyle.imessage,
              Icons.message,
              'iMessage',
            ),
          ],
        ),
        // Theme toggle
        IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: onBrightnessToggle,
          tooltip: isDark ? 'Light mode' : 'Dark mode',
        ),
        // Selection mode toggle
        IconButton(
          icon: Icon(
            isSelectionMode ? Icons.check_box : Icons.check_box_outline_blank,
          ),
          onPressed: onSelectionModeToggle,
          tooltip: 'Selection mode',
        ),
        // Locale toggle
        TextButton(
          onPressed: onLocaleToggle,
          child: Text(
            locale.languageCode.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  PopupMenuItem<VBubbleStyle> _buildStyleItem(
    BuildContext context,
    VBubbleStyle itemStyle,
    IconData icon,
    String name,
  ) {
    final isSelected = itemStyle == style;
    return PopupMenuItem(
      value: itemStyle,
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _getStyleColor(itemStyle).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: _getStyleColor(itemStyle)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          if (isSelected)
            Icon(Icons.check, size: 18, color: _getStyleColor(itemStyle)),
        ],
      ),
    );
  }

  IconData _getStyleIcon(VBubbleStyle style) {
    switch (style) {
      case VBubbleStyle.telegram:
        return Icons.send;
      case VBubbleStyle.whatsapp:
        return Icons.chat;
      case VBubbleStyle.messenger:
        return Icons.messenger_outline;
      case VBubbleStyle.imessage:
        return Icons.message;
      case VBubbleStyle.custom:
        return Icons.brush;
    }
  }

  String _getStyleName(VBubbleStyle style) {
    switch (style) {
      case VBubbleStyle.telegram:
        return 'Telegram';
      case VBubbleStyle.whatsapp:
        return 'WhatsApp';
      case VBubbleStyle.messenger:
        return 'Messenger';
      case VBubbleStyle.imessage:
        return 'iMessage';
      case VBubbleStyle.custom:
        return 'Custom';
    }
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
