import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/home/data/model/dashboard_product_model.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';
import 'package:orderly/features/home/data/model/create_order_item.dart';

class ProductCard extends StatefulWidget {
  final DashboardProductModel product;
  final int? index;
  final bool enableAnimation;
  final bool enableEntranceAnimation;
  final Duration entranceDelay;

  const ProductCard({
    super.key, 
    required this.product,
    this.index,
    this.enableAnimation = true,
    this.enableEntranceAnimation = false,
    this.entranceDelay = Duration.zero,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  late final AnimationController _btnController;
  late final AnimationController? _entranceController;
  late final Animation<double>? _fade;
  late final Animation<Offset>? _slide;
  bool _added = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
    );

    if (widget.enableEntranceAnimation) {
      _entranceController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      _fade = CurvedAnimation(parent: _entranceController!, curve: Curves.easeOut);
      _slide = Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _entranceController!, curve: Curves.easeOut));

      Future.delayed(widget.entranceDelay, () {
        if (mounted) _entranceController.forward();
      });
    }
  }

  @override
  void dispose() {
    _btnController.dispose();
    _entranceController?.dispose();
    super.dispose();
  }

  void _onTapDown(_) => setState(() => _pressed = true);
  void _onTapUp(_) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  Future<void> _handleAdd() async {
    await _btnController.forward();
    await _btnController.reverse();
    setState(() => _added = true);

    if (mounted) {
      context.read<HomeBloc>().add(AddToCart(
        item: CreateOrderItem(
          productId: widget.product.productId,
          quantity: 1,
          amount: widget.product.price,
          name: widget.product.name,
          brandName: widget.product.brandName,
          image: widget.product.imageUrl,
        ),
      ));
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.product.name} added ✓'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: AppColors.surface,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _added = false);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final inStock = p.availableQuantity > 0;

    final cardContent = Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Product image
                Image.network(
                  p.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildImgPlaceholder(),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return _buildImgPlaceholder();
                  },
                ),

                // Bottom scrim
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.surface.withOpacity(0.85),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Top-right badges
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Out of stock badge
                      if (!inStock) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.red.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'OUT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],

                      // Add to cart button
                      GestureDetector(
                        onTap: inStock ? _handleAdd : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _added
                                ? AppColors.green
                                : inStock
                                    ? Colors.white.withOpacity(0.12)
                                    : AppColors.border,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _added
                                  ? AppColors.green
                                  : Colors.white.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            _added
                                ? Icons.check_rounded
                                : Icons.add_shopping_cart_rounded,
                            color: _added
                                ? Colors.black
                                : inStock
                                    ? Colors.white
                                    : AppColors.muted,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Info area ──
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Brand
                  Text(
                    p.brandName,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.muted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Name
                  Text(
                    p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                      height: 1.3,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFB800), size: 13),
                      const SizedBox(width: 3),
                      const Text(
                        '4.5',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '(234)',
                        style: TextStyle(fontSize: 10, color: AppColors.muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price
                  Text(
                    '\$${p.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.amber,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final animatedCard = widget.enableAnimation
        ? GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedScale(
              scale: _pressed ? 0.96 : 1.0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeInOut,
              child: cardContent,
            ),
          )
        : cardContent;

    if (widget.enableEntranceAnimation && _fade != null && _slide != null) {
      return FadeTransition(
        opacity: _fade!,
        child: SlideTransition(
          position: _slide!,
          child: animatedCard,
        ),
      );
    }

    return animatedCard;
  }

  Widget _buildImgPlaceholder() {
    return Container(
      color: AppColors.surface2,
      child: const Center(
        child: Text('📦', style: TextStyle(fontSize: 36)),
      ),
    );
  }
}