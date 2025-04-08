import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openapi/openapi.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.deepPurple.shade800,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.all(8), child: const Text("Horoscope Guru", style: TextStyle(color: Colors.orange, fontSize: 36, fontWeight: FontWeight.bold),),),
            const Padding(
              padding: EdgeInsets.symmetric(vertical:  8, horizontal: 16),
              child: Text("Your Personal Horoscope AI Assistant. Ask me anything to reveal the secrets of the stars.",
                style: TextStyle(color: Colors.white, fontSize: 18,  ), textAlign: TextAlign.center,)

              ,),
            Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 24), child: Image.asset(
              'assets/images/logo.png',
              width: double.infinity,  // optional
              fit: BoxFit.cover, // optional (cover, contain, fill, etc.)
            ),),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: FaIcon(FontAwesomeIcons.google, color: Colors.orange, size: 36,),
              label: const Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.white, fontSize: 18.9),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                final apiClient = Openapi(
                    basePathOverride: "http://10.0.2.2:8080");
                print(apiClient.dio.options.baseUrl );

                final response = await apiClient.getDefaultApi().initiateGoogleAuth(); // or whatever your API class is
                print(response);

                // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}