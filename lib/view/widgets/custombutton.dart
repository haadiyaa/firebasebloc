import 'package:firebasebloc/blocs/auth_bloc/auth_bloc.dart';
import 'package:firebasebloc/model/user_model.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback function;
  final String text;
  final Color color;
  const CustomButton({
    super.key,
    required this.function,
    required this.text,
    this.color=Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
