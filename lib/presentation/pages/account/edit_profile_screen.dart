import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/account_detail_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/account/account_bloc.dart';
import '../../bloc/account/account_event.dart';
import '../../bloc/account/account_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _pobController;
  DateTime _dob = DateTime.now();
  String _nationality = 'Indonesia';
  String _religion = 'Christian';
  bool _isInitialized = false;
  bool _isUpdating = false;

  final List<String> _nationalities = [
    'Indonesia',
    'Malaysia',
    'Singapore',
    'Other',
  ];
  final List<String> _religions = [
    'Islam',
    'Christian',
    'Catholic',
    'Hindu',
    'Buddha',
    'Confucian',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _pobController = TextEditingController();
    context.read<AccountBloc>().add(const LoadAccountDetail());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _pobController.dispose();
    super.dispose();
  }

  void _initializeFromAccount(AccountDetailModel account) {
    if (_isInitialized) return;

    final profile = account.profile;
    _firstNameController.text = profile.firstName ?? '';
    _lastNameController.text = profile.lastName ?? '';
    _pobController.text = profile.pob ?? '';

    if (profile.dob != null && profile.dob!.isNotEmpty) {
      try {
        _dob = DateTime.parse(profile.dob!);
      } catch (_) {
        _dob = DateTime.now();
      }
    }

    if (profile.nationality != null &&
        _nationalities.contains(profile.nationality)) {
      _nationality = profile.nationality!;
    }

    if (profile.religion != null && _religions.contains(profile.religion)) {
      _religion = profile.religion!;
    }

    _isInitialized = true;
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      _isUpdating = true;
      final request = UpdateProfileRequest(
        firstName: _firstNameController.text.isNotEmpty
            ? _firstNameController.text
            : null,
        lastName: _lastNameController.text.isNotEmpty
            ? _lastNameController.text
            : null,
        pob: _pobController.text.isNotEmpty ? _pobController.text : null,
        dob: _dob.toIso8601String().split('T').first,
        nationality: _nationality,
        religion: _religion,
      );

      context.read<AccountBloc>().add(UpdateProfile(request: request));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AccountBloc, AccountState>(
      listener: (context, state) {
        if (_isUpdating && state.status == AccountStatus.success) {
          _isUpdating = false;
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.profileUpdated),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context);
          return;
        }

        if (state.status == AccountStatus.success && state.account != null) {
          _initializeFromAccount(state.account!);
          if (mounted) {
            setState(() {});
          }
        } else if (state.status == AccountStatus.failure) {
          _isUpdating = false;
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
              title: Text(l10n.editProfile),
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
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary,
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.secondary,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildReadOnlyField(
                      l10n.username,
                      state.account?.username ?? '-',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _firstNameController,
                      label: l10n.firstName,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.required;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _lastNameController,
                      label: l10n.lastName,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.required;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _pobController,
                      label: l10n.placeOfBirth,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.required;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(
                      label: l10n.dateOfBirth,
                      value: _formatDate(_dob),
                      onTap: isLoading ? null : () => _selectDate(context),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: l10n.nationality,
                      value: _nationality,
                      items: _nationalities,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() => _nationality = value!);
                            },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: l10n.religion,
                      value: _religion,
                      items: _religions,
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() => _religion = value!);
                            },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading ? null : _saveProfile,
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

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          child: Text(value),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
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
          enabled: enabled,
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
    VoidCallback? onTap,
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    ValueChanged<String?>? onChanged,
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
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
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

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
