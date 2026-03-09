import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';
import 'package:orderly/features/home/presentation/widgets/cart_body.dart';
import 'package:orderly/features/home/presentation/widgets/cart_header.dart';
import 'package:orderly/features/home/presentation/widgets/empty_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late final AnimationController _headerController;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerFade = CurvedAnimation(parent: _headerController, curve: Curves.easeIn);

    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final isLoaded =
                state is HomeLoadedState && state.cartPayload != null;

            return Column(
              children: [
                
                FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: CartHeader(
                      itemCount: isLoaded
                          ? (state as HomeLoadedState).cartPayload?.items.length ?? 0
                          : 0,
                    ),
                  ),
                ),

                
                FadeTransition(
                  opacity: _headerFade,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isLoaded ? 'YOUR ITEMS' : 'OVERVIEW',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                          letterSpacing: 1.8,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Body ──
                Expanded(
                  child: isLoaded
                      ? CartBody(state: state)
                      : EmptyCart(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}