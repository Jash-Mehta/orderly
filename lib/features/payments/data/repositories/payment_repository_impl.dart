import 'package:dio/dio.dart';
import 'package:orderly/core/api/api_result.dart';
import 'package:orderly/core/di/service_locator.dart';
import 'package:orderly/core/network/api_client.dart';
import 'package:orderly/core/utils/methods/failure/app_failure.dart';
import 'package:orderly/features/payments/data/models/payment.dart';
import 'package:orderly/features/payments/data/models/payment_request.dart';
import 'package:orderly/features/payments/data/models/payment_verification_request.dart';
import 'package:orderly/features/payments/data/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
 

  @override
  Future<Payment> createPayment({
    required String orderId,
    required String userId,
    required String razorpayOrderId,
    required double amount,
    required String status,
  }) async {
    try {
      final request = PaymentRequest(
        orderId: orderId,
        userId: userId,
        razorpayOrderId: razorpayOrderId,
        amount: amount,
        status: status,
      );

      final result = await apiClient.post(
        '/api/payments',
        body: request.toJson(),
      );

      switch (result) {
        case Success(:final value):
          return Payment.fromJson(value['data']);
        case Failure(:final failure):
          throw Exception('Failed to create payment: ${failure.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Payment> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final request = PaymentVerificationRequest(
        razorpayOrderId: razorpayOrderId,
        razorpayPaymentId: razorpayPaymentId,
        razorpaySignature: razorpaySignature,
      );

      final result = await apiClient.post(
        '/api/payments/verify',
        body: request.toJson(),
      );

      switch (result) {
        case Success(:final value):
          return Payment.fromJson(value['data']);
        case Failure(:final failure):
          throw Exception('Failed to verify payment: ${failure.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Payment?> getPaymentByOrderId(String orderId) async {
    try {
      final result = await apiClient.get('/api/payments/order/$orderId');

      switch (result) {
        case Success(:final value):
          return Payment.fromJson(value['data']);
        case Failure():
          return null;
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<Payment?> getPaymentByRazorpayId(String razorpayPaymentId) async {
    try {
      final result = await apiClient.get('/api/payments/razorpay/$razorpayPaymentId');

      switch (result) {
        case Success(:final value):
          return Payment.fromJson(value['data']);
        case Failure():
          return null;
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<Payment>> getUserPayments(String userId) async {
    try {
      final result = await apiClient.get('/api/payments/user/$userId');

      switch (result) {
        case Success(:final value):
          final List<dynamic> data = value['data'];
          return data.map((json) => Payment.fromJson(json)).toList();
        case Failure():
          return [];
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
