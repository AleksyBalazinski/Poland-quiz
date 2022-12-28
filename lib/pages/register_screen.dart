import 'package:flutter/material.dart';
import 'package:poland_quiz/routes.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();
  bool isSubmitting = true; // TODO

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final logo = Image.asset(
      'assets/logo.png',
      height: mq.size.height / 4,
    );

    final usernameField = TextFormField(
      enabled: isSubmitting,
      controller: _usernameController,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        hintText: 'John Doe',
        labelText: 'username',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );

    final emailField = TextFormField(
      enabled: isSubmitting,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        hintText: 'something@example.com',
        labelText: 'email',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );

    final passwordField = TextFormField(
      enabled: isSubmitting,
      controller: _passwordController,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        hintText: 'password',
        labelText: 'password',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );

    final repasswordField = TextFormField(
      enabled: isSubmitting,
      controller: _repasswordController,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        hintText: 'password',
        labelText: 'Re-enter password',
        hintStyle: TextStyle(
          color: Colors.grey,
        ),
      ),
    );

    final fields = Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          usernameField,
          emailField,
          passwordField,
          repasswordField,
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
        child: const Text(
          'Register',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          try {
            var user =
                (await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            ))
                    .user;

            if (user != null) {
              // TODO add user data to db
              if (!mounted) return;
              Navigator.of(context).pushNamed(AppRoutes.homePage);
            }
          } catch (e) {
            _usernameController.text = "";
            _passwordController.text = "";
            _repasswordController.text = "";
            _emailController.text = "";
            print(e);
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
            const Text('Already have an account?'),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.authLogin);
              },
              child: const Text('Login'),
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