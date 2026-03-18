import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/register_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/auth/register_bloc.dart';
import '../../bloc/auth/register_event.dart';
import '../../bloc/auth/register_state.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String _selectedReligion = '';

  final List<String> _religions = [
    'Islam',
    'Christian',
    'Catholic',
    'Hindu',
    'Buddha',
    'Confucian',
    'Other',
  ];

  final List<ContactFormData> _contacts = [];
  final List<AddressFormData> _addresses = [];

  @override
  void initState() {
    super.initState();
    _contacts.add(ContactFormData());
    _addresses.add(AddressFormData());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.required;
    }
    if (value.length < 8) {
      return AppLocalizations.of(context)!.invalidPassword;
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*()_+\-=\[\]{};<>?]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  void _addContact() {
    setState(() {
      _contacts.add(ContactFormData());
    });
  }

  void _removeContact(int index) {
    if (_contacts.length > 1) {
      setState(() {
        _contacts[index].dispose();
        _contacts.removeAt(index);
      });
    }
  }

  void _addAddress() {
    setState(() {
      _addresses.add(AddressFormData());
    });
  }

  void _removeAddress(int index) {
    if (_addresses.length > 1) {
      setState(() {
        _addresses[index].dispose();
        _addresses.removeAt(index);
      });
    }
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      final contacts = <ContactRequest>[];

      for (final contact in _contacts) {
        final controller = contact.controller;
        final type = contact.selectedType;
        if (controller.text.isNotEmpty && type.isNotEmpty) {
          contacts.add(
            ContactRequest(contactType: type, contactNumber: controller.text),
          );
        }
      }

      final addresses = <AddressRequest>[];
      for (final address in _addresses) {
        addresses.add(
          AddressRequest(
            addressType: address.selectedType.isEmpty
                ? 'HOME'
                : address.selectedType,
            addressProvince: address.provinceController.text.isEmpty
                ? null
                : address.provinceController.text,
            addressCity: address.cityController.text.isEmpty
                ? null
                : address.cityController.text,
            addressDistrict: address.districtController.text.isEmpty
                ? null
                : address.districtController.text,
            addressSubDistrict: address.subDistrictController.text.isEmpty
                ? null
                : address.subDistrictController.text,
            addressLine1: address.line1Controller.text.isEmpty
                ? null
                : address.line1Controller.text,
            addressLine2: address.line2Controller.text.isEmpty
                ? null
                : address.line2Controller.text,
          ),
        );
      }

      final request = RegisterRequestModel(
        username: _usernameController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text.isEmpty
            ? null
            : _firstNameController.text,
        lastName: _lastNameController.text.isEmpty
            ? null
            : _lastNameController.text,
        nationality: 'Indonesia',
        religion: _selectedReligion.isEmpty ? null : _selectedReligion,
        contacts: contacts,
        addresses: addresses,
      );

      context.read<RegisterBloc>().add(RegisterSubmitted(request: request));
    }
  }

  void _handleLogin() {
    for (final contact in _contacts) {
      contact.dispose();
    }
    for (final address in _addresses) {
      address.dispose();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: (previous, current) {
        return previous.status != current.status &&
            (current.status == RegisterStatus.failure &&
                    current.errorMessage != null ||
                current.status == RegisterStatus.success &&
                    current.successMessage != null);
      },
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? l10n.success),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        } else if (state.status == RegisterStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.warning,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.register),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  _buildSectionTitle(l10n.username),
                  const SizedBox(height: 8),
                  _buildUsernameField(l10n),
                  const SizedBox(height: 16),
                  _buildSectionTitle(l10n.password),
                  const SizedBox(height: 8),
                  _buildPasswordField(l10n),
                  const SizedBox(height: 16),
                  _buildSectionTitle(l10n.confirmPassword),
                  const SizedBox(height: 8),
                  _buildConfirmPasswordField(l10n),
                  const SizedBox(height: 24),
                  _buildSectionTitle(l10n.personalInformation),
                  const SizedBox(height: 8),
                  _buildNameFields(l10n),
                  const SizedBox(height: 16),
                  _buildSectionTitle(l10n.religion),
                  const SizedBox(height: 8),
                  _buildReligionDropdown(l10n),
                  const SizedBox(height: 24),
                  _buildSectionTitle(l10n.contacts),
                  const SizedBox(height: 8),
                  ..._buildContactFields(l10n),
                  _buildAddContactButton(l10n),
                  const SizedBox(height: 24),
                  _buildSectionTitle(l10n.address),
                  const SizedBox(height: 8),
                  ..._buildAddressFields(l10n),
                  _buildAddAddressButton(l10n),
                  const SizedBox(height: 24),
                  _buildRegisterButton(l10n),
                  const SizedBox(height: 16),
                  _buildLoginLink(l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildUsernameField(AppLocalizations l10n) {
    return TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: l10n.username,
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.required;
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(AppLocalizations l10n) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: l10n.password,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        helperText: 'Min 8 chars, uppercase, lowercase, number, special char',
        helperMaxLines: 2,
      ),
      validator: _validatePassword,
    );
  }

  Widget _buildConfirmPasswordField(AppLocalizations l10n) {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: l10n.confirmPassword,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.required;
        }
        if (value != _passwordController.text) {
          return l10n.passwordMismatch;
        }
        return null;
      },
    );
  }

  Widget _buildNameFields(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _firstNameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: l10n.firstName,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: _lastNameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: l10n.lastName,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReligionDropdown(AppLocalizations l10n) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedReligion.isEmpty ? null : _selectedReligion,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      hint: const Text('Select'),
      items: _religions.map((religion) {
        return DropdownMenuItem<String>(value: religion, child: Text(religion));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedReligion = value ?? '';
        });
      },
    );
  }

  List<Widget> _buildContactFields(AppLocalizations l10n) {
    final widgets = <Widget>[];
    for (var i = 0; i < _contacts.length; i++) {
      widgets.add(_buildContactField(l10n, i));
      widgets.add(const SizedBox(height: 12));
    }
    return widgets;
  }

  Widget _buildContactField(AppLocalizations l10n, int index) {
    final contact = _contacts[index];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.contacts} ${index + 1}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (_contacts.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeContact(index),
                    iconSize: 20,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: contact.selectedType.isEmpty
                  ? null
                  : contact.selectedType,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'EMAIL', child: Text('Email')),
                DropdownMenuItem(value: 'PHONE', child: Text('Phone')),
                DropdownMenuItem(value: 'HOME', child: Text('Home')),
                DropdownMenuItem(value: 'OFFICE', child: Text('Office')),
              ],
              onChanged: (value) {
                setState(() {
                  contact.selectedType = value ?? '';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.required;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: contact.controller,
              keyboardType: contact.selectedType == 'EMAIL'
                  ? TextInputType.emailAddress
                  : TextInputType.phone,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: contact.selectedType == 'EMAIL'
                    ? l10n.email
                    : l10n.phoneNumber,
                prefixIcon: const Icon(Icons.contact_phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.required;
                }
                if (contact.selectedType == 'EMAIL') {
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
          ],
        ),
      ),
    );
  }

  Widget _buildAddContactButton(AppLocalizations l10n) {
    return OutlinedButton.icon(
      onPressed: _addContact,
      icon: const Icon(Icons.add),
      label: Text(l10n.addContact),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  List<Widget> _buildAddressFields(AppLocalizations l10n) {
    final widgets = <Widget>[];
    for (var i = 0; i < _addresses.length; i++) {
      widgets.add(_buildAddressField(l10n, i));
      widgets.add(const SizedBox(height: 12));
    }
    return widgets;
  }

  Widget _buildAddressField(AppLocalizations l10n, int index) {
    final address = _addresses[index];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.address} ${index + 1}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                if (_addresses.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => _removeAddress(index),
                    iconSize: 20,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: address.selectedType.isEmpty
                  ? null
                  : address.selectedType,
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'HOME', child: Text('Home')),
                DropdownMenuItem(value: 'OFFICE', child: Text('Office')),
                DropdownMenuItem(
                  value: 'CORRESPONDENCE',
                  child: Text('Correspondence'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  address.selectedType = value ?? '';
                });
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: address.line1Controller,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.street,
                prefixIcon: const Icon(Icons.home_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: address.provinceController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.province,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: address.cityController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.city,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: address.districtController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'District',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: address.subDistrictController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Sub District',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: address.line2Controller,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Address Line 2 (Optional)',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressButton(AppLocalizations l10n) {
    return OutlinedButton.icon(
      onPressed: _addAddress,
      icon: const Icon(Icons.add),
      label: Text(l10n.addAddress),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildRegisterButton(AppLocalizations l10n) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        final isLoading = state.status == RegisterStatus.loading;
        return ElevatedButton(
          onPressed: isLoading ? null : _handleRegister,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  l10n.register,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildLoginLink(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAccount,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(onPressed: _handleLogin, child: Text(l10n.login)),
      ],
    );
  }
}

class ContactFormData {
  final TextEditingController controller = TextEditingController();
  String selectedType = '';

  void dispose() {
    controller.dispose();
  }
}

class AddressFormData {
  String selectedType = '';
  final TextEditingController line1Controller = TextEditingController();
  final TextEditingController line2Controller = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController subDistrictController = TextEditingController();

  void dispose() {
    line1Controller.dispose();
    line2Controller.dispose();
    provinceController.dispose();
    cityController.dispose();
    districtController.dispose();
    subDistrictController.dispose();
  }
}
