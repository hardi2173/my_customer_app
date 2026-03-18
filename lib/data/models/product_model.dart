import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String code;
  final String name;
  final String type;
  final String marketingChannel;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  const ProductModel({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.marketingChannel,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      marketingChannel: json['marketingChannel'] as String? ?? '',
      description: json['description'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'type': type,
      'marketingChannel': marketingChannel,
      if (description != null) 'description': description,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    type,
    marketingChannel,
    description,
    createdAt,
    updatedAt,
  ];
}

class ProductListResponse extends Equatable {
  final List<ProductModel> data;
  final ProductMeta meta;

  const ProductListResponse({required this.data, required this.meta});

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    final dataWrapper = json['data'] as Map<String, dynamic>? ?? {};
    final dataList = dataWrapper['data'] as List<dynamic>? ?? [];
    return ProductListResponse(
      data: dataList
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: ProductMeta.fromJson(
        dataWrapper['meta'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  @override
  List<Object?> get props => [data, meta];
}

class ProductMeta extends Equatable {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const ProductMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory ProductMeta.fromJson(Map<String, dynamic> json) {
    return ProductMeta(
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }

  @override
  List<Object?> get props => [total, page, limit, totalPages];
}
