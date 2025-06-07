import 'package:flutter/material.dart';
import 'package:horoscopeguruapp/screens/chat_screen.dart';
import 'package:horoscopeguruapp/screens/home_screen.dart';
import 'package:horoscopeguruapp/screens/login_screen.dart';
import 'package:horoscopeguruapp/screens/user_profile_screen.dart';
import 'package:horoscopeguruapp/screens/all_chats_screen.dart';
import 'package:horoscopeguruapp/theme/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String languageCode = prefs.getString('language_code') ?? 'en';
    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horoscope Guru',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('tr'), // Turkish
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          accentColor: AppColors.accent,
        ).copyWith(
          secondary: AppColors.accent,
          background: AppColors.primaryDark,
        ),
        scaffoldBackgroundColor: AppColors.primaryDark,
        textTheme: ThemeData.light().textTheme.copyWith(
              headlineSmall: TextStyle(color: AppColors.textColor),
              titleMedium: TextStyle(color: AppColors.textColor),
              bodyLarge: TextStyle(color: AppColors.textColor),
              bodyMedium: TextStyle(color: AppColors.secondaryTextColor),
            ),
        iconTheme: IconThemeData(color: AppColors.textColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        '/userProfile': (context) => const UserProfileScreen(),
        '/allChats': (context) => const AllChatsScreen(),
      },
      navigatorObservers: [routeObserver],
    );
  }
}

// Function to change the locale
void changeLocale(BuildContext context, String languageCode) async {
  final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('language_code', languageCode);

  if (state != null) {
    state.setState(() {
      state._locale = Locale(languageCode);
    });
  }
}
