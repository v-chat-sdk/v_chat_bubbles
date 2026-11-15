import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

Widget fileApp(VoidCallback open) => MaterialApp(
  home: Scaffold(
    body: VBubbleScope(
      callbacks: VBubbleCallbacks(
        onTap: (_) => open(),
        onMediaTap: (_) => open(),
      ),
      child: VFileBubble(
        messageId: 'qa',
        isMeSender: true,
        time: '12:00',
        transferState: VTransferState.completed,
        file: VPlatformFile.fromBytes(name: 'qa.txt', bytes: [65, 66]),
      ),
    ),
  ),
);
void main() {
  _testWithSemantics('file bubble opens with a physical pointer tap', (
    tester,
  ) async {
    var opened = 0;
    await tester.pumpWidget(fileApp(() => opened++));
    await tester.tap(find.text('qa.txt'));
    await tester.pumpAndSettle();
    expect(opened, 1);
  });
  _testWithSemantics('file bubble semantic button exposes an actionable tap', (
    tester,
  ) async {
    var opened = 0;
    await tester.pumpWidget(fileApp(() => opened++));
    final node = tester.getSemantics(find.byType(VFileBubble));
    final data = node.getSemanticsData();
    expect(
      data.hasAction(ui.SemanticsAction.tap),
      isTrue,
      reason:
          'The exposed file button has label ${data.label} but no accessible tap action.',
    );
    node.owner!.performAction(node.id, ui.SemanticsAction.tap);
    await tester.pump();
    expect(opened, 1);
  });
  _testWithSemantics('file bubble exposes its filename to accessibility', (
    tester,
  ) async {
    await tester.pumpWidget(fileApp(() {}));
    final label = tester
        .getSemantics(find.byType(VFileBubble))
        .getSemanticsData()
        .label;
    expect(label, contains('qa.txt'));
  });
  _testWithSemantics(
    'text bubble exposes its message content to accessibility',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VBubbleScope(
              child: VTextBubble(
                messageId: 'text',
                isMeSender: false,
                time: '12:00',
                text: 'Meet at the north entrance',
              ),
            ),
          ),
        ),
      );
      final label = tester
          .getSemantics(find.byType(VTextBubble))
          .getSemanticsData()
          .label;
      expect(label, contains('Meet at the north entrance'));
    },
  );
}

void _testWithSemantics(
  String description,
  Future<void> Function(WidgetTester) body,
) {
  testWidgets(description, (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await body(tester);
    } finally {
      handle.dispose();
    }
  });
}
