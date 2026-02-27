import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/home/presentation/widgets/header.dart';
import 'package:orderly/features/home/presentation/widgets/animated_product_card.dart';
import 'package:orderly/features/home/data/model/dashboard_product_model.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';

// ─── Home Screen ────────────────────────────────────────────────────────────
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
    // Trigger auth check first
    context.read<AuthBloc>().add(AuthCheckRequested());
    // Trigger data fetch
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
      if (query.isEmpty) {
        _filteredProducts = products;
      } else {
        _filteredProducts = products.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase()) ||
                 product.brandName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (state is HomeFailureState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(GetHomeData());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is HomeLoadedState) {
              final products = state.homeresponse.data;
              
              // Initialize filtered products if not set
              if (_filteredProducts.isEmpty) {
                _filteredProducts = products;
              }
              
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
                            // Search field
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (query) => _filterProducts(query, products),
                                  decoration: const InputDecoration(
                                    hintText: 'Search products...',
                                    prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280)),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    hintStyle: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    sliver: SliverToBoxAdapter(
                      child: FadeTransition(
                        opacity: _headerFade,
                        child: Text(
                          'Featured',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.gunmetal,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),

                  
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => AnimatedProductCard(
                          product: _filteredProducts[index],
                          index: index,
                        ),
                        childCount: _filteredProducts.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            }
            
            // Default empty state
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
