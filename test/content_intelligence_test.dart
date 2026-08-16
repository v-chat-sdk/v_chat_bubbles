import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

void main() {
  Widget scoped(
    Widget child, {
    VBubbleCallbacks callbacks = const VBubbleCallbacks(),
    bool reduceMotion = false,
  }) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          size: const Size(800, 600),
          disableAnimations: reduceMotion,
        ),
        child: VBubbleScope(
          callbacks: callbacks,
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    );
  }

  testWidgets('translated text is visible and toggle remains controlled', (
    tester,
  ) async {
    bool? requestedVisibility;
    await tester.pumpWidget(
      scoped(
        const VTranslatedTextPanel(
          messageId: 'message-1',
          translation: VMessageTranslationData(
            state: VTranslationState.translated,
            sourceLanguageCode: 'en',
            targetLanguageCode: 'ar',
            translatedText: 'مرحبا بالعالم',
          ),
          textColor: Colors.black,
        ),
        callbacks: VBubbleCallbacks(
          onTranslationToggle: (_, visible) => requestedVisibility = visible,
        ),
      ),
    );

    expect(find.text('EN → AR'), findsOneWidget);
    expect(find.text('مرحبا بالعالم'), findsOneWidget);
    await tester.tap(find.text('Original'));
    expect(requestedVisibility, isFalse);
  });

  testWidgets('voice transcript exposes time-aligned segment callbacks', (
    tester,
  ) async {
    Duration? selectedStart;
    await tester.pumpWidget(
      scoped(
        const VVoiceTranscriptPanel(
          messageId: 'voice-1',
          transcript: VVoiceTranscriptData(
            state: VTranscriptState.ready,
            text: 'Welcome to the call',
            isExpanded: true,
            segments: [
              VTranscriptSegment(
                start: Duration(seconds: 12),
                text: 'Welcome to the call',
              ),
            ],
          ),
          textColor: Colors.black,
        ),
        callbacks: VBubbleCallbacks(
          onTranscriptSegmentTap: (_, start) => selectedStart = start,
        ),
      ),
    );

    expect(find.text('0:12  Welcome to the call'), findsOneWidget);
    await tester.tap(find.text('0:12  Welcome to the call'));
    expect(selectedStart, const Duration(seconds: 12));
  });

  testWidgets(
    'animated media respects reduced motion until explicitly played',
    (tester) async {
      final image = _transparentPng();
      bool? isPlaying;
      await tester.pumpWidget(
        scoped(
          VAnimatedMediaSurface(
            messageId: 'gif-1',
            animatedFile: image,
            previewFile: image,
            width: 120,
            height: 80,
            onPlaybackChanged: (value) => isPlaying = value,
          ),
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('v-animated-media-gif-1')));
      await tester.pump();
      expect(isPlaying, isTrue);
      expect(find.byIcon(Icons.play_arrow_rounded), findsNothing);
    },
  );

  testWidgets('GIF and animated sticker expose dedicated playback surfaces', (
    tester,
  ) async {
    final image = _transparentPng();
    await tester.pumpWidget(
      scoped(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VGifBubble(
              messageId: 'gif-message',
              isMeSender: true,
              time: '12:00',
              gifFile: image,
              previewFile: image,
              width: 120,
              height: 80,
              autoplay: false,
            ),
            VStickerBubble(
              messageId: 'sticker-message',
              isMeSender: false,
              time: '12:01',
              stickerFile: image,
              previewFile: image,
              isAnimated: true,
              autoplay: false,
              size: 80,
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('GIF'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('v-animated-media-gif-message')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('v-animated-media-sticker-message')),
      findsOneWidget,
    );
  });

  testWidgets('rich link preview supports compact and side-media layouts', (
    tester,
  ) async {
    await tester.pumpWidget(
      scoped(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            VLinkPreviewWidget(
              linkPreview: VLinkPreviewData(
                url: 'https://example.com/compact',
                displayUrl: 'example.com',
                title: 'Compact preview',
                layout: VLinkPreviewLayout.compact,
                isVerified: true,
              ),
              linkColor: Colors.blue,
              textColor: Colors.black,
              isMeSender: false,
              messageId: 'link-1',
            ),
            VLinkPreviewWidget(
              linkPreview: VLinkPreviewData(
                url: 'https://example.com/side',
                siteName: 'Example',
                authorName: 'V Chat',
                title: 'Side preview',
                description: 'A richer preview without media.',
                layout: VLinkPreviewLayout.sideMedia,
              ),
              linkColor: Colors.blue,
              textColor: Colors.black,
              isMeSender: false,
              messageId: 'link-2',
            ),
          ],
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey('v-link-preview-compact')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('v-link-preview-sideMedia')),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.verified_rounded), findsOneWidget);
    expect(find.text('V Chat'), findsOneWidget);
  });
}

VPlatformFile _transparentPng() {
  return VPlatformFile.fromBytes(
    name: 'transparent.png',
    bytes: base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk'
      '/wcAAusB9Wl2nWQAAAAASUVORK5CYII=',
    ),
  );
}
