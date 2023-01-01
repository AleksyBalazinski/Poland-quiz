import 'package:flutter/material.dart';
import 'package:poland_quiz/routes.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:poland_quiz/firebase_err.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final logo = Image.asset(
      'assets/logo.png',
      height: mq.size.height / 3,
    );

    final emailField = TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        hintText: 'something@example.com',
        labelText: 'Email',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );

    final passwordField = Column(
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'password',
            labelText: AppLocalizations.of(context)!.password,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(2.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MaterialButton(
              onPressed: () {
                // TODO fogot password popup
              },
              child: const Text("Forgot password"),
            )
          ],
        ),
      ],
    );

    final fields = Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          emailField,
          passwordField,
        ],
      ),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.white,
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(
          AppLocalizations.of(context)!.login,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          try {
            var user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            ))
                .user;

            if (user != null) {
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.homePage, (route) => false);
            }
          } on FirebaseAuthException catch (e) {
            _emailController.text = '';
            _passwordController.text = '';
            showAlertDialog(context, 'Login error', getMessageFromErrorCode(e));
          }
        },
      ),
    );

    final button = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        loginButton,
        const Padding(
          padding: EdgeInsets.all(8),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.notAMember),
            MaterialButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.authRegister);
              },
              child: Text(AppLocalizations.of(context)!.signUp),
            ),
          ],
        )
      ],
    );

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              logo,
              fields,
              button,
            ],
          ),
        ),
      ),
    );
  }
}
