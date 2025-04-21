import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horoscopeguruapp/theme/colors.dart';

class LanguageSelector extends StatelessWidget {
  final Function(String) onLanguageChanged;

  const LanguageSelector({Key? key, required this.onLanguageChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return PopupMenuButton<String>(
      icon: Icon(Icons.language, color: AppColors.textColor),
      tooltip: localizations.language,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'en',
          child: Row(
            children: [
              Text('English'),
              SizedBox(width: 8),
              Locale('en') == Localizations.localeOf(context)
                  ? Icon(Icons.check, color: AppColors.accent)
                  : SizedBox.shrink(),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'tr',
          child: Row(
            children: [
              Text('Türkçe'),
              SizedBox(width: 8),
              Locale('tr') == Localizations.localeOf(context)
                  ? Icon(Icons.check, color: AppColors.accent)
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ],
      onSelected: onLanguageChanged,
    );
  }
}
