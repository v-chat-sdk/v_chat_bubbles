import 'package:flutter/material.dart';
import '../core/custom_bubble_types.dart';
import '../core/enums.dart';
import '../core/callbacks.dart';
import '../core/config.dart';
import '../core/models.dart';
import '../theme/bubble_theme.dart';

/// Manages expand/collapse state for text bubbles across ListView rebuilds
class ExpandStateManager extends ChangeNotifier {
  final Map<String, bool> _states = {};
  bool isExpanded(String messageId) => _states[messageId] ?? false;
  void toggle(String messageId) {
    _states[messageId] = !isExpanded(messageId);
    notifyListeners();
  }

  void setExpanded(String messageId, bool value) {
    if (_states[messageId] != value) {
      _states[messageId] = value;
      notifyListeners();
    }
  }

  void clear() {
    _states.clear();
    notifyListeners();
  }
}

/// Manages user's selected reaction per message (per-session, single reaction per message)
class ReactionStateManager extends ChangeNotifier {
  final Map<String, String> _selectedReactions = {};

  /// Get the selected reaction emoji for a message, or null if none
  String? getSelectedReaction(String messageId) =>
      _selectedReactions[messageId];

  /// Check if a specific emoji is selected for a message
  bool isReactionSelected(String messageId, String emoji) =>
      _selectedReactions[messageId] == emoji;

  /// Set or toggle a reaction for a message
  /// Returns the action taken (add or remove)
  VReactionAction setReaction(String messageId, String emoji) {
    final current = _selectedReactions[messageId];
    if (current == emoji) {
      _selectedReactions.remove(messageId);
      notifyListeners();
      return VReactionAction.remove;
    } else {
      _selectedReactions[messageId] = emoji;
      notifyListeners();
      return VReactionAction.add;
    }
  }

  /// Remove reaction for a message
  void removeReaction(String messageId) {
    if (_selectedReactions.containsKey(messageId)) {
      _selectedReactions.remove(messageId);
      notifyListeners();
    }
  }

  /// Clear all reactions
  void clear() {
    _selectedReactions.clear();
    notifyListeners();
  }
}

/// InheritedWidget to provide bubble configuration down the tree
class VBubbleScopeData extends InheritedWidget {
  final VBubbleStyle style;
  final VBubbleTheme theme;
  final VBubbleConfig config;
  final VBubbleCallbacks callbacks;
  final List<VBubbleMenuItem> menuItems;
  final VMenuItemsBuilder? menuItemsBuilder;
  final bool isSelectionMode;
  final Set<String> selectedIds;
  final ExpandStateManager expandStateManager;
  final ReactionStateManager reactionStateManager;

  /// Custom bubble builders for rendering custom message types
  ///
  /// Map of contentType -> builder function.
  /// When a message with a matching contentType is encountered,
  /// the corresponding builder is used to create the bubble widget.
  final Map<String, CustomBubbleBuilder> customBubbleBuilders;
  const VBubbleScopeData({
    super.key,
    required this.style,
    required this.theme,
    required this.config,
    required this.callbacks,
    required this.menuItems,
    this.menuItemsBuilder,
    required this.isSelectionMode,
    required this.selectedIds,
    required this.expandStateManager,
    required this.reactionStateManager,
    this.customBubbleBuilders = const {},
    required super.child,
  });

  /// Get menu items for a specific message
  ///
  /// Priority:
  /// 1. If [menuItemsBuilder] returns non-null list -> use it
  /// 2. Else if [menuItems] is not empty -> use static items
  /// 3. Else -> use defaults based on message type
  List<VBubbleMenuItem> getMenuItemsFor(
      String messageId, String messageType, bool isMeSender) {
    // Try builder first
    if (menuItemsBuilder != null) {
      final items = menuItemsBuilder!(messageId, messageType, isMeSender);
      if (items != null) return items;
    }
    // Fall back to static items if provided
    if (menuItems.isNotEmpty) return menuItems;
    // Use defaults
    return VDefaultMenuItems.forMessageType(messageType);
  }

  static VBubbleScopeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VBubbleScopeData>();
  static VBubbleScopeData of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'No VBubbleScopeData found in context');
    return scope!;
  }

  bool isSelected(String id) => selectedIds.contains(id);

  /// Check if a custom builder exists for the given content type
  bool hasCustomBubbleBuilder(String contentType) =>
      customBubbleBuilders.containsKey(contentType);

  /// Get the custom builder for a content type, or null if not found
  CustomBubbleBuilder? getCustomBubbleBuilder(String contentType) =>
      customBubbleBuilders[contentType];

  /// Build a custom bubble if a builder exists for the content type
  ///
  /// Returns null if no builder is registered for the content type.
  Widget? buildCustomBubble({
    required BuildContext context,
    required String contentType,
    required String messageId,
    required bool isMeSender,
    required String time,
    required VCustomBubbleData data,
    CommonBubbleProps props = const CommonBubbleProps(),
  }) {
    final builder = customBubbleBuilders[contentType];
    if (builder == null) return null;
    return builder(context, messageId, isMeSender, time, data, props);
  }

  @override
  bool updateShouldNotify(VBubbleScopeData oldWidget) =>
      style != oldWidget.style ||
      theme != oldWidget.theme ||
      config != oldWidget.config ||
      callbacks != oldWidget.callbacks ||
      menuItems != oldWidget.menuItems ||
      menuItemsBuilder != oldWidget.menuItemsBuilder ||
      isSelectionMode != oldWidget.isSelectionMode ||
      selectedIds != oldWidget.selectedIds ||
      reactionStateManager != oldWidget.reactionStateManager ||
      customBubbleBuilders != oldWidget.customBubbleBuilders;
}

