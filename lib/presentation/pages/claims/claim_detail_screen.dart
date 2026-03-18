import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class ClaimDetailScreen extends StatelessWidget {
  final Map<String, String> claim;

  const ClaimDetailScreen({super.key, required this.claim});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.claimDetails),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: l10n.claimDetails,
              children: [
                _buildDetailRow(l10n.claimNumber, claim['claimNumber']!),
                _buildDetailRow(l10n.policyNumber, claim['policyNumber']!),
                _buildDetailRow(l10n.submissionDate, claim['submissionDate']!),
                _buildDetailRow(l10n.claimType, claim['claimType']!),
                _buildDetailRow(l10n.claimStatus, claim['status']!),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: l10n.incidentDetails,
              children: [
                _buildDetailRow(l10n.incidentDate, claim['incidentDate']!),
                _buildDetailRow(
                  l10n.incidentDescription,
                  claim['incidentDescription']!,
                ),
                _buildDetailRow(l10n.hospitalName, claim['hospitalName']!),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: l10n.claimAmount,
              children: [
                _buildDetailRow(l10n.claimAmount, 'Rp ${claim['claimAmount']}'),
                if (claim['approvedAmount']!.isNotEmpty)
                  _buildDetailRow(
                    l10n.approvedAmount,
                    'Rp ${claim['approvedAmount']}',
                  ),
              ],
            ),
            if (claim['processedDate']!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSection(
                title: l10n.processedDate,
                children: [
                  _buildDetailRow(l10n.processedDate, claim['processedDate']!),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
