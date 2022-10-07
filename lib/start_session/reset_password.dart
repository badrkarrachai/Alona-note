import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RessetPass extends StatefulWidget {
  const RessetPass({super.key});

  @override
  State<RessetPass> createState() => _RessetPassState();
}

class _RessetPassState extends State<RessetPass> {
  String snackbarText = 'Error!';
  bool progressVisible = false;
  bool btnVisible = true;
  final _EmailController = TextEditingController();
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
                'Forgot Your Password?',
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(fontSize: 43),
              ),

              const SizedBox(
                height: 10,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Enter your registered email below to receive password reset instruction',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                  ),
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
                height: 20,
              ),
              Visibility(
                  visible: progressVisible,
                  child: const CircularProgressIndicator()),

              //Send Button
              Visibility(
                visible: btnVisible,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: (() {
                      setState(() {
                        btnVisible = false;
                        progressVisible = true;
                      });
                      resPass().then(
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
                        },
                      );
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                          child: Text(
                        'Send',
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
                  const Text('Remember password? '),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Login.',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  SnackBar utils(String snackBarText) {
    return SnackBar(
      content: Text(snackBarText),
      duration: const Duration(seconds: 2),
    );
  }

  void sendDone() {
    ScaffoldMessenger.of(context).showSnackBar(utils('Email Sent!'));
    Navigator.pop(context, _EmailController.text.trim());
  }

  Future resPass() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _EmailController.text.trim())
          .then((value) => sendDone())
          .onError((error, stackTrace) => ScaffoldMessenger.of(context)
              .showSnackBar(utils('Error please check your email!')))
          .timeout(const Duration(seconds: 6));
    } on FirebaseAuthException catch (e) {
      setState(() {
        btnVisible = true;
        progressVisible = false;
      });
    }
    setState(() {
      btnVisible = true;
      progressVisible = false;
    });
  }
}
