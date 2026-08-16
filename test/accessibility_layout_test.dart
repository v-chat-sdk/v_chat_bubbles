import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

void main() {
  Widget scoped(
    Widget child, {
    VBubbleConfig config = const VBubbleConfig(),
    TextDirection direction = TextDirection.ltr,
  }) {
    return MaterialApp(
      home: Directionality(
        textDirection: direction,
        child: VBubbleScope(
          config: config,
          child: Scaffold(body: child),
        ),
      ),
    );
  }

  testWidgets('bubble exposes one descriptive screen-reader node', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      scoped(
        const VTextBubble(
          messageId: 'message-1',
          isMeSender: true,
          time: '12:00',
          text: 'Accessible message',
          status: VMessageStatus.read,
          isEdited: true,
        ),
      ),
    );

    expect(
      find.bySemanticsLabel(RegExp(r'Sent text message.*12:00.*read.*edited')),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('enhanced accessibility renders a high-contrast outline', (
    tester,
  ) async {
    await tester.pumpWidget(
      scoped(
        const VTextBubble(
          messageId: 'message-1',
          isMeSender: false,
          time: '12:00',
          text: 'High contrast',
        ),
        config: VBubbleConfig.accessible(),
      ),
    );

    final hasTwoPixelBorder = tester
        .widgetList<DecoratedBox>(find.byType(DecoratedBox))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .any((decoration) {
          final border = decoration.border;
          return border is Border && border.top.width == 2;
        });
    expect(hasTwoPixelBorder, isTrue);
  });

  testWidgets('RTL mirrors incoming and outgoing alignment without overflow', (
    tester,
  ) async {
    await tester.pumpWidget(
      scoped(
        const Column(
          children: [
            VTextBubble(
              messageId: 'outgoing',
              isMeSender: true,
              time: '12:00',
              text: 'Outgoing RTL',
            ),
            VTextBubble(
              messageId: 'incoming',
              isMeSender: false,
              time: '12:01',
              text: 'Incoming RTL',
            ),
          ],
        ),
        direction: TextDirection.rtl,
      ),
    );

    final outgoing = find.byWidgetPredicate(
      (widget) =>
          widget is RichText &&
          widget.text.toPlainText().contains('Outgoing RTL'),
    );
    final incoming = find.byWidgetPredicate(
      (widget) =>
          widget is RichText &&
          widget.text.toPlainText().contains('Incoming RTL'),
    );
    final outgoingX = tester.getTopLeft(outgoing).dx;
    final incomingX = tester.getTopLeft(incoming).dx;
    expect(outgoingX, lessThan(incomingX));
    expect(tester.takeException(), isNull);
  });
}
