import 'package:flutter/material.dart';
import 'package:mobile_software_development/auth_service.dart';
import 'package:mobile_software_development/dashboard_page.dart';
import 'package:mobile_software_development/formulario_cadastro.dart';
import 'package:mobile_software_development/home_page.dart';
import 'package:mobile_software_development/login_page.dart';
import 'package:mobile_software_development/profile_page.dart';
import 'package:mobile_software_development/settings_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Roteamento',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        final authService = Provider.of<AuthService>(context, listen: false);
        final routeName = settings.name;

        final privateRoutes = ['/home', '/settings', '/profile', '/dashboard'];

        final isPrivateRoute = privateRoutes.contains(routeName);
        final isAuthenticated = authService.isAuthenticated;

        if (isPrivateRoute && !isAuthenticated) {
          return MaterialPageRoute(builder: (_) => const LoginPage());
        }

        switch (routeName) {
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/cadastro':
            return MaterialPageRoute(builder: (_) => const FormularioCadastro());

          case '/home':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsPage());
          case '/dashboard':
            return MaterialPageRoute(builder: (_) => const DashboardPage());
          case '/profile':
            final args = settings.arguments as Map<String, String>?;
            if (args != null) {
              return MaterialPageRoute(builder: (_) => ProfilePage(userData: args));
            }
            return MaterialPageRoute(builder: (_) => const HomePage());
          default:
            return MaterialPageRoute(builder: (_) => const LoginPage());
        }
      },
    );
  }
}