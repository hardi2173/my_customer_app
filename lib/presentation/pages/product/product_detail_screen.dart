import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/product_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/product/product_bloc.dart';
import '../../bloc/product/product_event.dart';
import '../../bloc/product/product_state.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(LoadProductDetail(id: productId));
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final product = state.selectedProduct;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.productDetail),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: _buildBody(context, state, l10n, product),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProductState state,
    AppLocalizations l10n,
    ProductModel? product,
  ) {
    if (state.status == ProductStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ProductStatus.failure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.errorMessage ?? l10n.error),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ProductBloc>().add(
                  LoadProductDetail(id: productId),
                );
              },
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (product == null) {
      return Center(child: Text(l10n.error));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailCard(
            title: l10n.productCode,
            value: product.code,
            icon: Icons.code,
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: l10n.productName,
            value: product.name,
            icon: Icons.inventory_2,
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: l10n.productType,
            value: _formatProductType(product.type),
            icon: Icons.category,
          ),
          const SizedBox(height: 16),
          _buildDetailCard(
            title: l10n.marketingChannel,
            value: _formatMarketingChannel(product.marketingChannel),
            icon: Icons.store,
          ),
          if (product.description != null &&
              product.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildDetailCard(
              title: l10n.description,
              value: product.description!,
              icon: Icons.description,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
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

  String _formatMarketingChannel(String channel) {
    switch (channel) {
      case 'BANCASSURANCE':
        return 'Bancassurance';
      case 'DIRECT':
        return 'Direct';
      case 'DIGITAL':
        return 'Digital';
      default:
        return channel;
    }
  }
}
