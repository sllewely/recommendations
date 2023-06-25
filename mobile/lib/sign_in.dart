import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    onLoginComplete() {
      Navigator.of(context).pop();
    }
    return Navigator(
      initialRoute: 'signin',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'signin':
            builder = (BuildContext context) => SignInPage(onLoginComplete: onLoginComplete);
          case 'signup':
            builder = (BuildContext context) => CollectCredentialsPage(
                onLoginComplete: onLoginComplete
            );
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute<void>(builder: builder, settings: settings);
      },
    );
  }
}

class SignInPage extends StatelessWidget {
  final VoidCallback onLoginComplete;

  const SignInPage({super.key, required this.onLoginComplete});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Sign In'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Center(
              child: SignInForm(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: <Widget>[
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'signup');
                    },
                    child: const Text('Sign Up')
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              return 'Please enter an email address';
            },
          ),
          TextFormField(
            validator: (value) {
              return 'Please enter a secure password';
            }
          ),
          ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing')),
                  );
                }
              },
              child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}


class CollectCredentialsPage extends StatelessWidget {
  final VoidCallback onLoginComplete;

  const CollectCredentialsPage({super.key, required this.onLoginComplete});


  @override
  Widget build(BuildContext context) {
    return const Text('Spot two');
  }
}