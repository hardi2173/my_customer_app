import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/product_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/product/product_bloc.dart';
import '../../bloc/product/product_event.dart';
import '../../bloc/product/product_state.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadProducts(page: 1, limit: 5));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.products),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.status == ProductStatus.loading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ProductStatus.failure && state.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? l10n.error),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(
                        const LoadProducts(page: 1, limit: 5),
                      );
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          if (state.products.isEmpty) {
            return Center(child: Text(l10n.noData));
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollEndNotification) {
                final metrics = notification.metrics;
                if (metrics.pixels >= metrics.maxScrollExtent - 100) {
                  context.read<ProductBloc>().add(const LoadMoreProducts());
                }
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<ProductBloc>().add(
                  const LoadProducts(page: 1, limit: 5),
                );
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.products.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.products.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final product = state.products[index];
                  return _buildProductCard(product, l10n);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(ProductModel product, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: product.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.health_and_safety,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.code,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatProductType(product.type),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  String _formatProductType(String type) {
    switch (type) {
      case 'INDIVIDU_TRADITIONAL':
        return 'Individu Traditional';
      case 'INDIVIDU_UNITLINK':
        return 'Individu Unitlink';
      case 'INDIVIDU_ENDOWMENT':
        return 'Individu Endowment';
      case 'INDIVIDU_PENDIDIKAN':
        return 'Individu Pendidikan';
      case 'INDIVIDU_HEALTHCARE':
        return 'Individu Healthcare';
      case 'GROUP_TERMLIFE':
        return 'Group Termlife';
      case 'GROUP_HEALTHCARE':
        return 'Group Healthcare';
      default:
        return type;
    }
  }
}