/// Main scope widget that provides configuration to all bubbles
class VBubbleScope extends StatefulWidget {
  /// Visual style of bubbles
  final VBubbleStyle style;

  /// Theme configuration (uses default for style if not provided)
  final VBubbleTheme? theme;

  /// Behavior configuration
  final VBubbleConfig config;

  /// All callbacks for interactions
  final VBubbleCallbacks callbacks;

  /// Static custom menu items for all messages (overrides defaults)
  final List<VBubbleMenuItem> menuItems;

  /// Builder for dynamic menu items per message
  ///
  /// Called for each message to get custom menu items.
  /// Return null to use defaults, or return a list to override.
  ///
  /// Example:
  /// ```dart
  /// menuItemsBuilder: (messageId, messageType, isMeSender) {
  ///   if (messageType == 'text') {
  ///     return [
  ///       VDefaultMenuItems.reply,
  ///       VDefaultMenuItems.copy,
  ///       VBubbleMenuItem(id: 'translate', label: 'Translate', icon: Icons.translate),
  ///     ];
  ///   }
  ///   return null; // Use defaults for other types
  /// },
  /// ```
  final VMenuItemsBuilder? menuItemsBuilder;

  /// Whether selection mode is active
  final bool isSelectionMode;

  /// Currently selected message IDs
  final Set<String> selectedIds;

  /// Custom bubble builders for rendering custom message types
  ///
  /// Register custom bubble builders by content type. When building
  /// messages, you can use [VBubbleScopeData.buildCustomBubble] to
  /// create bubbles for custom message types.
  ///
  /// Example:
  /// ```dart
  /// VBubbleScope(
  ///   customBubbleBuilders: {
  ///     'receipt': (context, messageId, isMeSender, time, data, props) {
  ///       return VReceiptBubble(
  ///         messageId: messageId,
  ///         isMeSender: isMeSender,
  ///         time: time,
  ///         receiptData: data as VReceiptData,
  ///         status: props.status,
  ///         isSameSender: props.isSameSender,
  ///       );
  ///     },
  ///     'product': (context, messageId, isMeSender, time, data, props) {
  ///       return VProductBubble(
  ///         messageId: messageId,
  ///         isMeSender: isMeSender,
  ///         time: time,
  ///         productData: data as VProductData,
  ///       );
  ///     },
  ///   },
  ///   child: ListView(...),
  /// )
  /// ```
  final Map<String, CustomBubbleBuilder> customBubbleBuilders;

  /// Child widget (typically a list of bubbles)
  final Widget child;
  const VBubbleScope({
    super.key,
    this.style = VBubbleStyle.telegram,
    this.theme,
    this.config = const VBubbleConfig(),
    this.callbacks = const VBubbleCallbacks(),
    this.menuItems = const [],
    this.menuItemsBuilder,
    this.isSelectionMode = false,
    this.selectedIds = const {},
    this.customBubbleBuilders = const {},
    required this.child,
  });
  @override
  State<VBubbleScope> createState() => _VBubbleScopeState();
}

class _VBubbleScopeState extends State<VBubbleScope> {
  final ExpandStateManager _expandStateManager = ExpandStateManager();
  final ReactionStateManager _reactionStateManager = ReactionStateManager();
  @override
  void dispose() {
    _expandStateManager.dispose();
    _reactionStateManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final effectiveTheme = widget.theme ??
        VBubbleTheme.fromStyle(widget.style, brightness: brightness);
    return VBubbleScopeData(
      style: widget.style,
      theme: effectiveTheme,
      config: widget.config,
      callbacks: widget.callbacks,
      menuItems: widget.menuItems,
      menuItemsBuilder: widget.menuItemsBuilder,
      isSelectionMode: widget.isSelectionMode,
      selectedIds: widget.selectedIds,
      expandStateManager: _expandStateManager,
      reactionStateManager: _reactionStateManager,
      customBubbleBuilders: widget.customBubbleBuilders,
      child: widget.child,
    );
  }
}

/// Extension to easily access scope from context
extension VBubbleScopeExtension on BuildContext {
  VBubbleScopeData get bubbleScope => VBubbleScopeData.of(this);
  VBubbleTheme get bubbleTheme => VBubbleScopeData.of(this).theme;
  VBubbleConfig get bubbleConfig => VBubbleScopeData.of(this).config;
  VBubbleCallbacks get bubbleCallbacks => VBubbleScopeData.of(this).callbacks;
  VBubbleStyle get bubbleStyle => VBubbleScopeData.of(this).style;
  bool get isSelectionMode => VBubbleScopeData.of(this).isSelectionMode;
  Set<String> get selectedIds => VBubbleScopeData.of(this).selectedIds;
  bool isSelected(String messageId) =>
      VBubbleScopeData.of(this).selectedIds.contains(messageId);
  ExpandStateManager get expandStateManager =>
      VBubbleScopeData.of(this).expandStateManager;
  ReactionStateManager get reactionStateManager =>
      VBubbleScopeData.of(this).reactionStateManager;

  /// Get all registered custom bubble builders
  Map<String, CustomBubbleBuilder> get customBubbleBuilders =>
      VBubbleScopeData.of(this).customBubbleBuilders;

  /// Check if a custom builder exists for the given content type
  bool hasCustomBubbleBuilder(String contentType) =>
      VBubbleScopeData.of(this).hasCustomBubbleBuilder(contentType);

  /// Get the custom builder for a content type, or null if not found
  CustomBubbleBuilder? getCustomBubbleBuilder(String contentType) =>
      VBubbleScopeData.of(this).getCustomBubbleBuilder(contentType);
}
