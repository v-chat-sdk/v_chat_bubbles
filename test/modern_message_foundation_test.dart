import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

void main() {
  Widget scoped(
    Widget child, {
    VBubbleConfig config = const VBubbleConfig(),
    VBubbleCallbacks callbacks = const VBubbleCallbacks(),
  }) {
    return MaterialApp(
      home: VBubbleScope(
        config: config,
        callbacks: callbacks,
        child: Scaffold(body: Center(child: child)),
      ),
    );
  }

  test('modern message models use value equality', () {
    const translation = VMessageTranslationData(
      state: VTranslationState.translated,
      sourceLanguageCode: 'en',
      targetLanguageCode: 'ar',
      translatedText: 'مرحبا',
    );
    const transcript = VVoiceTranscriptData(
      state: VTranscriptState.ready,
      text: 'Hello',
      segments: [VTranscriptSegment(start: Duration.zero, text: 'Hello')],
    );
    const checklist = VChecklistData(
      title: 'Launch',
      items: [VChecklistItem(id: '1', text: 'Verify')],
    );
    final now = DateTime.utc(2026, 8, 16, 12);
    final liveLocation = VLiveLocationData(
      sessionId: 'location-1',
      latitude: 30.0444,
      longitude: 31.2357,
      startedAt: now,
      expiresAt: now.add(const Duration(hours: 1)),
      lastUpdatedAt: now,
      trail: [
        VLocationPoint(latitude: 30.0444, longitude: 31.2357, recordedAt: now),
      ],
    );

    expect(
      translation,
      equals(
        const VMessageTranslationData(
          state: VTranslationState.translated,
          sourceLanguageCode: 'en',
          targetLanguageCode: 'ar',
          translatedText: 'مرحبا',
        ),
      ),
    );
    expect(
      transcript,
      equals(
        const VVoiceTranscriptData(
          state: VTranscriptState.ready,
          text: 'Hello',
          segments: [VTranscriptSegment(start: Duration.zero, text: 'Hello')],
        ),
      ),
    );
    expect(
      checklist,
      equals(
        const VChecklistData(
          title: 'Launch',
          items: [VChecklistItem(id: '1', text: 'Verify')],
        ),
      ),
    );
    expect(
      liveLocation,
      equals(
        VLiveLocationData(
          sessionId: 'location-1',
          latitude: 30.0444,
          longitude: 31.2357,
          startedAt: now,
          expiresAt: now.add(const Duration(hours: 1)),
          lastUpdatedAt: now,
          trail: [
            VLocationPoint(
              latitude: 30.0444,
              longitude: 31.2357,
              recordedAt: now,
            ),
          ],
        ),
      ),
    );
  });

  group('message lifecycle', () {
    test('summarizes per-recipient receipts and retry state', () {
      final now = DateTime.utc(2026, 8, 16, 12);
      final lifecycle = VMessageLifecycleData(
        stage: VMessageLifecycleStage.error,
        retryCount: 2,
        errorMessage: 'Network unavailable',
        receipts: [
          VMessageReceipt(
            recipientId: 'alice',
            stage: VMessageLifecycleStage.read,
            occurredAt: now,
          ),
          VMessageReceipt(
            recipientId: 'bob',
            stage: VMessageLifecycleStage.delivered,
            occurredAt: now,
          ),
        ],
      );

      expect(lifecycle.canRetry, isTrue);
      expect(lifecycle.readRecipientCount, 1);
      expect(lifecycle.deliveredRecipientCount, 2);
      expect(lifecycle.semanticLabel, contains('2 retries'));
    });

    testWidgets('footer renders queued lifecycle state with details', (
      tester,
    ) async {
      const lifecycle = VMessageLifecycleData(
        stage: VMessageLifecycleStage.queued,
      );
      await tester.pumpWidget(
        scoped(
          const VBubbleFooter(
            isMeSender: true,
            time: '12:00',
            lifecycle: lifecycle,
          ),
        ),
      );

      expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      expect(tooltip.message, contains('queued'));
    });
  });

  group('protected content', () {
    testWidgets('spoiler reveals once and notifies its owner', (tester) async {
      var reveals = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                const SizedBox.expand(),
                VProtectedContentOverlay(
                  protection: const VContentProtectionData.spoiler(),
                  onReveal: () => reveals++,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Tap to reveal'), findsOneWidget);
      await tester.tap(find.text('Tap to reveal'));
      await tester.pump();
      expect(reveals, 1);
      expect(find.text('Tap to reveal'), findsNothing);
    });

    testWidgets('consumed view-once content cannot be revealed', (
      tester,
    ) async {
      var reveals = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                const SizedBox.expand(),
                VProtectedContentOverlay(
                  protection: VContentProtectionData.viewOnce(
                    viewedAt: DateTime.utc(2026),
                  ),
                  onReveal: () => reveals++,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Already viewed'), findsOneWidget);
      await tester.tap(find.text('Already viewed'), warnIfMissed: false);
      expect(reveals, 0);
    });
  });

  group('reactions and replies', () {
    testWidgets('reaction pills expose actors and collapse overflow', (
      tester,
    ) async {
      VBubbleReaction? selectedReaction;
      const reaction = VBubbleReaction(
        emoji: '❤️',
        count: 2,
        actors: [
          VReactionActor(id: 'alice', displayName: 'Alice'),
          VReactionActor(id: 'bob', displayName: 'Bob'),
        ],
      );
      await tester.pumpWidget(
        scoped(
          VTextBubble(
            messageId: 'message-1',
            isMeSender: true,
            time: '12:00',
            text: 'Hello',
            reactions: const [
              reaction,
              VBubbleReaction(emoji: '👍'),
              VBubbleReaction(emoji: '🎉'),
            ],
          ),
          config: const VBubbleConfig(
            contextMenu: VContextMenuConfig(maxVisibleReactionPills: 2),
          ),
          callbacks: VBubbleCallbacks(
            onReactionDetailsTap: (_, value, _) => selectedReaction = value,
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey('v-reaction-overflow-message-1')),
        findsOneWidget,
      );
      await tester.tap(find.text('❤️'));
      expect(selectedReaction, reaction);
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip).first);
      expect(tooltip.message, 'Alice, Bob');
    });

    testWidgets('selective quote, nested reply, and thread remain actionable', (
      tester,
    ) async {
      String? openedThread;
      const reply = VReplyData(
        originalMessageId: 'original-1',
        senderId: 'alice',
        senderName: 'Alice',
        previewText: 'The entire original message',
        quoteRange: VReplyQuoteRange(start: 4, end: 15, text: 'selected text'),
        parentReply: VReplyData(
          originalMessageId: 'parent-1',
          senderId: 'bob',
          senderName: 'Bob',
          previewText: 'Parent context',
        ),
        threadSummary: VThreadSummary(threadId: 'thread-1', replyCount: 4),
      );
      await tester.pumpWidget(
        scoped(
          VBubbleHeader(
            isMeSender: true,
            replyTo: reply,
            callbacks: VBubbleCallbacks(
              onThreadTap: (threadId) => openedThread = threadId,
            ),
          ),
        ),
      );

      expect(find.text('selected text'), findsOneWidget);
      expect(find.text('↳ Bob: Parent context'), findsOneWidget);
      expect(find.text('4 replies'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('v-thread-thread-1')));
      expect(openedThread, 'thread-1');
    });
  });
}
