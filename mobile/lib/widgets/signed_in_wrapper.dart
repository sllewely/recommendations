import 'package:flutter/material.dart';
import 'package:mobile/auth_helper.dart';
import 'package:provider/provider.dart';

class SignedInWrapper extends StatelessWidget {
  final Widget wrapped;

  const SignedInWrapper({super.key, required this.wrapped});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthHelper>(
      builder: (context, authHelper, child) {
        if (authHelper.currentUser.isSignedIn()) {
          return wrapped;
        } else {
          return Column(
            children: <Widget>[
              const Text('You are not signed in!'),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/signin');
                  },
                  child: const Text('Sign In')
              ),
            ],
          );
        }
      }
    );
  }
}