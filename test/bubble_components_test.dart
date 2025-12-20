import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/src/core/config.dart';
import 'package:v_chat_bubbles/src/core/enums.dart';
import 'package:v_chat_bubbles/src/core/models.dart';
import 'package:v_chat_bubbles/src/theme/bubble_theme.dart';
import 'package:v_chat_bubbles/src/widgets/bubble_scope.dart';
import 'package:v_chat_bubbles/src/widgets/shared/bubble_avatar.dart';
import 'package:v_chat_bubbles/src/widgets/shared/bubble_footer.dart';
import 'package:v_chat_bubbles/src/widgets/shared/bubble_header.dart';
import 'package:v_chat_bubbles/src/widgets/shared/media_container.dart';

void main() {
  group('Bubble Component Tests', () {
    Widget createScope({required Widget child}) {
      return MaterialApp(
        home: VBubbleScope(
          theme: VBubbleTheme.telegramLight(),
          config: const VBubbleConfig(),
          child: Scaffold(body: child),
        ),
      );
    }

    testWidgets('VBubbleAvatar renders initials when no image provided',
        (tester) async {
      await tester.pumpWidget(createScope(
        child: const VBubbleAvatar(
          isMeSender: false,
          senderName: 'Alice',
          avatar: null,
        ),
      ));

      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('VBubbleAvatar renders placeholder when no name/image',
        (tester) async {
      await tester.pumpWidget(createScope(
        child: const VBubbleAvatar(
          isMeSender: false,
          senderName: null,
          avatar: null,
        ),
      ));

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('VBubbleHeader renders sender name', (tester) async {
      await tester.pumpWidget(createScope(
        child: const VBubbleHeader(
          isMeSender: false,
          senderName: 'Bob',
          forwardedFrom: null,
          replyTo: null,
        ),
      ));

      expect(find.text('Bob'), findsOneWidget);
    });

    testWidgets('VBubbleHeader renders forwarded info', (tester) async {
      await tester.pumpWidget(createScope(
        child: const VBubbleHeader(
          isMeSender: true,
          forwardedFrom: VForwardData(
            originalSenderName: 'Charlie',
            originalMessageId: '1',
          ),
          senderName: null,
          replyTo: null,
        ),
      ));

      expect(find.text('Forwarded from Charlie'), findsOneWidget);
      expect(find.byIcon(Icons.forward), findsOneWidget);
    });

    testWidgets('VBubbleFooter renders time and status', (tester) async {
      await tester.pumpWidget(createScope(
        child: const VBubbleFooter(
          isMeSender: true,
          time: '12:00 PM',
          status: VMessageStatus.read,
        ),
      ));

      expect(find.text('12:00 PM'), findsOneWidget);
      // Default theme read icon
      expect(find.byIcon(Icons.done_all), findsOneWidget);
    });

    testWidgets('VBubbleFooter renders edited label', (tester) async {
      await tester.pumpWidget(createScope(
        child: const VBubbleFooter(
          isMeSender: true,
          time: '12:00 PM',
          status: VMessageStatus.sent,
          isEdited: true,
        ),
      ));

      expect(find.text('edited'), findsOneWidget);
    });

    testWidgets('VMediaContainer renders child with constraints',
        (tester) async {
      await tester.pumpWidget(createScope(
        child: VMediaContainer(
          messageId: 'media1',
          child: Container(
            key: const Key('child'),
            color: Colors.red,
            width: 500,
            height: 500,
          ),
        ),
      ));

      expect(find.byKey(const Key('child')), findsOneWidget);
      // Verify Hero tag
      final hero = tester.widget<Hero>(find.byType(Hero));
      expect(hero.tag, 'media_media1');
      // Constraint verification is tricky in widget tests without inspecting render object,
      // but we can verify widget structure.
      expect(find.byType(ClipRRect), findsOneWidget);
    });
  });
}
