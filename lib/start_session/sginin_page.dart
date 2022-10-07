import 'package:alona_note/start_session/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback showRigisterPage;
  const LoginScreen({super.key, required this.showRigisterPage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _EmailController = TextEditingController();
  final _PasswordController = TextEditingController();
  bool _obscureText = true;
  bool btnVisible = true;
  bool progressVisible = false;

  //SnackBar
  SnackBar utils(String snackBarText) {
    return SnackBar(
      content: Text(snackBarText),
      duration: const Duration(seconds: 2),
    );
  }

  void logedInDone() {
    ScaffoldMessenger.of(context)
        .showSnackBar(utils('You are successfully logged in!'));
  }

  void logedInError() {
    ScaffoldMessenger.of(context)
        .showSnackBar(utils('Error please check your email and password!'));
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _EmailController.text.trim(),
            password: _PasswordController.text,
          )
          .then((value) => logedInDone())
          .timeout(const Duration(seconds: 6));
    } on FirebaseAuthException catch (e) {
      setState(() {
        btnVisible = true;
        progressVisible = false;
      });
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context)
            .showSnackBar(utils('Error no user with that email!'));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(utils('Error Wrong password!'));
      } else {
        logedInError();
      }
    }

    setState(() {
      btnVisible = true;
      progressVisible = false;
    });
  }

  @override
  void dispose() {
    _EmailController.dispose();
    _PasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(
                Icons.account_circle,
                size: 100,
              ),

              Text(
                'Hello Again!',
                style: GoogleFonts.bebasNeue(fontSize: 52),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                'Welcome back, you\'ve been missed!',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              // Email TextBox
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: TextField(
                      controller: _EmailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 13,
              ),

              //Password TextBox
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: TextField(
                      controller: _PasswordController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(() {
                              _obscureText = !_obscureText;
                            }),
                          )),
                      obscureText: _obscureText,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      _EmailController.text = '';
                      _PasswordController.text = '';
                      _EmailController.text = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RessetPass()));
                    },
                    child: const Text(
                      'Forgot your password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Visibility(
                  visible: progressVisible,
                  child: const CircularProgressIndicator()),
              //SingIn Button
              Visibility(
                visible: btnVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        btnVisible = false;
                        progressVisible = true;
                      });

                      signIn().then(
                        (value) {
                          setState(() {
                            btnVisible = true;
                            progressVisible = false;
                          });
                        },
                      ).onError(
                        (error, stackTrace) {
                          setState(() {
                            btnVisible = true;
                            progressVisible = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(utils(
                              'Error please check your internet connection!'));
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                          child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Not a member? '),
                  GestureDetector(
                    onTap: widget.showRigisterPage,
                    child: const Text(
                      'Register now.',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 25,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
