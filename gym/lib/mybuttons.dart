import 'package:flutter/material.dart';

class Mybuttons extends StatelessWidget {
  final Function()? ontap;
  final String text;
  const Mybuttons({super.key,
  required this.text,
  required this.ontap});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8)
          
        ),
        
        padding: const EdgeInsets.all(15),
        margin:const EdgeInsets.symmetric(horizontal: 25),
        child:  Center(child: Text(text,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
      ),
    );
  }
}