import 'package:go_router/go_router.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/alunos_page.dart';
import '../pages/contact_page.dart';
import '../pages/not_found_page.dart';
import '../pages/usuarios_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/usuarios',
      name: 'usuarios',
      builder: (context, state) => const UsuariosPage(),
    ),
    GoRoute(
      path: '/alunos',
      name: 'alunos',
      builder: (context, state) => const AlunosPage(),
    ),
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutPage(),
    ),
    GoRoute(
      path: '/contact',
      name: 'contact',
      builder: (context, state) => const ContactPage(),
    ),
  ],
  debugLogDiagnostics: true,
);
