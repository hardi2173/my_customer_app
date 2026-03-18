import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../main.dart';
import '../../bloc/auth/login_bloc.dart';
import '../../bloc/auth/login_event.dart';
import '../../bloc/auth/login_state.dart';
import '../../bloc/account/account_bloc.dart';
import '../../bloc/account/account_event.dart';
import '../../widgets/common/social_login_button.dart';
import '../app/main_screen.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _deviceId = '';

  @override
  void initState() {
    super.initState();
    _initDeviceId();
  }

  Future<void> _initDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceId = prefs.getString('device_id') ?? const Uuid().v4();
    await prefs.setString('device_id', _deviceId);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      context.read<LoginBloc>().add(
        LoginSubmitted(
          username: username,
          password: password,
          deviceId: _deviceId,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
  }

  void _handleRegister() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterPage()));
  }

  void _handleGoogleLogin() {
    debugPrint('Google login');
  }

  void _handleFacebookLogin() {
    debugPrint('Facebook login');
  }

  void _handleAppleLogin() {
    debugPrint('Apple login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) {
            return previous.status != current.status &&
                current.status == AuthStatus.success;
          },
          listener: (context, state) async {
            debugPrint('Login success, saving token...');
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(AppConstants.tokenKey, state.accessToken!);
            await prefs.setString(
              AppConstants.refreshTokenKey,
              state.refreshToken!,
            );

            debugPrint('Token saved: ${state.accessToken}');
            final savedToken = prefs.getString(AppConstants.tokenKey);
            debugPrint('Verified saved token: $savedToken');

            if (!context.mounted) return;
            context.read<AccountBloc>().add(const LoadAccountDetail());
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => MainScreen(key: mainScreenKey)),
            );
          },
        ),
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) {
            return previous.status != current.status &&
                current.status == AuthStatus.failure &&
                current.errorMessage != null;
          },
          listener: (context, state) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.warning,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  _buildLogo(),
                  SizedBox(height: screenHeight * 0.03),
                  _buildWelcomeText(l10n),
                  SizedBox(height: screenHeight * 0.03),
                  _buildUsernameField(l10n),
                  const SizedBox(height: 16),
                  _buildPasswordField(l10n),
                  _buildForgotPassword(l10n),
                  const SizedBox(height: 16),
                  _buildLoginButton(l10n),
                  const SizedBox(height: 16),
                  _buildOrContinueWith(l10n),
                  const SizedBox(height: 12),
                  _buildSocialButtons(),
                  const SizedBox(height: 16),
                  _buildRegisterButton(l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.shield_outlined,
            size: 30,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'My Customer',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText(AppLocalizations l10n) {
    return Column(
      children: [
        Text(
          l10n.welcome,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.signIn,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
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
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleLogin(),
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
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.required;
        }
        if (value.length < 8) {
          return l10n.invalidPassword;
        }
        return null;
      },
    );
  }

  Widget _buildForgotPassword(AppLocalizations l10n) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _handleForgotPassword,
        child: Text(l10n.forgotPassword),
      ),
    );
  }

  Widget _buildLoginButton(AppLocalizations l10n) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        return ElevatedButton(
          onPressed: isLoading ? null : _handleLogin,
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
                  l10n.login,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        );
      },
    );
  }

  Widget _buildOrContinueWith(AppLocalizations l10n) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.orContinueWith,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButton.google(onPressed: _handleGoogleLogin),
        const SizedBox(width: 16),
        SocialLoginButton.facebook(onPressed: _handleFacebookLogin),
        const SizedBox(width: 16),
        SocialLoginButton.apple(onPressed: _handleAppleLogin),
      ],
    );
  }

  Widget _buildRegisterButton(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.dontHaveAccount,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(onPressed: _handleRegister, child: Text(l10n.register)),
      ],
    );
  }
}
