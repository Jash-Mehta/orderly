import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly/core/router/app_routes.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'SHOP',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.5,
                    height: 1,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Curated for you',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.white,
                    letterSpacing: 0.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          
          GestureDetector(
            onTap: () {
              context.push(AppRoutes.cart);
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color:  AppColors.bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Center(
                    child: const Icon(Icons.shopping_bag_outlined,
                        color: Colors.white, size: 20),
                  ),
                  
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoadedState && 
                          state.cartPayload != null && 
                          state.cartPayload!.items.isNotEmpty) {
                        return Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                state.cartPayload!.items.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

