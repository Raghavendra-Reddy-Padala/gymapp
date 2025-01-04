import 'package:flutter/material.dart';
import 'package:gym/authservice.dart';
import 'package:gym/mybuttons.dart';
import 'package:gym/mytextfielfd.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'muscle_list_page.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  void login(BuildContext context) async {
    //auth service
    final authService = Authservice();

    //try login
    try {
      UserCredential userCredential = await authService.signInWithEmailPassword(email.text, password.text);
      if (userCredential.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MuscleListPage()),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Lottie.network(
              "https://lottie.host/65a00b51-3b68-4fc0-891e-6b4192e57ff7/3bIL1C1rMR.json",
              height: 250,
            ),
            //welcome back message
            const SizedBox(height: 30),
            Text(
              "Hey GymRat, login now!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),
            //email text field
            Mytextfielfd(
              hintText: "Enter Your Email",
              obscureText: false,
              controller: email,
            ),
            //password
            Mytextfielfd(
              hintText: "Enter Your Password",
              obscureText: true,
              controller: password,
            ),
            //login now
            const SizedBox(height: 25),
            Mybuttons(text: "Log In", ontap: () => login(context)),
            //register now
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Not a member?  "),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Register Now!",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple[600]),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
