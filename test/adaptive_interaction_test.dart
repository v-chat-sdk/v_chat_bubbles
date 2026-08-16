import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

void main() {
  Widget buildInteraction({
    VoidCallback? onActivate,
    VoidCallback? onReply,
    VoidCallback? onReact,
    ValueChanged<Offset>? onShowContextMenu,
    double minTapTargetSize = 48,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: VAdaptiveBubbleInteraction(
            messageId: 'message-1',
            isMeSender: true,
            enableHoverActions: true,
            enableSecondaryTap: true,
            enableKeyboardShortcuts: true,
            minTapTargetSize: minTapTargetSize,
            fadeInDuration: const Duration(milliseconds: 10),
            fadeOutDuration: const Duration(milliseconds: 20),
            replyLabel: 'Reply',
            retryLabel: 'Retry',
            onActivate: onActivate,
            onReply: onReply,
            onReact: onReact,
            onShowContextMenu: onShowContextMenu,
            child: const ColoredBox(
              key: Key('bubble-child'),
              color: Colors.transparent,
              child: SizedBox(width: 160, height: 64),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('reveals accessible pointer actions on hover', (tester) async {
    var replies = 0;
    var reactions = 0;
    await tester.pumpWidget(
      buildInteraction(
        onReply: () => replies++,
        onReact: () => reactions++,
        minTapTargetSize: 56,
      ),
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byKey(const Key('bubble-child'))));
    await tester.pumpAndSettle();

    final replyButton = find.byKey(const ValueKey('v-bubble-reply-message-1'));
    final reactButton = find.byKey(const ValueKey('v-bubble-react-message-1'));
    expect(replyButton, findsOneWidget);
    expect(reactButton, findsOneWidget);
    expect(tester.getSize(replyButton), const Size(56, 56));

    await tester.tap(replyButton);
    await tester.tap(reactButton);
    expect(replies, 1);
    expect(reactions, 1);
    await mouse.removePointer();
  });

  testWidgets('supports keyboard activation, reply, and context menu', (
    tester,
  ) async {
    var activations = 0;
    var replies = 0;
    var menuRequests = 0;
    await tester.pumpWidget(
      buildInteraction(
        onActivate: () => activations++,
        onReply: () => replies++,
        onShowContextMenu: (_) => menuRequests++,
      ),
    );

    await tester.tap(find.byKey(const Key('bubble-child')));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyR);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.alt);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
    await tester.sendKeyEvent(LogicalKeyboardKey.f10);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);

    expect(activations, 1);
    expect(replies, 1);
    expect(menuRequests, 1);
  });

  testWidgets('routes secondary click to the context menu callback', (
    tester,
  ) async {
    Offset? requestedPosition;
    await tester.pumpWidget(
      buildInteraction(
        onShowContextMenu: (position) => requestedPosition = position,
      ),
    );

    await tester.tap(
      find.byKey(const Key('bubble-child')),
      buttons: kSecondaryMouseButton,
    );

    expect(requestedPosition, isNotNull);
    expect(requestedPosition!.dx, greaterThan(0));
  });

  test('gesture presets include adaptive interaction behavior', () {
    expect(VGestureConfig.all.enableHoverActions, isTrue);
    expect(VGestureConfig.all.enableSecondaryTap, isTrue);
    expect(VGestureConfig.all.enableKeyboardShortcuts, isTrue);
    expect(VGestureConfig.none.enableHoverActions, isFalse);
    expect(VGestureConfig.none.enableSecondaryTap, isFalse);
    expect(VGestureConfig.none.enableKeyboardShortcuts, isFalse);
  });
}
