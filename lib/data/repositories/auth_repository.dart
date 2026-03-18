import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../datasources/api_client.dart';
import '../models/login_model.dart';
import '../models/account_detail_model.dart';
import '../models/register_model.dart';
import '../models/product_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<void> initAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    debugPrint('initAuthToken - Token from prefs: $token');
    if (token != null && token.isNotEmpty) {
      _apiClient.setAuthToken(token);
      debugPrint('initAuthToken - Token set to ApiClient');
    }
  }

  void setAuthToken(String token) {
    _apiClient.setAuthToken(token);
  }

  void clearAuthToken() {
    _apiClient.clearAuthToken();
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.refreshTokenKey);
    await prefs.remove(AppConstants.userKey);
    _apiClient.clearAuthToken();
  }

  Future<LoginResponseModel> login({
    required String username,
    required String password,
    required String deviceId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: LoginRequestModel(
          username: username,
          password: password,
        ).toJson(),
        headers: {'device_id': deviceId},
      );

      return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<RegisterResponseModel> register({
    required RegisterRequestModel request,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: request.toJson(),
      );

      return RegisterResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleRegisterError(e);
    }
  }

  Future<AccountDetailModel> getAccountDetail() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.accountDetail);
      return AccountDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<AccountDetailModel> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.accountProfile,
        data: request.toJson(),
      );
      return AccountDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<AddressModel> createAddress(AddressRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.accountAddresses,
        data: request.toJson(),
      );
      return AddressModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<AddressModel> updateAddress(String id, AddressRequest request) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.accountAddress(id),
        data: request.toJson(),
      );
      return AddressModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _apiClient.delete(ApiEndpoints.accountAddress(id));
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ContactModel> createContact(ContactRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.accountContacts,
        data: request.toJson(),
      );
      return ContactModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ContactModel> updateContact(String id, ContactRequest request) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.accountContact(id),
        data: request.toJson(),
      );
      return ContactModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteContact(String id) async {
    try {
      await _apiClient.delete(ApiEndpoints.accountContact(id));
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.connectionError:
        final message = e.message ?? 'No internet connection';
        return Exception(message);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final errorData = e.response?.data;
        String? errorMessage;

        if (errorData != null && errorData is Map<String, dynamic>) {
          errorMessage =
              errorData['message'] as String? ??
              (errorData['data'] as Map<String, dynamic>?)?['message']
                  as String? ??
              errorData['errors'] as String?;
        }

        if (statusCode == 401) {
          if (errorMessage != null && errorMessage.isNotEmpty) {
            return Exception(errorMessage);
          }
          return Exception('Invalid username or password.');
        } else if (statusCode == 400) {
          return Exception(
            errorMessage ??
                'Maximum devices reached. Please logout from another device.',
          );
        }
        return Exception(
          errorMessage ?? 'Server error. Please try again later.',
        );
      default:
        final message = e.message ?? 'An unexpected error occurred';
        return Exception(message);
    }
  }

  Exception _handleRegisterError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.connectionError:
        final message = e.message ?? 'No internet connection';
        return Exception(message);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) {
          final errorData = e.response?.data;
          if (errorData != null && errorData is Map<String, dynamic>) {
            final errorMessage =
                errorData['error'] as String? ??
                errorData['message'] as String? ??
                'Registration failed. Please check your details.';
            return Exception(errorMessage);
          }
          return Exception('Registration failed. Please check your details.');
        }
        return Exception('Server error. Please try again later.');
      default:
        final message = e.message ?? 'An unexpected error occurred';
        return Exception(message);
    }
  }

  Future<ProductListResponse> getProducts({int page = 1, int limit = 5}) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.products,
        queryParameters: {'page': page, 'limit': limit},
      );
      return ProductListResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.productDetail(id));
      final data = response.data as Map<String, dynamic>;
      return ProductModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}
