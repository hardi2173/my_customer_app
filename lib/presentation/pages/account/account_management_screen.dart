import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/account_detail_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/account/account_bloc.dart';
import '../../bloc/account/account_event.dart';
import '../../bloc/account/account_state.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import 'add_address_screen.dart';
import 'edit_address_screen.dart';
import 'add_contact_screen.dart';
import 'edit_contact_screen.dart';
import '../auth/login_page.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  State<AccountManagementScreen> createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<AccountBloc>().add(const LoadAccountDetail());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<AccountBloc>().add(const LoadAccountDetail());
    }
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logout),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _performLogout();
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.refreshTokenKey);
    await prefs.remove(AppConstants.userKey);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state.status == AccountStatus.loading) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.accountManagement),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == AccountStatus.failure) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.accountManagement),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.errorMessage ?? 'Failed to load account'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AccountBloc>().add(
                        const LoadAccountDetail(),
                      );
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          );
        }

        final account = state.account;
        final profile = account?.profile;

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.accountManagement),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.lock),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChangePasswordScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<AccountBloc>().add(const LoadAccountDetail());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(account),
                  const SizedBox(height: 24),
                  _buildPersonalInformationSection(l10n, account),
                  const SizedBox(height: 16),
                  _buildContactsSection(l10n, profile),
                  const SizedBox(height: 16),
                  _buildAddressesSection(l10n, profile),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(AccountDetailModel? account) {
    final profile = account?.profile;
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: Text(
                  (profile?.fullName.isNotEmpty == true
                          ? profile!.fullName[0]
                          : account?.username[0] ?? 'U')
                      .toUpperCase(),
                  style: const TextStyle(fontSize: 40, color: Colors.white),
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
          const SizedBox(height: 12),
          Text(
            profile?.fullName ?? account?.username ?? 'User',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '@${account?.username ?? ''}',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformationSection(
    AppLocalizations l10n,
    AccountDetailModel? account,
  ) {
    final profile = account?.profile;
    return _buildSection(
      title: l10n.personalInformation,
      icon: Icons.person,
      children: [
        _buildDetailRow(
          l10n.username,
          account?.username ?? '-',
          isEditable: false,
        ),
        _buildDetailRow(l10n.firstName, profile?.firstName ?? '-'),
        _buildDetailRow(l10n.lastName, profile?.lastName ?? '-'),
        _buildDetailRow(l10n.placeOfBirth, profile?.pob ?? '-'),
        _buildDetailRow(l10n.dateOfBirth, profile?.dob ?? '-'),
        _buildDetailRow(l10n.nationality, profile?.nationality ?? '-'),
        _buildDetailRow(l10n.religion, profile?.religion ?? '-'),
      ],
    );
  }

  Widget _buildContactsSection(
    AppLocalizations l10n,
    AccountProfileModel? profile,
  ) {
    final contacts = profile?.contacts ?? [];

    return _buildSection(
      title: l10n.contacts,
      icon: Icons.contacts,
      trailing: IconButton(
        icon: const Icon(Icons.add_circle, color: AppColors.primary),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddContactScreen()),
          );
        },
      ),
      children: contacts.isEmpty
          ? [_buildContactRow(l10n.phoneNumber, '-', null, null)]
          : contacts.map((c) {
              String label;
              IconData icon;
              switch (c.contactType) {
                case 'EMAIL':
                  label = l10n.email;
                  icon = Icons.email;
                  break;
                case 'PHONE':
                  label = l10n.phoneNumber;
                  icon = Icons.phone_android;
                  break;
                case 'HOME':
                  label = l10n.homeNumber;
                  icon = Icons.home;
                  break;
                case 'OFFICE':
                  label = l10n.officeNumber;
                  icon = Icons.business;
                  break;
                default:
                  label = c.contactType;
                  icon = Icons.phone;
              }
              return _buildContactRow(label, c.contactNumber, icon, c);
            }).toList(),
    );
  }

  Widget _buildAddressesSection(
    AppLocalizations l10n,
    AccountProfileModel? profile,
  ) {
    final addresses = profile?.addresses ?? [];

    return _buildSection(
      title: l10n.address,
      icon: Icons.location_on,
      trailing: IconButton(
        icon: const Icon(Icons.add_circle, color: AppColors.primary),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAddressScreen()),
          );
        },
      ),
      children: addresses.isEmpty
          ? [_buildAddressCard(title: l10n.homeAddress, address: null)]
          : addresses.asMap().entries.map((entry) {
              final index = entry.key;
              final address = entry.value;
              String title;
              switch (address.addressType) {
                case 'HOME':
                  title = l10n.homeAddress;
                  break;
                case 'OFFICE':
                  title = l10n.officeAddress;
                  break;
                case 'CORRESPONDENCE':
                  title = l10n.correspondenceAddress;
                  break;
                default:
                  title = '${l10n.address} ${index + 1}';
              }
              return Column(
                children: [
                  if (index > 0) const SizedBox(height: 12),
                  _buildAddressCard(title: title, address: address),
                ],
              );
            }).toList(),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Widget? trailing,
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
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              trailing ?? const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              if (isEditable) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    String type,
    String value,
    IconData? icon,
    ContactModel? contact,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (contact != null)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                size: 18,
                color: AppColors.textSecondary,
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditContactScreen(contact: contact),
                    ),
                  );
                } else if (value == 'delete') {
                  _showDeleteContactDialog(contact.id, l10n);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 18),
                      const SizedBox(width: 8),
                      Text(l10n.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: AppColors.error),
                      const SizedBox(width: 8),
                      Text(
                        l10n.delete,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  void _showDeleteContactDialog(String contactId, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteContactConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AccountBloc>().add(DeleteContact(id: contactId));
            },
            child: Text(l10n.delete, style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard({required String title, AddressModel? address}) {
    final fullAddress = address?.fullAddress ?? '-';
    final l10n = AppLocalizations.of(context)!;

    return InkWell(
      onTap: address != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditAddressScreen(address: address),
                ),
              );
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (address != null)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditAddressScreen(address: address),
                          ),
                        );
                      } else if (value == 'delete') {
                        _showDeleteAddressDialog(address.id, l10n);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit, size: 18),
                            const SizedBox(width: 8),
                            Text(l10n.edit),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              size: 18,
                              color: AppColors.error,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.delete,
                              style: TextStyle(color: AppColors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              fullAddress,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAddressDialog(String addressId, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteAddressConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AccountBloc>().add(DeleteAddress(id: addressId));
            },
            child: Text(l10n.delete, style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
