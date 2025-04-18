import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:horoscopeguruapp/screens/chat_screen.dart';
import 'package:horoscopeguruapp/screens/home_screen.dart';
import 'package:horoscopeguruapp/screens/login_screen.dart';
import 'package:horoscopeguruapp/theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horoscope Guru',
      debugShowCheckedModeBanner: false,
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
        '/home': (context) => const HomeScreen(), // Create this page
        '/chat': (context) => const ChatScreen(), // Create this page
      },
    );
  }
}
