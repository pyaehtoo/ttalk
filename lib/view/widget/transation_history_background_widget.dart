import 'package:flutter/material.dart';

class TransactionHistroyBackground extends StatelessWidget {
  final Widget child;
  const TransactionHistroyBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 30,
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0)
      ]),
      child: child,
    );
  }
}

