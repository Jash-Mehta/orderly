import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/shipments/data/models/shipment_tracking.dart';
import 'package:orderly/features/shipments/domain/bloc/shipment_bloc.dart';
import 'package:orderly/features/shipments/domain/bloc/shipment_event.dart';
import 'package:orderly/features/shipments/domain/bloc/shipment_state.dart';
import 'package:orderly/features/shipments/presentation/widgets/animated_timeline.dart';
import 'package:orderly/features/shipments/presentation/widgets/error_view.dart';
import 'package:orderly/features/shipments/presentation/widgets/header.dart';
import 'package:orderly/features/shipments/presentation/widgets/loading_view.dart';
import 'package:orderly/features/shipments/presentation/widgets/summary_card.dart';



class ShipmentTrackingArgs {
  final String shipmentId;
  const ShipmentTrackingArgs({required this.shipmentId});
}
class ShipmentTrackingScreen extends StatefulWidget {
  final String shipmentId;

  const ShipmentTrackingScreen({
    super.key,
    required this.shipmentId,
  });

  @override
  State<ShipmentTrackingScreen> createState() => _ShipmentTrackingScreenState();
}

class _ShipmentTrackingScreenState extends State<ShipmentTrackingScreen>
    with TickerProviderStateMixin {
  // Header animation
  late final AnimationController _headerCtrl;
  late final Animation<Offset>   _headerSlide;
  late final Animation<double>   _headerFade;

  // Card animation
  late final AnimationController _cardCtrl;
  late final Animation<Offset>   _cardSlide;
  late final Animation<double>   _cardFade;

  // Timeline items stagger
  late final AnimationController _timelineCtrl;

  // Pulse for active dot
  late final AnimationController _pulseCtrl;

  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    _headerCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeIn);

    _cardCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic));
    _cardFade = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeIn);

    _timelineCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);

    // Stagger start
    _headerCtrl.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _cardCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 380), () {
      if (mounted) _timelineCtrl.forward();
    });

    context.read<ShipmentBloc>().add(GetShipmentTracking(widget.shipmentId));
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _cardCtrl.dispose();
    _timelineCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<ShipmentBloc>().add(RefreshShipmentTracking(widget.shipmentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _onRefresh,
          color: AppColors.amber,
          backgroundColor: AppColors.surface,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _headerSlide,
                  child: FadeTransition(
                    opacity: _headerFade,
                    child: Header(onBack: () => context.pop()),
                  ),
                ),
              ),

              
              BlocBuilder<ShipmentBloc, ShipmentState>(
                builder: (context, state) {
                  if (state is ShipmentLoading) {
                    return const SliverFillRemaining(
                      child: LoadingView(),
                    );
                  }
                  if (state is ShipmentFailure) {
                    return SliverFillRemaining(
                      child: ErrorView(
                        error: state.error,
                        onRetry: () => context.read<ShipmentBloc>()
                            .add(GetShipmentTracking(widget.shipmentId)),
                      ),
                    );
                  }
                  if (state is ShipmentLoaded) {
                    return SliverList(
                      delegate: SliverChildListDelegate([
                        
                        SlideTransition(
                          position: _cardSlide,
                          child: FadeTransition(
                            opacity: _cardFade,
                            child: SummaryCard(
                              shipmentId: widget.shipmentId,
                              trackingData: state.trackingResponse.data,
                              pulseCtrl: _pulseCtrl,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Timeline label
                        FadeTransition(
                          opacity: _cardFade,
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(24, 8, 24, 16),
                            child: Text(
                              'TRACKING HISTORY',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.muted,
                                letterSpacing: 1.8,
                              ),
                            ),
                          ),
                        ),
                        // Timeline
                        AnimatedTimeline(
                          trackingData: state.trackingResponse.data,
                          controller: _timelineCtrl,
                          pulseCtrl: _pulseCtrl,
                        ),
                        const SizedBox(height: 32),
                      ]),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
extension ShipmentStatusX on ShipmentStatus {
  String get rawTag {
    switch (this) {
      case ShipmentStatus.pending:       return 'Pending';
      case ShipmentStatus.dispatched:    return 'Dispatched';
      case ShipmentStatus.inTransit:     return 'In Transit';
      case ShipmentStatus.outForDelivery:return 'Out for Delivery';
      case ShipmentStatus.delivered:     return 'Delivered';
    }
  }

  Color get color {
    switch (this) {
      case ShipmentStatus.pending:        return AppColors.muted;
      case ShipmentStatus.dispatched:     return AppColors.purple;
      case ShipmentStatus.inTransit:      return AppColors.blue;
      case ShipmentStatus.outForDelivery: return AppColors.amber;
      case ShipmentStatus.delivered:      return AppColors.green;
    }
  }
}