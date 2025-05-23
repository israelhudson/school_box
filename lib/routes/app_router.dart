import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/about_page.dart';
import '../pages/contact_page.dart';
import '../pages/not_found_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/about', builder: (context, state) => const AboutPage()),
    GoRoute(path: '/contact', builder: (context, state) => const ContactPage()),
  ],
);
