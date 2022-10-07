import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';

class SignUpPage extends StatefulWidget {
  final VoidCallback showSignInPage;
  const SignUpPage({super.key, required this.showSignInPage});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _EmailController = TextEditingController();
  final _PasswordController = TextEditingController();
  final _ConPasswordController = TextEditingController();

  bool emailValid = false;
  bool passwordValid = false;
  bool _obscureText = true;
  bool emailErrorVisible = false;
  bool passErrorVisible = false;
  bool passSameValid = false;
  bool passSameVisible = false;
  bool btnVisible = true;
  bool progressVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(
              Icons.account_circle,
              size: 100,
            ),

            Text(
              'HELLO THERE!',
              style: GoogleFonts.bebasNeue(fontSize: 52),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              'Register below with your details',
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
                    onSubmitted: checkEmail,
                    controller: _EmailController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: emailErrorVisible,
              child: const SizedBox(
                height: 7,
              ),
            ),

            Visibility(
              visible: emailErrorVisible,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 18),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'This is not a valid email',
                      style: TextStyle(color: Colors.red),
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
                    onSubmitted: checkPass,
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

            Visibility(
              visible: passErrorVisible,
              child: const SizedBox(
                height: 7,
              ),
            ),

            Visibility(
              visible: passErrorVisible,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 18),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'This is not a valid password',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 13,
            ),

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
                    onSubmitted: passSamecheck,
                    controller: _ConPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Confirm Password',
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: passSameVisible,
              child: const SizedBox(
                height: 7,
              ),
            ),

            Visibility(
              visible: passSameVisible,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 18),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'This password does not match',
                      style: TextStyle(color: Colors.red),
                    ),
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

            //SingUp Button
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
                    signUp().then(
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
                      'Sign Up',
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
                const Text('I am a member! '),
                GestureDetector(
                  onTap: widget.showSignInPage,
                  child: const Text(
                    'Login now.',
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            )
          ]),
        ),
      )),
    );
  }

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

  Future signUp() async {
    checkEmail(_EmailController.text);
    checkPass(_PasswordController.text);
    passSamecheck(_ConPasswordController.text);
    if (emailValid && passwordValid && passSameValid) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _EmailController.text.trim(),
                password: _PasswordController.text)
            .then((value) => logedInDone())
            .timeout(const Duration(seconds: 6));
      } on FirebaseAuthException catch (e) {
        setState(() {
          btnVisible = true;
          progressVisible = false;
        });
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context)
              .showSnackBar(utils('Error this email is already used!'));
        } else {
          logedInError();
        }
      }
    }
    setState(() {
      btnVisible = true;
      progressVisible = false;
    });
  }

  void checkPass(String value) {
    if (value.length < 6) {
      setState(() {
        passErrorVisible = true;
        passwordValid = false;
      });
    } else {
      setState(() {
        passErrorVisible = false;
        passwordValid = true;
      });
    }
  }

  void checkEmail(String value) {
    EmailValidator.validate(value) ? emailValid = true : emailValid = false;
    if (emailValid) {
      setState(() {
        emailErrorVisible = false;
        emailValid = true;
      });
    } else {
      setState(() {
        emailErrorVisible = true;
        emailValid = false;
      });
    }
  }

  void passSamecheck(String value) {
    if (value == _PasswordController.text) {
      setState(() {
        passSameVisible = false;
        passSameValid = true;
      });
    } else {
      setState(() {
        passSameVisible = true;
        passSameValid = false;
      });
    }
  }
}
