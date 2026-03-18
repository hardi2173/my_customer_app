import '../config/app_config.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Insurance Customer Portal';
  static const String appVersion = '1.0.0';

  static const int splashDuration = 2000;
  static const int animationDuration = 300;

  static const String dateFormat = 'dd MMMM yyyy';
  static const String dateTimeFormat = 'dd MMMM yyyy, HH:mm';
  static const String timeFormat = 'HH:mm';

  static const String currencySymbol = 'Rp';
  static const String currencyFormat = '#,###';

  static const String defaultLanguage = 'en';
  static const String secondaryLanguage = 'id';

  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
}

class ApiEndpoints {
  ApiEndpoints._();

  static String baseUrl = AppConfig.apiBaseUrl;

  static const String login = '/users/login';
  static const String register = '/users/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String accountDetail = '/account/detail';
  static const String accountProfile = '/account/profile';
  static const String accountAddresses = '/account/addresses';
  static const String accountContacts = '/account/contacts';

  static String accountAddress(String id) => '/account/addresses/$id';
  static String accountContact(String id) => '/account/contacts/$id';

  static const String policies = '/policies';
  static const String policyDetails = '/policies/{id}';

  static const String products = '/products';
  static String productDetail(String id) => '/products/$id';

  static const String claims = '/claims';
  static const String claimDetails = '/claims/{id}';

  static const String illustrations = '/illustrations';
  static const String createIllustration = '/illustrations/create';

  static const String proposals = '/proposals';
  static const String submitProposal = '/proposals/submit';

  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String uploadDocument = '/profile/documents';
}
