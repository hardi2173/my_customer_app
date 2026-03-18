import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import 'claim_detail_screen.dart';
import 'claim_submission_screen.dart';

class ClaimsTrackerScreen extends StatelessWidget {
  const ClaimsTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.claimsTracker),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _mockClaims.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noClaimsFound,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _mockClaims.length,
              itemBuilder: (context, index) {
                final claim = _mockClaims[index];
                return _ClaimCard(
                  claimNumber: claim['claimNumber']!,
                  policyNumber: claim['policyNumber']!,
                  submissionDate: claim['submissionDate']!,
                  claimType: claim['claimType']!,
                  status: claim['status']!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClaimDetailScreen(claim: claim),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClaimSubmissionScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _ClaimCard extends StatelessWidget {
  final String claimNumber;
  final String policyNumber;
  final String submissionDate;
  final String claimType;
  final String status;
  final VoidCallback onTap;

  const _ClaimCard({
    required this.claimNumber,
    required this.policyNumber,
    required this.submissionDate,
    required this.claimType,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                      claimNumber,
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
              Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    policyNumber,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
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
                    submissionDate,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    claimType,
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
      case 'submitted':
        backgroundColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
        break;
      case 'in review':
        backgroundColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        break;
      case 'approved':
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        break;
      case 'rejected':
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        break;
      case 'paid':
        backgroundColor = AppColors.success.withValues(alpha: 0.2);
        textColor = AppColors.success;
        break;
      default:
        backgroundColor = AppColors.textSecondary.withValues(alpha: 0.1);
        textColor = AppColors.textSecondary;
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

final List<Map<String, String>> _mockClaims = [
  {
    'claimNumber': 'CLM/2024/0001',
    'policyNumber': 'POL/2023/001234',
    'submissionDate': '15 Jan 2024',
    'claimType': 'Hospitalization',
    'status': 'In Review',
    'claimAmount': '15.000.000',
    'hospitalName': 'RS Siloam',
    'incidentDate': '10 Jan 2024',
    'incidentDescription': 'Rawat inap akibat panas dalam',
    'approvedAmount': '',
    'processedDate': '',
  },
  {
    'claimNumber': 'CLM/2024/0002',
    'policyNumber': 'POL/2023/001235',
    'submissionDate': '20 Jan 2024',
    'claimType': 'Surgical',
    'status': 'Approved',
    'claimAmount': '50.000.000',
    'hospitalName': 'RS Pondok Indah',
    'incidentDate': '18 Jan 2024',
    'incidentDescription': 'Operasi appendectomy',
    'approvedAmount': '45.000.000',
    'processedDate': '25 Jan 2024',
  },
  {
    'claimNumber': 'CLM/2024/0003',
    'policyNumber': 'POL/2023/001234',
    'submissionDate': '01 Feb 2024',
    'claimType': 'Accident',
    'status': 'Submitted',
    'claimAmount': '10.000.000',
    'hospitalName': 'RS Mitra Keluarga',
    'incidentDate': '30 Jan 2024',
    'incidentDescription': 'Kecelakaan lalu lintas',
    'approvedAmount': '',
    'processedDate': '',
  },
  {
    'claimNumber': 'CLM/2023/0045',
    'policyNumber': 'POL/2022/001230',
    'submissionDate': '10 Dec 2023',
    'claimType': 'Critical Illness',
    'status': 'Paid',
    'claimAmount': '100.000.000',
    'hospitalName': 'RS Cipto Mangunkusumo',
    'incidentDate': '05 Dec 2023',
    'incidentDescription': 'Diagnosa kanker stadium 2',
    'approvedAmount': '100.000.000',
    'processedDate': '20 Dec 2023',
  },
  {
    'claimNumber': 'CLM/2023/0030',
    'policyNumber': 'POL/2023/001235',
    'submissionDate': '15 Nov 2023',
    'claimType': 'Hospitalization',
    'status': 'Rejected',
    'claimAmount': '5.000.000',
    'hospitalName': 'RS Permata',
    'incidentDate': '10 Nov 2023',
    'incidentDescription': 'Rawat inap',
    'approvedAmount': '',
    'processedDate': '20 Nov 2023',
  },
];
