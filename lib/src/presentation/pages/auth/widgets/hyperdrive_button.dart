import 'package:flutter/material.dart';

class HyperdriveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  const HyperdriveButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6B4FFF), Color(0xFF5B3FEF)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6B4FFF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.bolt, size: 20),
        ],
      ),
    );
  }
}
