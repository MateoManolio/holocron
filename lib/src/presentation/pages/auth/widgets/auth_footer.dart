import 'package:flutter/material.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 16,
          left: 16,
          child: Text(
            'v.1.1.0',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Text(
            '© HOLOCRON',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
          ),
        ),
      ],
    );
  }
}
