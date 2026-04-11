import 'package:go_router/go_router.dart';
import 'package:my_tasks_app/screens/home_screen.dart';
import 'package:my_tasks_app/screens/splash_screen.dart';

final router = GoRouter(
  initialLocation: "/splash",
  routes: [
    GoRoute(
      path: "/splash",
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: "/",
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);