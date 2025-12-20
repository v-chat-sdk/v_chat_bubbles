import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

import '../../core/constants.dart';

import '../../utils/shimmer_helper.dart';
import '../../core/custom_bubble_types.dart';
import '../base_bubble.dart';
import '../bubble_scope.dart';
import '../shared/unified_image.dart';

/// Data model for product messages
///
/// Example:
/// ```dart
/// final product = VProductData(
///   productId: 'SKU-12345',
///   name: 'Wireless Headphones',
///   description: 'Premium noise-cancelling headphones',
///   price: 299.99,
///   image: VPlatformFile.fromUrl(networkUrl: 'https://example.com/headphones.jpg'),
///   actionLabel: 'View Product',
/// );
/// ```
@immutable
class VProductData extends VCustomBubbleData {
  /// Unique product identifier
  final String productId;

  /// Product name
  final String name;

  /// Optional product description
  final String? description;

  /// Product price
  final double price;

  /// Optional currency symbol (defaults to '$')
  final String currencySymbol;

  /// Optional product image
  final VPlatformFile? image;

  /// Optional action button label (e.g., 'View Product', 'Buy Now')
  final String? actionLabel;

  /// Optional original price (for showing discount)
  final double? originalPrice;

  /// Optional rating (0.0 to 5.0)
  final double? rating;

  /// Optional review count
  final int? reviewCount;

  @override
  String get contentType => 'product';

  const VProductData({
    required this.productId,
    required this.name,
    this.description,
    required this.price,
    this.currencySymbol = '\$',
    this.image,
    this.actionLabel,
    this.originalPrice,
    this.rating,
    this.reviewCount,
  });

  /// Whether product has a discount
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  /// Discount percentage (if applicable)
  int? get discountPercentage {
    if (!hasDiscount) return null;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  /// Create a copy with updated values
  VProductData copyWith({
    String? productId,
    String? name,
    String? description,
    double? price,
    String? currencySymbol,
    VPlatformFile? image,
    String? actionLabel,
    double? originalPrice,
    double? rating,
    int? reviewCount,
  }) {
    return VProductData(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      image: image ?? this.image,
      actionLabel: actionLabel ?? this.actionLabel,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VProductData) return false;
    return productId == other.productId &&
        name == other.name &&
        price == other.price &&
        currencySymbol == other.currencySymbol;
  }

  @override
  int get hashCode => Object.hash(productId, name, price, currencySymbol);
}

/// Product bubble widget showing a product card
///
/// Displays a product card with:
/// - Optional product image
/// - Product name and description
/// - Price (with optional discount)
/// - Optional rating
/// - Optional action button
///
/// Example:
/// ```dart
/// VProductBubble(
///   messageId: 'msg_123',
///   isMeSender: true,
///   time: '12:30 PM',
///   productData: VProductData(
///     productId: 'SKU-12345',
///     name: 'Wireless Headphones',
///     description: 'Premium noise-cancelling headphones',
///     price: 299.99,
///     originalPrice: 399.99,
///     image: VPlatformFile.fromUrl(networkUrl: 'https://example.com/headphones.jpg'),
///     actionLabel: 'View Product',
///     rating: 4.5,
///     reviewCount: 128,
///   ),
///   onActionTap: () => openProductPage(),
/// )
/// ```
class VProductBubble extends BaseBubble {
  /// Product data for this bubble
  final VProductData productData;

  /// Callback when the action button is tapped
  final VoidCallback? onActionTap;

  /// Callback when the product image is tapped
  final VoidCallback? onImageTap;

  @override
  String get messageType => 'product';

  const VProductBubble({
    super.key,
    required super.messageId,
    required super.isMeSender,
    required super.time,
    required this.productData,
    this.onActionTap,
    this.onImageTap,
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
    final textColor = selectTextColor(theme);
    final secondaryColor = selectSecondaryTextColor(theme);
    final accentColor = selectLinkColor(theme);
    final shimmerColors = VShimmerHelper.getShimmerColors(theme, isMeSender);
    final header = buildBubbleHeader(context);
    return buildBubbleContainer(
      context: context,
      showTail: !isSameSender,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header inside padding
          if (header != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: header,
            ),
          // Product image
          if (productData.image != null)
            GestureDetector(
              onTap: onImageTap,
              child: ClipRRect(
                borderRadius: header != null
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      )
                    : BorderRadius.vertical(
                        top: Radius.circular(config.spacing.bubbleRadius),
                      ),
                child: SizedBox(
                  width: double.infinity,
                  height: 160,
                  child: VUnifiedImage(
                    imageSource: productData.image!,
                    fit: BoxFit.cover,
                    shimmerBaseColor: shimmerColors.base,
                    shimmerHighlightColor: shimmerColors.highlight,
                    fadeInDuration: config.animation.fadeIn,
                    errorWidget: Container(
                      color: secondaryColor.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Product info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product name
                Text(
                  productData.name,
                  style: theme.messageTextStyle.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Description
                if (productData.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    productData.description!,
                    style:
                        theme.captionTextStyle.copyWith(color: secondaryColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                // Price row
                Row(
                  children: [
                    Text(
                      '${productData.currencySymbol}${productData.price.toStringAsFixed(2)}',
                      style: theme.messageTextStyle.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    if (productData.hasDiscount) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${productData.currencySymbol}${productData.originalPrice!.toStringAsFixed(2)}',
                        style: theme.captionTextStyle.copyWith(
                          color: secondaryColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BubbleRadius.tiny,
                        ),
                        child: Text(
                          '-${productData.discountPercentage}%',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                // Rating
                if (productData.rating != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        final filled = index < productData.rating!.floor();
                        final halfFilled =
                            index == productData.rating!.floor() &&
                                productData.rating! % 1 >= 0.5;
                        return Icon(
                          filled
                              ? Icons.star
                              : halfFilled
                                  ? Icons.star_half
                                  : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        productData.rating!.toStringAsFixed(1),
                        style:
                            theme.captionTextStyle.copyWith(color: textColor),
                      ),
                      if (productData.reviewCount != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(${productData.reviewCount})',
                          style: theme.captionTextStyle
                              .copyWith(color: secondaryColor),
                        ),
                      ],
                    ],
                  ),
                ],
                // Action button
                if (productData.actionLabel != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onActionTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BubbleRadius.small,
                        ),
                      ),
                      child: Text(
                        productData.actionLabel!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                // Meta
                Align(
                  alignment: Alignment.centerRight,
                  child: buildMeta(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
