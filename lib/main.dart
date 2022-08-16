import 'package:firebase1/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MainPoinPage extends StatelessWidget {
  const MainPoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return MyHomePage(title: 'LoginPage');
            }
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                    hintText: 'Enter email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                    hintText: 'Enter email'),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  var message = await signInAccount(emailController.text.trim(),
                      passwordController.text.trim());
                  print(message);
                  if (message == 'success') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainPoinPage()),
                    );
                  } else {
                    print('object data not found..!!!');
                  }
                },
                child: const SizedBox(
                    height: 40,
                    width: 100,
                    child: Center(child: Text('Sign In'))))
          ],
        ),
      ),
    );
  }

  Future<String?> signInAccount(String email, String password) async {
    String message = 'message';
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      message = 'success';

      //  print('signIn');
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          message = e.code;
          break;
        case 'invalid-password':
          message = e.code;
          break;
        case 'wrong-password':
          message = e.code;
          break;
        case 'user-not-found':
          message = e.code;
          break;
      }
      print(e);
    }
    return message;
  }
}
