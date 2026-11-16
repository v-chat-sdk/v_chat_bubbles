import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

void main() {
  for (final direction in TextDirection.values) {
    for (final isMe in [false, true]) {
      for (final scale in [1.3, 2.0]) {
        testWidgets(
          'file metadata fits 320px at $scale, $direction, sender $isMe',
          (tester) async {
            tester.view.devicePixelRatio = 1;
            tester.view.physicalSize = const Size(320, 640);
            addTearDown(tester.view.resetDevicePixelRatio);
            addTearDown(tester.view.resetPhysicalSize);
            const extension = 'AVERYLONGCUSTOMDOCUMENTEXTENSION';
            const filename =
                'Quarterly financial report.averylongcustomdocumentextension';
            await tester.pumpWidget(
              MaterialApp(
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(scale)),
                  child: Directionality(
                    textDirection: direction,
                    child: child!,
                  ),
                ),
                home: VBubbleScope(
                  child: Scaffold(
                    body: VFileBubble(
                      messageId: 'file',
                      isMeSender: isMe,
                      time: '12:30',
                      status: VMessageStatus.read,
                      file: VPlatformFile.fromBytes(
                        name: filename,
                        bytes: List.filled(1024, 0),
                      ),
                    ),
                  ),
                ),
              ),
            );
            expect(tester.takeException(), isNull);
            expect(find.text(filename), findsOneWidget);
            final metadata = find.text(extension);
            final label = tester.widget<Text>(metadata);
            expect(label.maxLines, 1);
            expect(label.overflow, TextOverflow.ellipsis);
            final wrap = find
                .ancestor(of: metadata, matching: find.byType(Wrap))
                .first;
            final metadataRect = tester.getRect(wrap);
            final footerRect = tester.getRect(find.text('12:30'));
            final bubbleRect = tester.getRect(find.byType(VFileBubble));
            expect(metadataRect.left, greaterThanOrEqualTo(bubbleRect.left));
            expect(metadataRect.right, lessThanOrEqualTo(bubbleRect.right));
            expect(footerRect.left, greaterThanOrEqualTo(bubbleRect.left));
            expect(footerRect.right, lessThanOrEqualTo(bubbleRect.right));
            expect(metadataRect.overlaps(footerRect), isFalse);
            expect(footerRect.bottom, closeTo(metadataRect.bottom, 3));
          },
        );
      }
    }
  }
}
