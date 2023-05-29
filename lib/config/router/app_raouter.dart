import 'package:go_router/go_router.dart';
import 'package:uniprocess_app/screens/home_screen.dart';
import 'package:uniprocess_app/screens/screen.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    )
  ],
);
