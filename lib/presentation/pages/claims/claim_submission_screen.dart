import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class ClaimSubmissionScreen extends StatefulWidget {
  const ClaimSubmissionScreen({super.key});

  @override
  State<ClaimSubmissionScreen> createState() => _ClaimSubmissionScreenState();
}

class _ClaimSubmissionScreenState extends State<ClaimSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPolicy;
  String? _selectedClaimType;
  DateTime _incidentDate = DateTime.now();
  final _claimAmountController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final List<Map<String, String>> _policies = [
    {'number': 'POL/2023/001234', 'name': 'Heritage Life'},
    {'number': 'POL/2023/001235', 'name': 'Health Protection'},
  ];

  final List<String> _claimTypes = [
    'Hospitalization',
    'Surgical',
    'Accident',
    'Critical Illness',
    'Death',
  ];

  @override
  void dispose() {
    _claimAmountController.dispose();
    _hospitalNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitClaim() {
    if (_formKey.currentState?.validate() ?? false) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.claimSubmitted),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _incidentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _incidentDate) {
      setState(() {
        _incidentDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.claimSubmission),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropdownField(
                label: l10n.selectPolicy,
                value: _selectedPolicy,
                items: _policies.map((policy) {
                  return DropdownMenuItem(
                    value: policy['number'],
                    child: Text('${policy['number']} - ${policy['name']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedPolicy = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: l10n.claimType,
                value: _selectedClaimType,
                items: _claimTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getClaimTypeLabel(type, l10n)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedClaimType = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDateField(
                label: l10n.incidentDate,
                value: _formatDate(_incidentDate),
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _claimAmountController,
                label: l10n.claimAmount,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _hospitalNameController,
                label: l10n.hospitalName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: l10n.incidentDescription,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.required;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitClaim,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.submitClaim,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value),
                const Icon(Icons.calendar_today, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getClaimTypeLabel(String type, AppLocalizations l10n) {
    switch (type) {
      case 'Hospitalization':
        return l10n.hospitalization;
      case 'Surgical':
        return l10n.surgical;
      case 'Accident':
        return l10n.accident;
      case 'Critical Illness':
        return l10n.criticalIllness;
      case 'Death':
        return l10n.death;
      default:
        return type;
    }
  }
}
