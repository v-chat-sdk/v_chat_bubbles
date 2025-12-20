import 'package:flutter/foundation.dart';

import 'enums.dart';

/// Labels for context menu actions (i18n support)
@immutable
class VContextMenuLabels {
  final String reply;
  final String forward;
  final String copy;
  final String download;
  final String edit;
  final String delete;
  final String pin;
  final String unpin;
  final String star;
  final String unstar;
  final String report;
  final String share;
  final String select;
  final String info;
  final String save;
  final String translate;
  final String speak;
  const VContextMenuLabels({
    this.reply = 'Reply',
    this.forward = 'Forward',
    this.copy = 'Copy',
    this.download = 'Download',
    this.edit = 'Edit',
    this.delete = 'Delete',
    this.pin = 'Pin',
    this.unpin = 'Unpin',
    this.star = 'Star',
    this.unstar = 'Unstar',
    this.report = 'Report',
    this.share = 'Share',
    this.select = 'Select',
    this.info = 'Info',
    this.save = 'Save',
    this.translate = 'Translate',
    this.speak = 'Speak',
  });

  /// Get label for a specific action
  String labelFor(VMessageAction action) {
    switch (action) {
      case VMessageAction.reply:
        return reply;
      case VMessageAction.forward:
        return forward;
      case VMessageAction.copy:
        return copy;
      case VMessageAction.download:
        return download;
      case VMessageAction.edit:
        return edit;
      case VMessageAction.delete:
        return delete;
      case VMessageAction.pin:
        return pin;
      case VMessageAction.unpin:
        return unpin;
      case VMessageAction.star:
        return star;
      case VMessageAction.unstar:
        return unstar;
      case VMessageAction.report:
        return report;
      case VMessageAction.share:
        return share;
      case VMessageAction.select:
        return select;
      case VMessageAction.info:
        return info;
      case VMessageAction.save:
        return save;
      case VMessageAction.translate:
        return translate;
      case VMessageAction.speak:
        return speak;
    }
  }

  VContextMenuLabels copyWith({
    String? reply,
    String? forward,
    String? copy,
    String? download,
    String? edit,
    String? delete,
    String? pin,
    String? unpin,
    String? star,
    String? unstar,
    String? report,
    String? share,
    String? select,
    String? info,
    String? save,
    String? translate,
    String? speak,
  }) =>
      VContextMenuLabels(
        reply: reply ?? this.reply,
        forward: forward ?? this.forward,
        copy: copy ?? this.copy,
        download: download ?? this.download,
        edit: edit ?? this.edit,
        delete: delete ?? this.delete,
        pin: pin ?? this.pin,
        unpin: unpin ?? this.unpin,
        star: star ?? this.star,
        unstar: unstar ?? this.unstar,
        report: report ?? this.report,
        share: share ?? this.share,
        select: select ?? this.select,
        info: info ?? this.info,
        save: save ?? this.save,
        translate: translate ?? this.translate,
        speak: speak ?? this.speak,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VContextMenuLabels &&
          runtimeType == other.runtimeType &&
          reply == other.reply &&
          forward == other.forward &&
          copy == other.copy &&
          download == other.download &&
          edit == other.edit &&
          delete == other.delete &&
          pin == other.pin &&
          unpin == other.unpin &&
          star == other.star &&
          unstar == other.unstar &&
          report == other.report &&
          share == other.share &&
          select == other.select &&
          info == other.info &&
          save == other.save &&
          translate == other.translate &&
          speak == other.speak;
  @override
  int get hashCode => Object.hash(
        reply,
        forward,
        copy,
        download,
        edit,
        delete,
        pin,
        unpin,
        star,
        unstar,
        report,
        share,
        select,
        info,
        save,
        translate,
        speak,
      );
}

/// Configuration for the built-in context menu
@immutable
class VContextMenuConfig {
  /// Whether to enable the built-in context menu when onLongPress is null
  final bool enableBuiltInMenu;

  /// Available actions to show in the menu (order is preserved)
  final List<VMessageAction> availableActions;

  /// Whether to show the reactions row
  final bool showReactions;

  /// Custom reaction emojis (uses style-specific if null)
  final List<String>? customReactions;

  /// Labels for actions (for i18n support)
  final VContextMenuLabels labels;
  const VContextMenuConfig({
    this.enableBuiltInMenu = true,
    this.availableActions = const [
      VMessageAction.reply,
      VMessageAction.forward,
      VMessageAction.copy,
      VMessageAction.download,
      VMessageAction.delete,
    ],
    this.showReactions = true,
    this.customReactions,
    this.labels = const VContextMenuLabels(),
  });

  /// Standard context menu with default settings
  static const standard = VContextMenuConfig();

  /// Context menu with reactions only (no actions)
  static const reactionsOnly = VContextMenuConfig(
    availableActions: [],
  );

  /// Context menu with actions only (no reactions)
  static const actionsOnly = VContextMenuConfig(
    showReactions: false,
  );

  /// Disabled context menu - falls back to onLongPress callback
  static const disabled = VContextMenuConfig(
    enableBuiltInMenu: false,
  );

  /// Full context menu with all actions
  static const full = VContextMenuConfig(
    availableActions: [
      VMessageAction.reply,
      VMessageAction.forward,
      VMessageAction.copy,
      VMessageAction.download,
      VMessageAction.save,
      VMessageAction.share,
      VMessageAction.edit,
      VMessageAction.delete,
      VMessageAction.pin,
      VMessageAction.star,
      VMessageAction.select,
      VMessageAction.info,
      VMessageAction.translate,
      VMessageAction.speak,
      VMessageAction.report,
    ],
  );

  /// Minimal context menu with essential actions only
  static const minimal = VContextMenuConfig(
    availableActions: [
      VMessageAction.reply,
      VMessageAction.copy,
      VMessageAction.delete,
    ],
  );

  /// Media-focused context menu
  static const media = VContextMenuConfig(
    availableActions: [
      VMessageAction.reply,
      VMessageAction.forward,
      VMessageAction.download,
      VMessageAction.save,
      VMessageAction.share,
      VMessageAction.delete,
    ],
  );
  VContextMenuConfig copyWith({
    bool? enableBuiltInMenu,
    List<VMessageAction>? availableActions,
    bool? showReactions,
    List<String>? customReactions,
    VContextMenuLabels? labels,
  }) =>
      VContextMenuConfig(
        enableBuiltInMenu: enableBuiltInMenu ?? this.enableBuiltInMenu,
        availableActions: availableActions ?? this.availableActions,
        showReactions: showReactions ?? this.showReactions,
        customReactions: customReactions ?? this.customReactions,
        labels: labels ?? this.labels,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VContextMenuConfig &&
          runtimeType == other.runtimeType &&
          enableBuiltInMenu == other.enableBuiltInMenu &&
          listEquals(availableActions, other.availableActions) &&
          showReactions == other.showReactions &&
          listEquals(customReactions, other.customReactions) &&
          labels == other.labels;
  @override
  int get hashCode => Object.hash(
        enableBuiltInMenu,
        Object.hashAll(availableActions),
        showReactions,
        customReactions != null ? Object.hashAll(customReactions!) : null,
        labels,
      );
}
