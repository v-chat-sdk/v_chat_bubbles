import 'package:flutter/material.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';
import 'chat_demo_page.dart';

class ChatTypeSelectorPage extends StatelessWidget {
  final VBubbleStyle style;
  final Brightness brightness;
  final Locale locale;
  final ValueChanged<Brightness> onBrightnessChanged;
  final ValueChanged<Locale> onLocaleChanged;
  const ChatTypeSelectorPage({
    super.key,
    required this.style,
    required this.brightness,
    required this.locale,
    required this.onBrightnessChanged,
    required this.onLocaleChanged,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    final styleColor = _getStyleColor(style);
    return Theme(
      data: ThemeData(
        brightness: brightness,
        colorSchemeSeed: styleColor,
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_getStyleIcon(style), size: 20),
              const SizedBox(width: 8),
              Text(_getStyleName(style)),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => onBrightnessChanged(
                isDark ? Brightness.light : Brightness.dark,
              ),
              tooltip: isDark ? 'Light mode' : 'Dark mode',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Chat Type',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose the type of chat to preview',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Column(
                  children: [
                    _ChatTypeCard(
                      title: 'Direct Chat',
                      subtitle: 'One-to-one conversation',
                      description:
                          'Clean layout without avatars or sender names. '
                          'Perfect for private messaging between two people.',
                      icon: Icons.person,
                      color: styleColor,
                      features: const [
                        'No avatars displayed',
                        'No sender names',
                        'Compact bubble spacing',
                        'Simple status indicators',
                      ],
                      onTap: () => _navigateToChat(context, isGroupChat: false),
                    ),
                    const SizedBox(height: 16),
                    _ChatTypeCard(
                      title: 'Group Chat',
                      subtitle: 'Multi-user conversation',
                      description:
                          'Full-featured layout with avatars and sender names. '
                          'Ideal for team or group discussions.',
                      icon: Icons.group,
                      color: styleColor,
                      features: const [
                        'Avatars for each sender',
                        'Colored sender names',
                        'Reply previews',
                        'Message reactions',
                      ],
                      onTap: () => _navigateToChat(context, isGroupChat: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToChat(BuildContext context, {required bool isGroupChat}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatDemoPage(
          initialStyle: style,
          initialBrightness: brightness,
          initialLocale: locale,
          isGroupChat: isGroupChat,
          onBrightnessChanged: onBrightnessChanged,
          onLocaleChanged: onLocaleChanged,
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
}

class _ChatTypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> features;
  final VoidCallback onTap;
  const _ChatTypeCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.features,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: features.map((feature) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 14, color: color),
                          const SizedBox(width: 4),
                          Text(
                            feature,
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(color: color),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
