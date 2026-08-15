import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

void main() {
  Widget buildSubject({
    required String text,
    VLinkPreviewData? linkPreview,
    double width = 180,
  }) {
    return MaterialApp(
      home: VBubbleScope(
        theme: VBubbleTheme.telegramLight(),
        config: const VBubbleConfig(),
        child: Scaffold(
          body: Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: width,
              child: VTextBubble(
                key: const ValueKey('text-bubble'),
                messageId: 'message-1',
                isMeSender: true,
                time: '10:26',
                status: VMessageStatus.read,
                text: text,
                linkPreview: linkPreview,
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('text and timestamp do not overlap at constrained widths', (
    tester,
  ) async {
    const message = 'A message that wraps onto more than one line';
    await tester.pumpWidget(buildSubject(text: message, width: 170));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final bubble = find.byKey(const ValueKey('text-bubble'));
    final text = find.descendant(
      of: bubble,
      matching: find.text(message, findRichText: true),
    );
    final timestamp = find.descendant(of: bubble, matching: find.text('10:26'));
    expect(text, findsOneWidget);
    expect(timestamp, findsOneWidget);
    expect(tester.getRect(text).overlaps(tester.getRect(timestamp)), isFalse);
  });

  testWidgets('link preview keeps message metadata visible', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        text: 'Read the Flutter docs',
        width: 240,
        linkPreview: const VLinkPreviewData(
          url: 'https://flutter.dev',
          siteName: 'flutter.dev',
          title: 'Flutter',
          description: 'Build apps for any screen.',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Flutter'), findsOneWidget);
    expect(find.text('Build apps for any screen.'), findsOneWidget);
    expect(find.text('10:26'), findsOneWidget);
  });
}
