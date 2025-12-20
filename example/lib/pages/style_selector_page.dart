import 'package:flutter/material.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';
import 'chat_type_selector_page.dart';

class StyleSelectorPage extends StatelessWidget {
  final Brightness brightness;
  final Locale locale;
  final ValueChanged<Brightness> onBrightnessChanged;
  final ValueChanged<Locale> onLocaleChanged;
  const StyleSelectorPage({
    super.key,
    required this.brightness,
    required this.locale,
    required this.onBrightnessChanged,
    required this.onLocaleChanged,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = brightness == Brightness.dark;
    return Theme(
      data: ThemeData(
        brightness: brightness,
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('v_chat_bubbles Demo'),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => onBrightnessChanged(
                isDark ? Brightness.light : Brightness.dark,
              ),
              tooltip: isDark ? 'Light mode' : 'Dark mode',
            ),
            TextButton(
              onPressed: () => onLocaleChanged(
                locale.languageCode == 'en'
                    ? const Locale('ar')
                    : const Locale('en'),
              ),
              child: Text(
                locale.languageCode.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select a Style',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose a messaging style to preview chat bubbles',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _StyleCard(
                      style: VBubbleStyle.telegram,
                      name: 'Telegram',
                      icon: Icons.send,
                      color: const Color(0xFF0088CC),
                      description: 'Rounded bubbles with subtle gradients',
                      brightness: brightness,
                      locale: locale,
                      onBrightnessChanged: onBrightnessChanged,
                      onLocaleChanged: onLocaleChanged,
                    ),
                    _StyleCard(
                      style: VBubbleStyle.whatsapp,
                      name: 'WhatsApp',
                      icon: Icons.chat,
                      color: const Color(0xFF25D366),
                      description: 'Classic green with pointed tails',
                      brightness: brightness,
                      locale: locale,
                      onBrightnessChanged: onBrightnessChanged,
                      onLocaleChanged: onLocaleChanged,
                    ),
                    _StyleCard(
                      style: VBubbleStyle.messenger,
                      name: 'Messenger',
                      icon: Icons.messenger_outline,
                      color: const Color(0xFF0084FF),
                      description: 'Gradient bubbles with modern feel',
                      brightness: brightness,
                      locale: locale,
                      onBrightnessChanged: onBrightnessChanged,
                      onLocaleChanged: onLocaleChanged,
                    ),
                    _StyleCard(
                      style: VBubbleStyle.imessage,
                      name: 'iMessage',
                      icon: Icons.message,
                      color: const Color(0xFF007AFF),
                      description: 'Clean iOS-style minimal design',
                      brightness: brightness,
                      locale: locale,
                      onBrightnessChanged: onBrightnessChanged,
                      onLocaleChanged: onLocaleChanged,
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
}

class _StyleCard extends StatelessWidget {
  final VBubbleStyle style;
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  final Brightness brightness;
  final Locale locale;
  final ValueChanged<Brightness> onBrightnessChanged;
  final ValueChanged<Locale> onLocaleChanged;
  const _StyleCard({
    required this.style,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.brightness,
    required this.locale,
    required this.onBrightnessChanged,
    required this.onLocaleChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToChatTypeSelector(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.tonal(
                onPressed: () => _navigateToChatTypeSelector(context),
                style: FilledButton.styleFrom(
                  backgroundColor: color.withValues(alpha: 0.15),
                  foregroundColor: color,
                ),
                child: const Text('Preview'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToChatTypeSelector(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatTypeSelectorPage(
          style: style,
          brightness: brightness,
          locale: locale,
          onBrightnessChanged: onBrightnessChanged,
          onLocaleChanged: onLocaleChanged,
        ),
      ),
    );
  }
}
