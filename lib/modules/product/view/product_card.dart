import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bhakharamart/core/themes/app_colors.dart';
import 'package:bhakharamart/data/models/product_model.dart';
import 'package:bhakharamart/data/models/cart_model.dart';
import 'package:bhakharamart/data/network/api_endpoints.dart';
import 'package:bhakharamart/modules/home/controller/home_controller.dart';
import 'package:bhakharamart/modules/cart/controller/cart_controller.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double? discountPercent;
  final double? rating;
  final int? reviewCount;
  final bool showDiscount;
  final bool showRating;

  const ProductCard({
    super.key,
    required this.product,
    this.discountPercent,
    this.rating,
    this.reviewCount,
    this.showDiscount = true,
    this.showRating = true,
  });

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    final cartController = Get.isRegistered<CartController>() ? Get.find<CartController>() : null;
    final bool isInCart = cartController?.isInCart(product.id) ?? false;

    // Return a placeholder if controllers aren't ready
    if (homeController == null || cartController == null) {
      return _buildPlaceholderCard();
    }

    return GestureDetector(
      onTap: () => homeController.openProduct(product),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: AppColors.textPrimary.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            color: AppColors.divider.withOpacity(0.6),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Product Image Container
                _buildImageContainer(),

                /// Product Details
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Rating Row (if enabled)
                      if (showRating && rating != null) _buildRatingRow(),

                      const SizedBox(height: 6),

                      /// Product Name
                      Text(
                        product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 4),

                      /// Unit
                      Text(
                        product.unit,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Price and Action Row
                      _buildPriceAndActionRow(
                        homeController,
                        cartController,
                        isInCart,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Discount Badge
            if (showDiscount && discountPercent != null && discountPercent! > 0)
              Positioned(
                top: 10,
                left: 10,
                child: _buildDiscountBadge(),
              ),

            /// Wishlist Button
            Positioned(
              top: 8,
              right: 8,
              child: _buildWishlistButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// Product Image
            product.image.isNotEmpty
                ? Image.network(
                    '${ApiEndpoints.domain}/uploads/products/${product.image}',
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary.withOpacity(0.6),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => _buildImageErrorState(),
                  )
                : _buildImagePlaceholder(),

            /// Loading Shimmer Effect
            if (product.image.isEmpty)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.card,
                      AppColors.card.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 48,
        color: AppColors.textSecondary.withOpacity(0.4),
      ),
    );
  }

  Widget _buildImageErrorState() {
    return Center(
      child: Icon(
        Icons.broken_image_outlined,
        size: 40,
        color: AppColors.textSecondary.withOpacity(0.3),
      ),
    );
  }

  Widget _buildPlaceholderCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: AppColors.divider.withOpacity(0.6),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Product Image Container (placeholder)
          Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
          ),
          /// Placeholder content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 36,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star,
          size: 14,
          color: Color(0xFFFFB800),
        ),
        const SizedBox(width: 2),
        Text(
          '${rating?.toStringAsFixed(1) ?? '0.0'}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (reviewCount != null)
          Text(
            ' ($reviewCount)',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.discountGreen,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppColors.discountGreen.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '${discountPercent?.toStringAsFixed(0)}% OFF',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildWishlistButton() {
    return Material(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.favorite_border_outlined,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceAndActionRow(
    HomeController homeController,
    CartController cartController,
    bool isInCart,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Price Section
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Sale Price
                Text(
                  '₹${product.salePrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                /// Original Price (if discount exists)
                if (discountPercent != null && discountPercent! > 0)
                  Text(
                    '₹${(product.salePrice / (1 - discountPercent! / 100)).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
          ),
        ),

        /// Cart Action
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 90),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: _buildCartAction(homeController, cartController, isInCart),
          ),
        ),
      ],
    );
  }

  Widget _buildCartAction(
    HomeController homeController,
    CartController cartController,
    bool isInCart,
  ) {
    return Obx(() {
      final cartItem = cartController.getCartItem(product.id);
      final bool inCart = cartItem != null;
      final int quantity = cartItem?.quantity.toInt() ?? 0;

      if (inCart && quantity > 0) {
        /// Show quantity controls
        return _buildQuantityControls(cartController, cartItem);
      }

      /// Show Add button
      return _buildAddButton(homeController);
    });
  }

  Widget _buildAddButton(HomeController homeController) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryVariant],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => homeController.addToCart(product),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: const Text(
              'ADD',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls(CartController cartController, CartItemModel cartItem) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Decrease Button
            _buildQuantityButton(
              icon: Icons.remove,
              onTap: () => cartController.decreaseQty(cartItem),
            ),

            /// Quantity Text
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Container(
                key: ValueKey(cartItem.quantity.toInt()),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '${cartItem.quantity.toInt()}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            /// Increase Button
            _buildQuantityButton(
              icon: Icons.add,
              onTap: () => cartController.increaseQty(cartItem),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
