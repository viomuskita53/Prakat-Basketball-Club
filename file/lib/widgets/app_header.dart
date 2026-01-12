import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget{
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/prakat.png',
          height: 32,
          width: 32,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 8),
        const Text(
          'PRAKAT BASKETBALL CLUB',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}