import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class PolicyTrackerScreen extends StatelessWidget {
  const PolicyTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.portfolio),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockPolicies.length,
        itemBuilder: (context, index) {
          final policy = _mockPolicies[index];
          return _PolicyCard(
            policyNumber: policy['policyNumber']!,
            status: policy['status']!,
            productCode: policy['productCode']!,
            productName: policy['productName']!,
            contractPeriod: policy['contractPeriod']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PolicyDetailScreen(policy: policy),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final String policyNumber;
  final String status;
  final String productCode;
  final String productName;
  final String contractPeriod;
  final VoidCallback onTap;

  const _PolicyCard({
    required this.policyNumber,
    required this.status,
    required this.productCode,
    required this.productName,
    required this.contractPeriod,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      policyNumber,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _StatusChip(status: status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$productCode - $productName',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${l10n.contractPeriod}: $contractPeriod',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        break;
      case 'pending':
        backgroundColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        break;
      case 'lapsed':
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        break;
      default:
        backgroundColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class PolicyDetailScreen extends StatelessWidget {
  final Map<String, String> policy;

  const PolicyDetailScreen({super.key, required this.policy});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.policyDetail),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: l10n.policyDetails,
              children: [
                _buildDetailRow(l10n.policyNumber, policy['policyNumber']!),
                _buildDetailRow(l10n.policyStatus, policy['status']!),
                _buildDetailRow(
                  l10n.productName,
                  '${policy['productCode']} - ${policy['productName']}',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: l10n.contractPeriod,
              children: [
                _buildDetailRow(l10n.issueDate, policy['issueDate']!),
                _buildDetailRow(l10n.maturityDate, policy['maturityDate']!),
                _buildDetailRow(l10n.contractPeriod, policy['contractPeriod']!),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: l10n.premium,
              children: [
                _buildDetailRow(
                  l10n.premiumAmount,
                  'Rp ${policy['premiumAmount']}',
                ),
                _buildDetailRow(
                  l10n.premiumFrequency,
                  policy['premiumFrequency']!,
                ),
                _buildDetailRow(l10n.paymentMethod, policy['paymentMethod']!),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: l10n.coverageAmount,
              children: [
                _buildDetailRow(l10n.sumAssured, 'Rp ${policy['sumAssured']}'),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: l10n.policyOwner,
              children: [
                _buildDetailRow(l10n.policyHolder, policy['policyHolder']!),
                _buildDetailRow(l10n.insuredPerson, policy['insuredPerson']!),
                _buildDetailRow(l10n.beneficiary, policy['beneficiary']!),
              ],
            ),
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
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> _mockPolicies = [
  {
    'policyNumber': 'POL/2023/001234',
    'status': 'Active',
    'productCode': 'HL',
    'productName': 'Heritage Life',
    'contractPeriod': '10 Years',
    'issueDate': '01 Jan 2023',
    'maturityDate': '01 Jan 2033',
    'premiumAmount': '2.500.000',
    'premiumFrequency': 'Yearly',
    'paymentMethod': 'Auto Debit',
    'sumAssured': '500.000.000',
    'policyHolder': 'John Doe',
    'insuredPerson': 'John Doe',
    'beneficiary': 'Jane Doe (Wife)',
  },
  {
    'policyNumber': 'POL/2023/001235',
    'status': 'Active',
    'productCode': 'HP',
    'productName': 'Health Protection',
    'contractPeriod': '5 Years',
    'issueDate': '15 Mar 2023',
    'maturityDate': '15 Mar 2028',
    'premiumAmount': '1.200.000',
    'premiumFrequency': 'Monthly',
    'paymentMethod': 'Auto Debit',
    'sumAssured': '100.000.000',
    'policyHolder': 'John Doe',
    'insuredPerson': 'John Doe',
    'beneficiary': 'Jane Doe (Wife)',
  },
  {
    'policyNumber': 'POL/2024/001236',
    'status': 'Pending',
    'productCode': 'PA',
    'productName': 'Personal Accident',
    'contractPeriod': '1 Year',
    'issueDate': '01 Feb 2024',
    'maturityDate': '01 Feb 2025',
    'premiumAmount': '500.000',
    'premiumFrequency': 'Yearly',
    'paymentMethod': 'Pending',
    'sumAssured': '50.000.000',
    'policyHolder': 'John Doe',
    'insuredPerson': 'John Doe',
    'beneficiary': 'Jane Doe (Wife)',
  },
  {
    'policyNumber': 'POL/2022/001230',
    'status': 'Lapsed',
    'productCode': 'EDU',
    'productName': 'Education Plan',
    'contractPeriod': '15 Years',
    'issueDate': '01 Jun 2022',
    'maturityDate': '01 Jun 2037',
    'premiumAmount': '1.800.000',
    'premiumFrequency': 'Monthly',
    'paymentMethod': 'Cancelled',
    'sumAssured': '200.000.000',
    'policyHolder': 'John Doe',
    'insuredPerson': 'Baby Doe (Child)',
    'beneficiary': 'John Doe (Father)',
  },
];
