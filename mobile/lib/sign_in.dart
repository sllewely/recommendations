import 'dart:ffi';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mobile/auth.dart';
import 'package:mobile/auth_helper.dart';
import 'package:provider/provider.dart';

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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
              child: SignInForm(onLoginComplete: onLoginComplete),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Don't have an account?",
                  style: TextStyle(fontSize: 20),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'signup');
                    },
                    child: const Text('Sign Up',
                      style: TextStyle(fontSize: 20),
                    ),
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
  final VoidCallback onLoginComplete;
  const SignInForm({super.key, required this.onLoginComplete});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  late TextEditingController _userPasswordController;
  late TextEditingController _userEmailController;
  late String _errors;
  late bool _hasErrors;

  @override
  void initState() {
    super.initState();
    _userPasswordController = TextEditingController();
    _userEmailController = TextEditingController();
    _errors = "";
    _hasErrors = false;
  }

  @override
  void dispose() {
    _userPasswordController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthHelper authHelper = context.watch<AuthHelper>();
    _hasErrors = authHelper.currentUser.hasErrors();
    _errors = _hasErrors ? authHelper.currentUser.errors! : "";
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: <Widget>[
            Visibility(visible: _hasErrors, child: Text(_errors)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _userEmailController,
              decoration: const InputDecoration(
                labelText: 'Email address',
                hintText: 'Enter your email address',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || !EmailValidator.validate(value)) {
                  return 'Please enter an email address';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: _userPasswordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() => _passwordVisible = !_passwordVisible);
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.trim() == '') {
                  return 'Please enter your password';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(5)),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing')),
                    );
                    Provider.of<AuthHelper>(context, listen: false).signUserIn(
                        _userEmailController.text,
                        _userPasswordController.text,
                        widget.onLoginComplete
                    );
                  }
                },
                child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}


class CollectCredentialsPage extends StatelessWidget {
  final VoidCallback onLoginComplete;

  const CollectCredentialsPage({super.key, required this.onLoginComplete});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Sign Up'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
            child: SignUpForm(onLoginComplete: onLoginComplete),
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Have an account?",
                    style: TextStyle(fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'signin');
                    },
                    child: const Text('Sign In',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final VoidCallback onLoginComplete;
  const SignUpForm({super.key, required this.onLoginComplete});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool notifyErrors = false;
  late TextEditingController _userPasswordController;
  late TextEditingController _userEmailController;
  late TextEditingController _userFirstNameController;
  late TextEditingController _userLastNameController;

  @override
  void initState() {
    super.initState();
    _userPasswordController = TextEditingController();
    _userEmailController = TextEditingController();
    _userFirstNameController = TextEditingController();
    _userLastNameController = TextEditingController();
  }

  @override
  void dispose() {
    _userPasswordController.dispose();
    _userEmailController.dispose();
    _userFirstNameController.dispose();
    _userLastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthHelper authHelper = context.watch<AuthHelper>();
    if (authHelper.currentUser.hasErrors() || authHelper.currentToken.hasErrors()) {
      notifyErrors = true;
    }

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _userFirstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                hintText: 'Enter your first name',
                border: const OutlineInputBorder(),
                errorText: notifyErrors ? "Error signing up" : null,
              ),
              validator: (value) {
                if (value == null || value.trim() == '') {
                  return 'Please enter a first name';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _userLastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                hintText: 'Enter your last nae',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim() == '') {
                  return 'Please enter a last name';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _userEmailController,
              decoration: const InputDecoration(
                labelText: 'Email address',
                hintText: 'Enter your email address',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || !EmailValidator.validate(value)) {
                  return 'Please enter an email address';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10)),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: _userPasswordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter a password of more than 8 characters',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() => _passwordVisible = !_passwordVisible);
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.length < 9) {
                  return 'Please enter a password of more than 8 characters';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(5)),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing')),
                  );
                  context.read<AuthHelper>().signUserUp(
                    AnonymousUser(
                      email:_userEmailController.text,
                      password: _userPasswordController.text,
                      firstName: _userFirstNameController.text,
                      lastName: _userLastNameController.text,
                    ),
                    widget.onLoginComplete,
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
