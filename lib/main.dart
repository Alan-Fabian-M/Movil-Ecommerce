import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/models/cart_model.dart';
import 'package:myapp/presentation/screens/main_navigation.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: MaterialApp(
        title: 'Tesla Boutique',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueAccent,
          scaffoldBackgroundColor: Colors.black,
          textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
        ),
        home: const MainNavigation(),
      ),
    );
  }
}
