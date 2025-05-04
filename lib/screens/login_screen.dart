import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:horoscopeguruapp/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:horoscopeguruapp/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:horoscopeguruapp/main.dart' as mainApp; // Import for the changeLocale function

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        "759644461132-brob7a6si7mjdvhqvud7irvo5miovkc1.apps.googleusercontent.com",
    scopes: [
      'email',
    ],
  );

  String _selectedLanguage = 'en'; // Default language

  @override
  void initState() {
    super.initState();
    _checkExistingToken();

    setState(() {
      _selectedLanguage = window.locale.languageCode == 'tr' ? 'tr' : 'en';
    });

    mainApp.changeLocale(
        context, _selectedLanguage);
  }

  Future<void> _checkExistingToken() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken != null && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _handleSignIn() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      print('Google Sign-In was aborted by user');
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      print('ID token is null');
      return;
    }

    // make a sign in request using open api by sending id token
    final api = Api();

    var resp = await api.signInWithGoogle(idToken, _selectedLanguage, context);

    // Save the token to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', resp.token);

    // Navigate to home screen
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // Example function to send the access token to your backend
  Future<void> _sendAccessTokenToBackend(String accessToken) async {
    // Implement your logic to send the access token to your Node.js backend
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primary;
    final backgroundColor = AppColors.primaryDark;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                localizations.appTitle,
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                localizations.appDescription,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 24),
              child: Image.asset(
                'assets/images/logo.png',
                width: double.infinity, // optional
                fit: BoxFit.cover, // optional (cover, contain, fill, etc.)
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: FaIcon(
                FontAwesomeIcons.google,
                color: Colors.orange,
                size: 36,
              ),
              label: Text(
                localizations.signInWithGoogle,
                style: TextStyle(color: Colors.white, fontSize: 18.9),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _handleSignIn,
            ),
          ],
        ),
      ),
    );
  }
}
