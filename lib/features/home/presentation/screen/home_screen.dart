import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/home/presentation/widgets/header.dart';
import 'package:orderly/features/home/presentation/widgets/product_card.dart';
import 'package:orderly/features/home/data/model/dashboard_product_model.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _headerController;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  final TextEditingController _searchController = TextEditingController();
  List<DashboardProductModel> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
   // context.read<AuthBloc>().add(const AuthCheckRequested());
    context.read<HomeBloc>().add(GetHomeData());

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOut));
    _headerFade = CurvedAnimation(parent: _headerController, curve: Curves.easeIn);
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query, List<DashboardProductModel> products) {
    setState(() {
      _filteredProducts = query.isEmpty
          ? products
          : products.where((p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.brandName.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.amber, strokeWidth: 2),
              );
            }

            if (state is HomeFailureState) {
              return Center(
                child: _ErrorView(
                  message: state.message,
                  onRetry: () => context.read<HomeBloc>().add(GetHomeData()),
                ),
              );
            }

            if (state is HomeLoadedState) {
              final products = state.homeresponse.data;
              if (_filteredProducts.isEmpty) _filteredProducts = products;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _headerFade,
                      child: SlideTransition(
                        position: _headerSlide,
                        child: Column(
                          children: [
                            Header(),
                            _buildSearchBar(products),
                          ],
                        ),
                      ),
                    ),
                  ),

                  
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _headerFade,
                        child: const Text(
                          'FEATURED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.muted,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => ProductCard(
                          product: _filteredProducts[index],
                          index: index,
                          enableAnimation: true,
                          enableEntranceAnimation: true,
                          entranceDelay: Duration(milliseconds: 80 * index),
                        ),
                        childCount: _filteredProducts.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.56,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(List<DashboardProductModel> products) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (q) => _filterProducts(q, products),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.text,
          ),
          decoration: const InputDecoration(
            hintText: 'Search products...',
            hintStyle: TextStyle(color: AppColors.muted, fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.muted, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: const Icon(Icons.error_outline_rounded, size: 28, color: AppColors.muted),
          ),
          const SizedBox(height: 20),
          Text(
            'Error: $message',
            style: const TextStyle(fontSize: 14, color: AppColors.muted, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.amber.withOpacity(0.3), width: 1),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.amber),
              ),
            ),
          ),
        ],
      ),
    );
  }
}