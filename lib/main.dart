import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/models/cart_model.dart';
import 'package:myapp/data/providers/auth_provider.dart';
import 'package:myapp/data/providers/cart_provider.dart';
import 'package:myapp/presentation/screens/login_screen.dart';
import 'package:myapp/presentation/screens/main_navigation.dart';
import 'package:myapp/presentation/screens/registration_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Boutique App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.grey[100],
          textTheme: GoogleFonts.montserratTextTheme(ThemeData.light().textTheme),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/register': (context) => const RegistrationScreen(),
          '/home': (context) => const MainNavigation(),
        },
      ),
    );
  }
}
