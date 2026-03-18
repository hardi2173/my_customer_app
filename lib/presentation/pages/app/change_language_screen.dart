import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../main.dart';

class ChangeLanguageScreen extends StatefulWidget {
  final Function(Locale)? onLocaleChanged;

  const ChangeLanguageScreen({super.key, this.onLocaleChanged});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  bool _isIndonesian = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(AppConstants.languageKey) ?? 'en';
    setState(() {
      _isIndonesian = languageCode == 'id';
    });
  }

  Future<void> _toggleLanguage(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final newLocale = value
        ? const Locale('id', 'ID')
        : const Locale('en', 'US');

    await prefs.setString(AppConstants.languageKey, value ? 'id' : 'en');

    if (!mounted) return;

    setState(() {
      _isIndonesian = value;
    });

    MyApp.changeLanguage(context, newLocale);
    widget.onLocaleChanged?.call(newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.changeLanguage),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () => _toggleLanguage(!_isIndonesian),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isIndonesian ? AppColors.primary : Colors.grey.shade300,
                width: _isIndonesian ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _isIndonesian ? '🇮🇩' : '🇺🇸',
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isIndonesian ? l10n.indonesian : l10n.english,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: _isIndonesian
                              ? AppColors.primary
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isIndonesian ? 'Bahasa Indonesia' : 'English (US)',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: _isIndonesian,
                  onChanged: _toggleLanguage,
                  activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
