import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

void main() {
  final origin = DateTime.utc(2026, 8, 16, 10);

  VMessageGroupingInfo message(
    String senderId,
    int seconds, {
    bool breaksGroup = false,
  }) {
    return VMessageGroupingInfo(
      senderId: senderId,
      sentAt: origin.add(Duration(seconds: seconds)),
      breaksGroup: breaksGroup,
    );
  }

  group('VMessageGrouping', () {
    test('returns an empty result for an empty conversation', () {
      expect(VMessageGrouping.resolve(const []), isEmpty);
    });

    test('resolves first, middle, and last for a continuous sender run', () {
      final positions = VMessageGrouping.resolve([
        message('alice', 0),
        message('alice', 30),
        message('alice', 60),
      ]);

      expect(positions, const [
        VMessageGroupPosition.first,
        VMessageGroupPosition.middle,
        VMessageGroupPosition.last,
      ]);
    });

    test(
      'splits groups on sender, threshold, explicit break, and time order',
      () {
        final positions = VMessageGrouping.resolve([
          message('alice', 0),
          message('bob', 10),
          message('bob', 80),
          message('bob', 90, breaksGroup: true),
          message('bob', 70),
        ]);

        expect(positions, List.filled(5, VMessageGroupPosition.single));
      },
    );

    test('includes messages exactly on the configured threshold', () {
      expect(
        VMessageGrouping.resolve([message('alice', 0), message('alice', 60)]),
        const [VMessageGroupPosition.first, VMessageGroupPosition.last],
      );
    });

    test('validates the requested index and threshold', () {
      final messages = [message('alice', 0)];

      expect(() => VMessageGrouping.resolveAt(messages, 1), throwsRangeError);
      expect(
        () => VMessageGrouping.resolveAt(
          messages,
          0,
          timeThreshold: const Duration(seconds: -1),
        ),
        throwsArgumentError,
      );
    });
  });

  group('BaseBubble grouping compatibility', () {
    test('resolved position overrides the legacy same-sender flag', () {
      const bubble = VTextBubble(
        messageId: 'message-1',
        isMeSender: false,
        time: '10:00',
        text: 'Hello',
        isSameSender: false,
        groupPosition: VMessageGroupPosition.middle,
      );

      expect(bubble.isGroupedWithPrevious, isTrue);
      expect(bubble.showsGroupEnd, isFalse);
    });

    test(
      'legacy same-sender behavior remains unchanged when position is null',
      () {
        const bubble = VTextBubble(
          messageId: 'message-1',
          isMeSender: false,
          time: '10:00',
          text: 'Hello',
          isSameSender: true,
        );

        expect(bubble.isGroupedWithPrevious, isTrue);
        expect(bubble.showsGroupEnd, isFalse);
      },
    );
  });
}
