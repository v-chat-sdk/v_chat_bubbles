import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

void main() {
  group('VBubbleTheme', () {
    test('Telegram light theme should have correct outgoing bubble color', () {
      final theme = VBubbleTheme.telegramLight();
      expect(theme.outgoingBubbleColor.toARGB32(), 0xFFEEFFDE);
    });
    test('WhatsApp light theme should have correct outgoing bubble color', () {
      final theme = VBubbleTheme.whatsappLight();
      expect(theme.outgoingBubbleColor.toARGB32(), 0xFFD9FDD3);
    });
    test('Messenger light theme should have correct outgoing bubble color', () {
      final theme = VBubbleTheme.messengerLight();
      expect(theme.outgoingBubbleColor.toARGB32(), 0xFF0084FF);
    });
    test('iMessage light theme should have correct outgoing bubble color', () {
      final theme = VBubbleTheme.imessageLight();
      expect(theme.outgoingBubbleColor.toARGB32(), 0xFF007AFF);
    });
  });
  group('VMessageStatus', () {
    test('Should have all expected status values', () {
      expect(VMessageStatus.values.length, 5);
      expect(VMessageStatus.values.contains(VMessageStatus.sending), true);
      expect(VMessageStatus.values.contains(VMessageStatus.sent), true);
      expect(VMessageStatus.values.contains(VMessageStatus.delivered), true);
      expect(VMessageStatus.values.contains(VMessageStatus.read), true);
      expect(VMessageStatus.values.contains(VMessageStatus.error), true);
    });
  });
  group('VBubbleStyle', () {
    test('Should have all expected style values', () {
      expect(VBubbleStyle.values.length, 5);
      expect(VBubbleStyle.values.contains(VBubbleStyle.telegram), true);
      expect(VBubbleStyle.values.contains(VBubbleStyle.whatsapp), true);
      expect(VBubbleStyle.values.contains(VBubbleStyle.messenger), true);
      expect(VBubbleStyle.values.contains(VBubbleStyle.imessage), true);
      expect(VBubbleStyle.values.contains(VBubbleStyle.custom), true);
    });
  });
  group('VBubbleConfig', () {
    test('Default config should have expected values', () {
      const config = VBubbleConfig();
      expect(config.avatar.show, true);
      expect(config.gestures.enableSwipeToReply, true);
      expect(config.gestures.enableLongPress, true);
      expect(config.sizing.maxWidthFraction, 0.75);
    });
    test('copyWith should work correctly', () {
      const config = VBubbleConfig();
      final updated = config.copyWith(avatar: const VAvatarConfig(show: false));
      expect(updated.avatar.show, false);
      expect(updated.gestures.enableSwipeToReply, true);
    });
  });
}
