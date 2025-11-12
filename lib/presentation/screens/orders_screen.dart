import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'You have no orders yet.',
          style: GoogleFonts.roboto(color: Colors.white70, fontSize: 18),
        ),
      ),
    );
  }
}
