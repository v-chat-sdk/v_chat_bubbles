import 'package:flutter/material.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

class ModernFeaturesPage extends StatelessWidget {
  final VBubbleStyle style;
  final Brightness brightness;

  const ModernFeaturesPage({
    super.key,
    required this.style,
    required this.brightness,
  });

  @override
  Widget build(BuildContext context) {
    final eventStart = DateTime.now().add(const Duration(days: 2));
    final locationStart = DateTime.now().subtract(const Duration(minutes: 5));
    return Theme(
      data: ThemeData(brightness: brightness, useMaterial3: true),
      child: Scaffold(
        appBar: AppBar(title: const Text('Modern Chat Features')),
        body: VBubbleScope(
          style: style,
          config: VBubbleConfig.desktop(),
          callbacks: VBubbleCallbacks(
            onTranslationToggle: (_, _) {},
            onChecklistItemToggle: (_, _, _) {},
            onEventResponse: (_, _) {},
            onLiveLocationTap: (_, _) {},
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              const VTextBubble(
                messageId: 'translated',
                isMeSender: false,
                time: '10:01',
                text: 'Welcome to the modern chat showcase.',
                groupPosition: VMessageGroupPosition.first,
                translation: VMessageTranslationData(
                  state: VTranslationState.translated,
                  sourceLanguageCode: 'en',
                  targetLanguageCode: 'es',
                  translatedText: 'Bienvenido a la demostración del chat.',
                ),
                reactions: [
                  VBubbleReaction(
                    emoji: '🎉',
                    count: 2,
                    actors: [
                      VReactionActor(id: 'a', displayName: 'Alice'),
                      VReactionActor(id: 'b', displayName: 'Bob'),
                    ],
                  ),
                ],
              ),
              const VChecklistBubble(
                messageId: 'checklist',
                isMeSender: false,
                time: '10:02',
                groupPosition: VMessageGroupPosition.last,
                checklist: VChecklistData(
                  title: 'Release checklist',
                  canAddItems: true,
                  items: [
                    VChecklistItem(
                      id: 'tests',
                      text: 'Run the full test suite',
                      isCompleted: true,
                    ),
                    VChecklistItem(id: 'notes', text: 'Review release notes'),
                  ],
                ),
              ),
              VEventBubble(
                messageId: 'event',
                isMeSender: true,
                time: '10:03',
                event: VEventData(
                  eventId: 'demo-event',
                  title: 'Team launch call',
                  startsAt: eventStart,
                  endsAt: eventStart.add(const Duration(hours: 1)),
                  location: 'Video conference',
                  attendeeCount: 8,
                  response: VEventResponse.going,
                ),
              ),
              VLiveLocationBubble(
                messageId: 'live-location',
                isMeSender: false,
                time: '10:04',
                liveLocation: VLiveLocationData(
                  sessionId: 'demo-location',
                  latitude: 30.0444,
                  longitude: 31.2357,
                  startedAt: locationStart,
                  expiresAt: locationStart.add(const Duration(hours: 1)),
                  lastUpdatedAt: DateTime.now(),
                  address: 'Cairo, Egypt',
                ),
              ),
              const VTextBubble(
                messageId: 'rich-link',
                isMeSender: true,
                time: '10:05',
                text:
                    'Rich link previews can use compact, side, or large media.',
                lifecycle: VMessageLifecycleData(
                  stage: VMessageLifecycleStage.read,
                ),
                linkPreview: VLinkPreviewData(
                  url: 'https://flutter.dev',
                  siteName: 'Flutter',
                  authorName: 'Google',
                  title: 'Build apps for any screen',
                  description: 'A side-media-ready rich preview.',
                  layout: VLinkPreviewLayout.sideMedia,
                  isVerified: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
