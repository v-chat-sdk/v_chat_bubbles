import 'package:flutter/material.dart';

import '../../core/custom_bubble_types.dart';
import '../base_bubble.dart';
import '../bubble_scope.dart';

/// Data model for a single receipt item
@immutable
class VReceiptItem {
  /// Item name
  final String name;

  /// Quantity ordered
  final int quantity;

  /// Price per unit
  final double price;

  const VReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  /// Total price for this item (quantity * price)
  double get total => quantity * price;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VReceiptItem) return false;
    return name == other.name &&
        quantity == other.quantity &&
        price == other.price;
  }

  @override
  int get hashCode => Object.hash(name, quantity, price);
}

/// Data model for receipt messages
///
/// Example:
/// ```dart
/// final receipt = VReceiptData(
///   orderId: 'ORD-12345',
///   storeName: 'Coffee Shop',
///   items: [
///     VReceiptItem(name: 'Latte', quantity: 2, price: 4.50),
///     VReceiptItem(name: 'Croissant', quantity: 1, price: 3.00),
///   ],
///   subtotal: 12.00,
///   tax: 1.20,
///   total: 13.20,
/// );
/// ```
@immutable
class VReceiptData extends VCustomBubbleData {
  /// Unique order identifier
  final String orderId;

  /// Store/merchant name
  final String storeName;

  /// List of items in the receipt
  final List<VReceiptItem> items;

  /// Subtotal before tax
  final double subtotal;

  /// Tax amount
  final double tax;

  /// Total amount (subtotal + tax)
  final double total;

  /// Optional currency symbol (defaults to '$')
  final String currencySymbol;

  /// Optional order date
  final DateTime? orderDate;

  @override
  String get contentType => 'receipt';

  const VReceiptData({
    required this.orderId,
    required this.storeName,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.currencySymbol = '\$',
    this.orderDate,
  });

  /// Create a copy with updated values
  VReceiptData copyWith({
    String? orderId,
    String? storeName,
    List<VReceiptItem>? items,
    double? subtotal,
    double? tax,
    double? total,
    String? currencySymbol,
    DateTime? orderDate,
  }) {
    return VReceiptData(
      orderId: orderId ?? this.orderId,
      storeName: storeName ?? this.storeName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      orderDate: orderDate ?? this.orderDate,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VReceiptData) return false;
    return orderId == other.orderId &&
        storeName == other.storeName &&
        subtotal == other.subtotal &&
        tax == other.tax &&
        total == other.total &&
        currencySymbol == other.currencySymbol;
  }

  @override
  int get hashCode =>
      Object.hash(orderId, storeName, subtotal, tax, total, currencySymbol);
}

/// Receipt bubble widget showing order details
///
/// Displays a receipt-style card with:
/// - Store name and order ID
/// - List of items with quantities and prices
/// - Subtotal, tax, and total
///
/// Example:
/// ```dart
/// VReceiptBubble(
///   messageId: 'msg_123',
///   isMeSender: true,
///   time: '12:30 PM',
///   receiptData: VReceiptData(
///     orderId: 'ORD-12345',
///     storeName: 'Coffee Shop',
///     items: [
///       VReceiptItem(name: 'Latte', quantity: 2, price: 4.50),
///       VReceiptItem(name: 'Croissant', quantity: 1, price: 3.00),
///     ],
///     subtotal: 12.00,
///     tax: 1.20,
///     total: 13.20,
///   ),
/// )
/// ```
class VReceiptBubble extends BaseBubble {
  /// Receipt data for this bubble
  final VReceiptData receiptData;

  /// Callback when the receipt is tapped
  final VoidCallback? onReceiptTap;

  @override
  String get messageType => 'receipt';

  const VReceiptBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.receiptData,
    this.onReceiptTap,
    super.status,
    super.isSameSender,
    super.avatar,
    super.senderName,
    super.senderColor,
    super.replyTo,
    super.forwardedFrom,
    super.reactions,
    super.isEdited,
    super.isPinned,
    super.isStarred,
    super.isHighlighted,
  });

  @override
  Widget buildContent(BuildContext context) {
    final theme = context.bubbleTheme;
    final config = context.bubbleConfig;
    final translations = config.translations;
    final textColor = selectTextColor(theme);
    final secondaryColor = selectSecondaryTextColor(theme);
    final accentColor = selectLinkColor(theme);
    final header = buildBubbleHeader(context);
    return buildBubbleContainer(
      context: context,
      showTail: !isSameSender,
      child: GestureDetector(
        onTap: onReceiptTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null) header,
            // Receipt header with icon
            Row(
              children: [
                Icon(Icons.receipt_long, size: 20, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  translations.receiptTitle,
                  style: theme.captionTextStyle.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Store name and order ID
            Text(
              receiptData.storeName,
              style: theme.messageTextStyle.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${translations.receiptOrderPrefix}${receiptData.orderId}',
              style: theme.captionTextStyle.copyWith(color: secondaryColor),
            ),
            if (receiptData.orderDate != null) ...[
              const SizedBox(height: 2),
              Text(
                _formatDate(receiptData.orderDate!),
                style: theme.captionTextStyle.copyWith(color: secondaryColor),
              ),
            ],
            const SizedBox(height: 12),
            // Items list
            ...receiptData.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.name}',
                          style:
                              theme.messageTextStyle.copyWith(color: textColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${receiptData.currencySymbol}${item.total.toStringAsFixed(2)}',
                        style:
                            theme.messageTextStyle.copyWith(color: textColor),
                      ),
                    ],
                  ),
                )),
            Divider(height: 16, color: secondaryColor.withValues(alpha: 0.3)),
            // Totals
            _buildTotalRow(
              translations.receiptSubtotal,
              receiptData.subtotal,
              theme,
              textColor,
            ),
            const SizedBox(height: 2),
            _buildTotalRow(
              translations.receiptTax,
              receiptData.tax,
              theme,
              secondaryColor,
            ),
            const SizedBox(height: 4),
            _buildTotalRow(
              translations.receiptTotal,
              receiptData.total,
              theme,
              textColor,
              isBold: true,
            ),
            const SizedBox(height: 8),
            // Meta
            Align(
              alignment: Alignment.centerRight,
              child: buildMeta(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    double amount,
    dynamic theme,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.messageTextStyle.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          '${receiptData.currencySymbol}${amount.toStringAsFixed(2)}',
          style: theme.messageTextStyle.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
