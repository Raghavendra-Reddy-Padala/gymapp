import 'package:flutter/material.dart';
import 'package:gym/authservice.dart';
import 'package:gym/mybuttons.dart';
import 'package:gym/mytextfielfd.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'muscle_list_page.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  void register(BuildContext context) async {
    //get auth service
    final auth = Authservice();
    //signup method only if both passwords match
    if (password.text == confirmPassword.text) {
      try {
        UserCredential userCredential = await auth.signupWithEmailandPassword(email.text, password.text);
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
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Passwords do not match'),
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
              "https://lottie.host/66f0faa4-c201-499b-8ef0-16803f0b4020/LxEZ8AYAln.json",
              height: 250,
            ),
            //welcome message
            const SizedBox(height: 30),
            Text(
              "Hello, register now!",
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
            //confirm password
            Mytextfielfd(
              hintText: "Confirm Your Password",
              obscureText: true,
              controller: confirmPassword,
            ),
            //register now
            const SizedBox(height: 25),
            Mybuttons(text: "Register", ontap: () => register(context)),
            //login now
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?  "),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    "Login Now!",
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
