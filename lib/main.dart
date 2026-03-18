import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/app_config.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/api_client.dart';
import 'data/repositories/auth_repository.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/bloc/auth/login_bloc.dart';
import 'presentation/bloc/auth/register_bloc.dart';
import 'presentation/bloc/account/account_bloc.dart';
import 'presentation/bloc/product/product_bloc.dart';
import 'presentation/pages/app/splash_screen.dart';
import 'presentation/pages/app/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();

  final apiClient = ApiClient();
  final authRepository = AuthRepository(apiClient: apiClient);

  debugPrint('Before initAuthToken');
  await authRepository.initAuthToken();
  debugPrint('After initAuthToken');

  runApp(MyApp(authRepository: authRepository));
}

final GlobalKey<MainScreenState> mainScreenKey = GlobalKey<MainScreenState>();

class MyApp extends StatefulWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  static void changeLanguage(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?._changeLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(AppConstants.languageKey) ?? 'en';
    setState(() {
      _locale = languageCode == 'id'
          ? const Locale('id', 'ID')
          : const Locale('en', 'US');
    });
  }

  void _changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: widget.authRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => LoginBloc(authRepository: widget.authRepository),
          ),
          BlocProvider(
            create: (_) => RegisterBloc(authRepository: widget.authRepository),
          ),
          BlocProvider(
            create: (_) => AccountBloc(authRepository: widget.authRepository),
          ),
          BlocProvider(
            create: (_) => ProductBloc(authRepository: widget.authRepository),
          ),
        ],
        child: MaterialApp(
          title: 'Insurance Customer Portal',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
          locale: _locale,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
