import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:orderly/features/payments/domain/bloc/payment_event.dart';
import 'package:orderly/features/payments/domain/bloc/payment_state.dart';
import 'package:orderly/features/payments/domain/repositories/payment_repository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;
  final Razorpay _razorpay;

  PaymentBloc({
    required PaymentRepository paymentRepository,
  })  : _paymentRepository = paymentRepository,
        _razorpay = Razorpay(),
        super(const PaymentInitial()) {
    on<CreatePaymentEvent>(_onCreatePayment);
    on<InitiateRazorpayPaymentEvent>(_onInitiateRazorpayPayment);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<ResetPaymentStateEvent>(_onResetState);

    // Setup Razorpay event handlers
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Future<void> close() {
    _razorpay.clear();
    return super.close();
  }

  Future<void> _onCreatePayment(
    CreatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    try {
      final payment = await _paymentRepository.createPayment(
        orderId: event.orderId,
        userId: event.userId,
        razorpayOrderId: '', // Will be set after Razorpay order creation
        amount: event.amount,
        status: 'CREATED',
      );
      emit(PaymentCreated(payment));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onInitiateRazorpayPayment(
    InitiateRazorpayPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    try {
      // Create Razorpay order options
      final options = {
        'key': 'rzp_test_SL4NVWFOnGCwCT', // Replace with your Razorpay key
        'amount': (event.amount * 100).toInt(), // Amount in paise
        'name': 'Orderly',
        'description': 'Order #${event.orderId}',
        'order_id': (event.orderId), // Will be set if you create order from backend
        'prefill': {
          'contact': '+919999999999',
          'email': 'customer@example.com',
        },
        'theme': {
          'color': '#1A1A2E',
        },
      };

      // Open Razorpay payment modal
      _razorpay.open(options);

      // Emit state to show payment is initiated
      emit(RazorpayPaymentInitiated(
        razorpayOrderId: "", // This will be set in the success callback
        orderId: event.orderId,
        amount: event.amount,
      ));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    try {
      final payment = await _paymentRepository.verifyPayment(
        razorpayOrderId: event.razorpayOrderId,
        razorpayPaymentId: event.razorpayPaymentId,
        razorpaySignature: event.razorpaySignature,
      );
      emit(PaymentVerified(payment));
    } catch (e) {
      emit(PaymentFailure(e.toString()));
    }
  }

  Future<void> _onResetState(
    ResetPaymentStateEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentInitial());
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // This will be called when Razorpay payment is successful
    // You can emit a success state or handle verification
    add(VerifyPaymentEvent(
      razorpayOrderId: response.orderId?.toString() ?? '',
      razorpayPaymentId: response.paymentId?.toString() ?? '',
      razorpaySignature: response.signature?.toString() ?? '',
    ));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // This will be called when Razorpay payment fails
    add(ResetPaymentStateEvent());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection if needed
  }
}
