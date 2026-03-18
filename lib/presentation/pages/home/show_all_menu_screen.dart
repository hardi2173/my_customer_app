import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../policy/policy_tracker_screen.dart';
import '../claims/claim_tracker_screen.dart';
import '../claims/claim_submission_screen.dart';
import '../account/account_management_screen.dart';
import '../product/product_list_screen.dart';
import '../illustration/illustration_list_screen.dart';
import '../proposal/proposal_list_screen.dart';
import '../notification/notification_screen.dart';
import '../app/change_language_screen.dart';
import '../app/about_screen.dart';

class ShowAllMenuScreen extends StatelessWidget {
  const ShowAllMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.showAll),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context: context,
              title: l10n.portfolio,
              icon: Icons.account_balance_wallet,
              features: [
                _FeatureItem(
                  icon: Icons.account_balance_wallet,
                  label: l10n.portfolio,
                  color: AppColors.primary,
                  onTap: () =>
                      _navigateTo(context, const PolicyTrackerScreen()),
                ),
                _FeatureItem(
                  icon: Icons.inventory_2,
                  label: l10n.products,
                  color: Colors.orange,
                  onTap: () => _navigateTo(context, const ProductListScreen()),
                ),
                _FeatureItem(
                  icon: Icons.auto_graph,
                  label: l10n.illustrations,
                  color: AppColors.secondary,
                  onTap: () =>
                      _navigateTo(context, const IllustrationListScreen()),
                ),
                _FeatureItem(
                  icon: Icons.assignment_ind,
                  label: l10n.proposals,
                  color: AppColors.accent,
                  onTap: () => _navigateTo(context, const ProposalListScreen()),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: l10n.claims,
              icon: Icons.assignment,
              features: [
                _FeatureItem(
                  icon: Icons.assignment,
                  label: l10n.claims,
                  color: AppColors.info,
                  onTap: () =>
                      _navigateTo(context, const ClaimsTrackerScreen()),
                ),
                _FeatureItem(
                  icon: Icons.add_circle,
                  label: l10n.submitClaim,
                  color: AppColors.secondary,
                  onTap: () =>
                      _navigateTo(context, const ClaimSubmissionScreen()),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: l10n.account,
              icon: Icons.person,
              features: [
                _FeatureItem(
                  icon: Icons.settings,
                  label: l10n.settings,
                  color: AppColors.primary,
                  onTap: () =>
                      _navigateTo(context, const AccountManagementScreen()),
                ),
                _FeatureItem(
                  icon: Icons.notifications,
                  label: l10n.notifications,
                  color: AppColors.secondary,
                  onTap: () => _navigateTo(context, const NotificationScreen()),
                ),
                _FeatureItem(
                  icon: Icons.language,
                  label: l10n.language,
                  color: AppColors.accent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChangeLanguageScreen(onLocaleChanged: (locale) {}),
                      ),
                    );
                  },
                ),
                _FeatureItem(
                  icon: Icons.info,
                  label: l10n.about,
                  color: AppColors.info,
                  onTap: () => _navigateTo(context, const AboutScreen()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<_FeatureItem> features,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: features.map((feature) {
            return _FeatureButton(
              icon: feature.icon,
              label: feature.label,
              color: feature.color,
              onTap: feature.onTap,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _FeatureItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _FeatureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FeatureButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
