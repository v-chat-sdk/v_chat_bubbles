import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:v_chat_bubbles/v_chat_bubbles.dart';

void main() {
  _testWithSemantics('other bubble types retain custom-builder metadata', (
    tester,
  ) async {
    final arguments = <(String, String)>[];
    await tester.pumpWidget(
      _scoped(
        const VContactBubble(
          messageId: 'contact',
          isMeSender: true,
          time: '12:00',
          contactData: VContactData(name: 'Sam'),
        ),
        config: VBubbleConfig(
          accessibility: VAccessibilityConfig(
            semanticLabelBuilder: (type, content) {
              arguments.add((type, content));
              return content;
            },
          ),
        ),
      ),
    );

    expect(arguments, contains(('contact', 'Sent contact at 12:00, sent')));
  });

  _testWithSemantics(
    'a bubble without an activation callback is not a button',
    (tester) async {
      await tester.pumpWidget(_scoped(_file()));

      final data = tester
          .getSemantics(find.byType(VFileBubble))
          .getSemanticsData();
      expect(data.flagsCollection.isButton, isFalse);
      expect(data.hasAction(ui.SemanticsAction.tap), isFalse);
      expect(data.label, contains('qa.txt'));
    },
  );

  _testWithSemantics(
    'text semantic activation invokes its callback exactly once',
    (tester) async {
      final tapped = <String>[];
      await tester.pumpWidget(
        _scoped(
          const VTextBubble(
            messageId: 'text-message',
            isMeSender: false,
            time: '12:00',
            text: 'Meet at the north entrance',
          ),
          callbacks: VBubbleCallbacks(onTap: tapped.add),
        ),
      );

      await _activate(tester, find.byType(VTextBubble));

      expect(tapped, ['text-message']);
    },
  );

  _testWithSemantics(
    'completed file semantic activation opens media exactly once',
    (tester) async {
      final opened = <String>[];
      await tester.pumpWidget(
        _scoped(
          _file(),
          callbacks: VBubbleCallbacks(
            onMediaTap: (data) => opened.add(data.messageId),
          ),
        ),
      );

      await _activate(tester, find.byType(VFileBubble));

      expect(opened, ['file-message']);
    },
  );

  _testWithSemantics(
    'completed file activation chooses one configured callback',
    (tester) async {
      final events = <String>[];
      await tester.pumpWidget(
        _scoped(
          _file(),
          callbacks: VBubbleCallbacks(
            onTap: (id) => events.add('tap:$id'),
            onMediaTap: (data) => events.add('media:${data.messageId}'),
          ),
        ),
      );

      await _activate(tester, find.byType(VFileBubble));

      expect(events, ['media:file-message']);
    },
  );

  _testWithSemantics(
    'completed file activation falls back to the general callback',
    (tester) async {
      final tapped = <String>[];
      await tester.pumpWidget(
        _scoped(_file(), callbacks: VBubbleCallbacks(onTap: tapped.add)),
      );

      await _activate(tester, find.byType(VFileBubble));

      expect(tapped, ['file-message']);
    },
  );

  for (final selected in [false, true]) {
    _testWithSemantics(
      'semantic activation ${selected ? 'deselects' : 'selects'} without opening media',
      (tester) async {
        final selections = <(String, bool)>[];
        final otherEvents = <String>[];
        await tester.pumpWidget(
          _scoped(
            _file(),
            isSelectionMode: true,
            selectedIds: selected ? {'file-message'} : {},
            callbacks: VBubbleCallbacks(
              onSelectionChanged: (id, value) => selections.add((id, value)),
              onTap: (_) => otherEvents.add('tap'),
              onMediaTap: (_) => otherEvents.add('media'),
              onTransferStateChanged: (_, _) => otherEvents.add('transfer'),
            ),
          ),
        );

        final data = tester
            .getSemantics(find.byType(VFileBubble))
            .getSemanticsData();
        expect(
          data.flagsCollection.isSelected,
          selected ? ui.Tristate.isTrue : ui.Tristate.isFalse,
        );
        await _activate(tester, find.byType(VFileBubble));

        expect(selections, [('file-message', !selected)]);
        expect(otherEvents, isEmpty);
      },
    );
  }

  _testWithSemantics('cancelled file does not open incomplete media', (
    tester,
  ) async {
    final events = <String>[];
    await tester.pumpWidget(
      _scoped(
        _file(transferState: VTransferState.cancelled),
        callbacks: VBubbleCallbacks(
          onTap: (_) => events.add('tap'),
          onMediaTap: (_) => events.add('media'),
        ),
      ),
    );

    await _activate(tester, find.byType(VFileBubble));

    expect(events, ['tap']);
  });

  _testWithSemantics(
    'selection without a callback does not expose media activation',
    (tester) async {
      await tester.pumpWidget(
        _scoped(
          _file(),
          isSelectionMode: true,
          callbacks: VBubbleCallbacks(onMediaTap: (_) => fail('opened media')),
        ),
      );

      final data = tester
          .getSemantics(find.byType(VFileBubble))
          .getSemanticsData();
      expect(data.flagsCollection.isButton, isFalse);
      expect(data.hasAction(ui.SemanticsAction.tap), isFalse);
    },
  );

  const transfers = {
    VTransferState.idle: VMediaTransferAction.download,
    VTransferState.error: VMediaTransferAction.retry,
    VTransferState.uploading: VMediaTransferAction.cancel,
    VTransferState.downloading: VMediaTransferAction.cancel,
  };
  for (final entry in transfers.entries) {
    _testWithSemantics(
      '${entry.key.name} file semantic activation requests ${entry.value.name} once',
      (tester) async {
        final transfers = <(String, VMediaTransferAction)>[];
        final otherEvents = <String>[];
        await tester.pumpWidget(
          _scoped(
            _file(transferState: entry.key),
            callbacks: VBubbleCallbacks(
              onTransferStateChanged: (id, action) =>
                  transfers.add((id, action)),
              onTap: (_) => otherEvents.add('tap'),
              onMediaTap: (_) => otherEvents.add('media'),
            ),
          ),
        );

        await _activate(tester, find.byType(VFileBubble));

        expect(transfers, [('file-message', entry.value)]);
        expect(otherEvents, isEmpty);
      },
    );
  }

  _testWithSemantics(
    'custom semantic builder receives actual text and filename',
    (tester) async {
      final arguments = <(String, String)>[];
      await tester.pumpWidget(
        _scoped(
          Column(
            children: [
              const VTextBubble(
                messageId: 'text-message',
                isMeSender: false,
                time: '12:00',
                text: 'Meet at the north entrance',
              ),
              _file(),
            ],
          ),
          config: VBubbleConfig(
            accessibility: VAccessibilityConfig(
              semanticLabelBuilder: (type, content) {
                arguments.add((type, content));
                return '$type: $content';
              },
            ),
          ),
        ),
      );

      expect(
        arguments,
        contains(('text message', 'Meet at the north entrance')),
      );
      expect(arguments, contains(('file', 'qa.txt')));
      expect(
        tester.getSemantics(find.byType(VTextBubble)).getSemanticsData().label,
        'text message: Meet at the north entrance',
      );
      expect(
        tester.getSemantics(find.byType(VFileBubble)).getSemanticsData().label,
        'file: qa.txt',
      );
    },
  );

  _testWithSemantics(
    'default text label retains content, sender and message metadata',
    (tester) async {
      await tester.pumpWidget(
        _scoped(
          const VTextBubble(
            messageId: 'text-message',
            isMeSender: true,
            senderName: 'Sam',
            time: '12:34',
            status: VMessageStatus.read,
            text: 'Meet at the north entrance',
            isEdited: true,
            isPinned: true,
            isStarred: true,
          ),
        ),
      );

      final label = tester
          .getSemantics(find.byType(VTextBubble))
          .getSemanticsData()
          .label;
      for (final content in [
        'Sent',
        'text message',
        'Meet at the north entrance',
        'Sam',
        '12:34',
        'read',
        'edited',
        'pinned',
        'starred',
      ]) {
        expect(label, contains(content));
      }
    },
  );

  _testWithSemantics(
    'default file label retains filename, sender and received time',
    (tester) async {
      await tester.pumpWidget(
        _scoped(
          VFileBubble(
            messageId: 'file-message',
            isMeSender: false,
            senderName: 'Sam',
            time: '12:34',
            file: VPlatformFile.fromBytes(name: 'qa.txt', bytes: [65, 66]),
          ),
        ),
      );

      final label = tester
          .getSemantics(find.byType(VFileBubble))
          .getSemanticsData()
          .label;
      for (final content in ['Received', 'file', 'qa.txt', 'Sam', '12:34']) {
        expect(label, contains(content));
      }
    },
  );
}

