import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AuthRepository _authRepository;
  static const int _defaultLimit = 5;

  ProductBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ProductState()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<LoadProductDetail>(_onLoadProductDetail);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final response = await _authRepository.getProducts(
        page: event.page,
        limit: event.limit,
      );
      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: response.data,
          currentPage: response.meta.page,
          totalPages: response.meta.totalPages,
          hasMore: response.meta.page < response.meta.totalPages,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (!state.hasMore || state.status == ProductStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: ProductStatus.loadingMore));

    try {
      final nextPage = state.currentPage + 1;
      final response = await _authRepository.getProducts(
        page: nextPage,
        limit: _defaultLimit,
      );
      emit(
        state.copyWith(
          status: ProductStatus.success,
          products: [...state.products, ...response.data],
          currentPage: response.meta.page,
          totalPages: response.meta.totalPages,
          hasMore: response.meta.page < response.meta.totalPages,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final product = await _authRepository.getProductById(event.id);
      emit(
        state.copyWith(status: ProductStatus.success, selectedProduct: product),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
