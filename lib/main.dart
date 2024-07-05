import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/firebase_options.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'My First App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('debug: HomePage.Widget.build 5 ... ');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register V2'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
            ),
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
                );
                // if we want to register, replace signInWithEmailAndPassword
                // with createWithEmailAndPassword
                final credential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _email.text,
                  password: _password.text,
                );
                debugPrint("FirebaseAuth lookx ok....");
                debugPrint(credential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                } else if (e.code == 'invalid-credential') {
                  print('Invalid credential.');
                }
                print(e);
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