Widget _scoped(
  Widget child, {
  VBubbleCallbacks callbacks = const VBubbleCallbacks(),
  VBubbleConfig config = const VBubbleConfig(),
  bool isSelectionMode = false,
  Set<String> selectedIds = const {},
}) => MaterialApp(
  home: Scaffold(
    body: VBubbleScope(
      config: config,
      callbacks: callbacks,
      isSelectionMode: isSelectionMode,
      selectedIds: selectedIds,
      child: child,
    ),
  ),
);

VFileBubble _file({VTransferState transferState = VTransferState.completed}) =>
    VFileBubble(
      messageId: 'file-message',
      isMeSender: true,
      time: '12:00',
      transferState: transferState,
      file: VPlatformFile.fromBytes(name: 'qa.txt', bytes: [65, 66]),
    );

Future<void> _activate(WidgetTester tester, Finder finder) async {
  final node = tester.getSemantics(finder);
  expect(node.getSemanticsData().hasAction(ui.SemanticsAction.tap), isTrue);
  node.owner!.performAction(node.id, ui.SemanticsAction.tap);
  await tester.pump();
}

void _testWithSemantics(
  String description,
  Future<void> Function(WidgetTester) body,
) {
  testWidgets(description, (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await body(tester);
    } finally {
      handle.dispose();
    }
  });
}
