import 'package:equatable/equatable.dart';

import '../../../data/models/product_model.dart';

enum ProductStatus { initial, loading, success, failure, loadingMore }

class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductModel> products;
  final ProductModel? selectedProduct;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.selectedProduct,
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.hasMore = false,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? products,
    ProductModel? selectedProduct,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    products,
    selectedProduct,
    errorMessage,
    currentPage,
    totalPages,
    hasMore,
  ];
}
