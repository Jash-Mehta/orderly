import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
    _headerFade =
        CurvedAnimation(parent: _headerController, curve: Curves.easeIn);

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
                          ? (state as HomeLoadedState).cartPayload!.items.length
                          : 0,
                    ),
                  ),
                ),

                
                FadeTransition(
                  opacity: _headerFade,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        isLoaded ? 'Your Items' : 'Overview',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black38,
                          letterSpacing: 3,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Body ─────────────────────────────────────────────────
                Expanded(
                  child: isLoaded
                      ? CartBody(state: state as HomeLoadedState)
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







