import 'package:flutter_test/flutter_test.dart';
import 'package:exmaple/main.dart';

void main() {
  testWidgets('style selector opens a chat type preview', (tester) async {
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
  });
}
