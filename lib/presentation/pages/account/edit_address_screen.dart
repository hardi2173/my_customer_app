import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/register_model.dart';
import '../../../data/models/account_detail_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/account/account_bloc.dart';
import '../../bloc/account/account_event.dart';
import '../../bloc/account/account_state.dart';

class EditAddressScreen extends StatefulWidget {
  final AddressModel address;

  const EditAddressScreen({super.key, required this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _line1Controller;
  late TextEditingController _line2Controller;
  late TextEditingController _provinceController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _subDistrictController;
  late String _addressType;

  final List<String> _addressTypes = ['HOME', 'OFFICE', 'CORRESPONDENCE'];

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _line1Controller = TextEditingController(text: address.addressLine1 ?? '');
    _line2Controller = TextEditingController(text: address.addressLine2 ?? '');
    _provinceController = TextEditingController(
      text: address.addressProvince ?? '',
    );
    _cityController = TextEditingController(text: address.addressCity ?? '');
    _districtController = TextEditingController(
      text: address.addressDistrict ?? '',
    );
    _subDistrictController = TextEditingController(
      text: address.addressSubDistrict ?? '',
    );
    _addressType = address.addressType;
  }

  @override
  void dispose() {
    _line1Controller.dispose();
    _line2Controller.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _subDistrictController.dispose();
    super.dispose();
  }

  String _getAddressTypeLabel(String type) {
    switch (type) {
      case 'HOME':
        return 'Home';
      case 'OFFICE':
        return 'Office';
      case 'CORRESPONDENCE':
        return 'Correspondence';
      default:
        return type;
    }
  }

  void _saveAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = AddressRequest(
        addressType: _addressType,
        addressLine1: _line1Controller.text.isNotEmpty
            ? _line1Controller.text
            : null,
        addressLine2: _line2Controller.text.isNotEmpty
            ? _line2Controller.text
            : null,
        addressProvince: _provinceController.text.isNotEmpty
            ? _provinceController.text
            : null,
        addressCity: _cityController.text.isNotEmpty
            ? _cityController.text
            : null,
        addressDistrict: _districtController.text.isNotEmpty
            ? _districtController.text
            : null,
        addressSubDistrict: _subDistrictController.text.isNotEmpty
            ? _subDistrictController.text
            : null,
      );

      context.read<AccountBloc>().add(
        UpdateAddress(id: widget.address.id, request: request),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (state.status == AccountStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.addressUpdated),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
        } else if (state.status == AccountStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? l10n.error),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          final isLoading = state.status == AccountStatus.loading;

          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.editAddress),
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
                      label: l10n.addressType,
                      value: _addressType,
                      items: _addressTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(_getAddressTypeLabel(type)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _addressType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _line1Controller,
                      label: l10n.street,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.required;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _line2Controller,
                      label: '${l10n.street} 2',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _provinceController,
                      label: l10n.province,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _cityController,
                      label: l10n.city,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _districtController,
                      label: l10n.district,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _subDistrictController,
                      label: l10n.subDistrict,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : _saveAddress,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.saveChanges,
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
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
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
}
