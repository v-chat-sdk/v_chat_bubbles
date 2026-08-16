import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

void main() {
  Widget scoped(
    Widget child, {
    VBubbleCallbacks callbacks = const VBubbleCallbacks(),
  }) {
    return MaterialApp(
      home: VBubbleScope(
        callbacks: callbacks,
        child: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  testWidgets('shared album renders quality and add-media action', (
    tester,
  ) async {
    String? collectionId;
    await tester.pumpWidget(
      scoped(
        VGalleryBubble(
          messageId: 'gallery-1',
          isMeSender: true,
          time: '12:00',
          items: [
            VGalleryItemData(
              messageId: 'image-1',
              file: _transparentPng(),
              time: '12:00',
            ),
          ],
          collection: const VMediaCollectionData(
            collectionId: 'summer-2026',
            title: 'Summer trip',
            totalItemCount: 8,
            quality: VMediaQuality.highDefinition,
            canAddItems: true,
            contributors: [VReactionActor(id: 'alice', displayName: 'Alice')],
          ),
        ),
        callbacks: VBubbleCallbacks(
          onMediaCollectionAdd: (_, value) => collectionId = value,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Summer trip'), findsOneWidget);
    expect(find.text('HD'), findsOneWidget);
    expect(find.textContaining('8 items'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('v-media-collection-add-summer-2026')),
    );
    expect(collectionId, 'summer-2026');
  });

  testWidgets('checklist reports controlled item and add actions', (
    tester,
  ) async {
    String? toggledItem;
    bool? toggledValue;
    var addRequests = 0;
    await tester.pumpWidget(
      scoped(
        const VChecklistBubble(
          messageId: 'checklist-1',
          isMeSender: false,
          time: '12:00',
          checklist: VChecklistData(
            title: 'Launch tasks',
            canAddItems: true,
            items: [
              VChecklistItem(id: 'one', text: 'Prepare release'),
              VChecklistItem(
                id: 'two',
                text: 'Notify team',
                isCompleted: true,
                assigneeName: 'Alice',
              ),
            ],
          ),
        ),
        callbacks: VBubbleCallbacks(
          onChecklistItemToggle: (_, itemId, value) {
            toggledItem = itemId;
            toggledValue = value;
          },
          onChecklistAddItem: (_) => addRequests++,
        ),
      ),
    );

    expect(find.text('1/2'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('v-checklist-item-one')));
    expect(toggledItem, 'one');
    expect(toggledValue, isTrue);
    await tester.tap(find.byKey(const ValueKey('v-checklist-add-checklist-1')));
    expect(addRequests, 1);
  });

  testWidgets('event renders RSVP state and reports a response', (
    tester,
  ) async {
    VEventResponse? response;
    final start = DateTime.utc(2026, 9, 20, 18, 30);
    await tester.pumpWidget(
      scoped(
        VEventBubble(
          messageId: 'event-message',
          isMeSender: true,
          time: '12:00',
          event: VEventData(
            eventId: 'event-1',
            title: 'Community meetup',
            startsAt: start,
            endsAt: start.add(const Duration(hours: 2)),
            location: 'Downtown Hall',
            attendeeCount: 14,
          ),
        ),
        callbacks: VBubbleCallbacks(
          onEventResponse: (_, value) => response = value,
        ),
      ),
    );

    expect(find.text('SEP'), findsOneWidget);
    expect(find.text('18:30 – 20:30'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('v-event-going-event-1')));
    expect(response, VEventResponse.going);
  });

  testWidgets('live location shows active expiry and opens its session', (
    tester,
  ) async {
    String? openedSession;
    final now = DateTime.now();
    await tester.pumpWidget(
      scoped(
        VLiveLocationBubble(
          messageId: 'location-message',
          isMeSender: false,
          time: '12:00',
          liveLocation: VLiveLocationData(
            sessionId: 'live-1',
            latitude: 30.0444,
            longitude: 31.2357,
            startedAt: now.subtract(const Duration(minutes: 5)),
            expiresAt: now.add(const Duration(minutes: 15)),
            lastUpdatedAt: now,
            address: 'Cairo, Egypt',
            trail: [
              VLocationPoint(
                latitude: 30.044,
                longitude: 31.235,
                recordedAt: now,
              ),
            ],
          ),
        ),
        callbacks: VBubbleCallbacks(
          onLiveLocationTap: (_, sessionId) => openedSession = sessionId,
        ),
      ),
    );

    expect(find.textContaining('LIVE ·'), findsOneWidget);
    expect(find.textContaining('1 trail points'), findsOneWidget);
    await tester.tap(find.text('Cairo, Egypt'));
    expect(openedSession, 'live-1');
  });
}

VPlatformFile _transparentPng() {
  return VPlatformFile.fromBytes(
    name: 'transparent.png',
    bytes: base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk'
      '/wcAAusB9Wl2nWQAAAAASUVORK5CYII=',
    ),
  );
}
