import 'package:flutter/material.dart';

class Mytextfielfd extends StatelessWidget {
  final String hintText;
final bool obscureText;
final FocusNode? focusNode;
final TextEditingController controller;
  const Mytextfielfd({super.key,
   this.focusNode,
  required this.controller,
  required this.obscureText,
  required this.hintText});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary)
          ),
          fillColor: Colors.grey[350],
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)
        
        ),
      
      ),
    );
  }
}