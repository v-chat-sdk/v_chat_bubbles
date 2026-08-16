import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exmaple/main.dart';

void main() {
  testWidgets('style selector opens the modern feature showcase', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('v_chat_bubbles Demo'), findsOneWidget);
    expect(find.text('Select a Style'), findsOneWidget);
    expect(find.text('Telegram'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);

    await tester.tap(find.text('Preview').first);
    await tester.pumpAndSettle();

    expect(find.text('Select Chat Type'), findsOneWidget);
    expect(find.text('Direct Chat'), findsOneWidget);
    expect(find.text('Group Chat'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Modern Features'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Modern Features'), findsOneWidget);

    await tester.tap(find.text('Modern Features'));
    await tester.pumpAndSettle();
    expect(find.text('Modern Chat Features'), findsOneWidget);
    expect(find.text('Release checklist'), findsOneWidget);
  });
}
