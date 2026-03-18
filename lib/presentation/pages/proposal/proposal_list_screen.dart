import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

class ProposalListScreen extends StatelessWidget {
  const ProposalListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.proposals),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(child: Text(l10n.proposals)),
    );
  }
}
