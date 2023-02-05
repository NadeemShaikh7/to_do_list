import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/provider/sign_in_provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(26.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const FlutterLogo(
                size: 120,
              ),
              const Spacer(),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hey There!\nWelcome Back',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login to your account to continue',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(double.infinity, 50.0)),
                  onPressed: () {
                    print('Login pressed');
                    Provider.of<GoogleSignInProvider>(context,
                            listen: false)
                        .googleLogin();
                  },
                  label: Text('Sign in with Google'))
            ],
          )),
    );
  }
}
