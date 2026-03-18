import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/register_model.dart';
import '../../../data/models/account_detail_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/account/account_bloc.dart';
import '../../bloc/account/account_event.dart';
import '../../bloc/account/account_state.dart';

class EditContactScreen extends StatefulWidget {
  final ContactModel contact;

  const EditContactScreen({super.key, required this.contact});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contactNumberController;
  late String _contactType;

  final List<String> _contactTypes = ['PHONE', 'HOME', 'OFFICE', 'EMAIL'];

  @override
  void initState() {
    super.initState();
    _contactNumberController = TextEditingController(
      text: widget.contact.contactNumber,
    );
    _contactType = widget.contact.contactType;
  }

  @override
  void dispose() {
    _contactNumberController.dispose();
    super.dispose();
  }

  String _getContactTypeLabel(String type) {
    switch (type) {
      case 'PHONE':
        return 'Phone';
      case 'HOME':
        return 'Home';
      case 'OFFICE':
        return 'Office';
      case 'EMAIL':
        return 'Email';
      default:
        return type;
    }
  }

  void _saveContact() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = ContactRequest(
        contactType: _contactType,
        contactNumber: _contactNumberController.text,
      );

      context.read<AccountBloc>().add(
        UpdateContact(id: widget.contact.id, request: request),
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
              content: Text(l10n.contactUpdated),
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
              title: Text(l10n.editContact),
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
                      label: 'Type',
                      value: _contactType,
                      items: _contactTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(_getContactTypeLabel(type)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _contactType = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _contactNumberController,
                      label: _contactType == 'EMAIL'
                          ? l10n.email
                          : l10n.phoneNumber,
                      keyboardType: _contactType == 'EMAIL'
                          ? TextInputType.emailAddress
                          : TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.required;
                        }
                        if (_contactType == 'EMAIL') {
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return l10n.invalidEmail;
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : _saveContact,
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
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
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
