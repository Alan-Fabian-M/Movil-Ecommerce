import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/data/providers/auth_provider.dart';
import 'package:myapp/data/providers/cart_provider.dart';
import 'package:myapp/presentation/screens/login_screen.dart';
import 'package:myapp/presentation/screens/registration_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLoggedIn && authProvider.user != null) {
            // Usuario logueado - mostrar información
            return _buildLoggedInView(context, authProvider);
          } else {
            // Usuario no logueado - mostrar botones de login/registro
            return _buildLoggedOutView(context);
          }
        },
      ),
    );
  }

  Widget _buildLoggedInView(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user!;
    
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[800],
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 24),
            
            // Nombre
            Text(
              user.fullName,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Email
            Text(
              user.email,
              style: GoogleFonts.roboto(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            
            // Tarjetas de información
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: user.email,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    title: 'Nombre',
                    subtitle: user.firstName,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    icon: Icons.badge_outlined,
                    title: 'Apellido',
                    subtitle: user.lastName,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Botón de cerrar sesión
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  // Limpiar carrito al cerrar sesión
                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                  cartProvider.clearCart();
                  
                  await authProvider.logout();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Sesión cerrada',
                          style: GoogleFonts.roboto(),
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.logout),
                label: Text(
                  'Cerrar Sesión',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedOutView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono
            Icon(
              Icons.person_outline,
              size: 120,
              color: Colors.grey[700],
            ),
            const SizedBox(height: 32),
            
            // Título
            Text(
              'Bienvenido',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // Subtítulo
            Text(
              'Inicia sesión o crea una cuenta\npara comenzar',
              style: GoogleFonts.roboto(
                color: Colors.white70,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            // Botones
            Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  // Botón Iniciar Sesión
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Iniciar Sesión',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Botón Registrarse
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: Colors.white, width: 2),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Registrarse',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Texto informativo
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Crea una cuenta para guardar tus productos favoritos y realizar compras.',
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white70,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
