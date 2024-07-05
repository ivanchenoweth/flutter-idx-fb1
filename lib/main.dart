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
  late final String _message;

 @override
 void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _message = 'test';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_message),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
          ),
        builder: (context, snapshot) {
          return Column(
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
                onPressed: () async{
                  debugPrint(_message);
                  try {
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _email.text,
                      password: _password.text,
                    );
                    _message = credential.toString();
                    debugPrint(_message);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      debugPrint('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      debugPrint('The account already exists for that email.');
                    }
                  } catch (e) {
                    
                    debugPrint(e.toString());
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ); 
        } // builder: // FutureBuilder
      ),
    );
  }
}