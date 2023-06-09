import 'package:go_router/go_router.dart';
import 'package:uniprocess_app/screens/screen.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: "/inicio",
  routes: [
    /*GoRoute(
      path: "/",
      name: HomeScreen.name,
      builder: (context, state) =>  HomeScreen(),
    ),*/
    GoRoute(
      path: "/inicio",
      name: HomeScreen.name,
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: "/Period",
      name: PeriodScreen.name,
      builder: (context, state) => const PeriodScreen(),
    ),
    /* GoRoute(
      path: "/studentsList",
      //name:
      builder: (context, state) => const StudentsList(),
    )*/
    /*GoRoute(
      path: "/attendance",
      //name: ,
      builder: (context, state) => const AttendanceScreen(),
    ),*/
    /*GoRoute(
      path: "/qualification",
      //name:
      builder: (context, state) => const QualificationScreen(),
    ),*/
    /*GoRoute(
      path: "/reports",
      name: ReportScreen.name,
      builder: (context, state) => const ReportScreen(),
    ),*/
    /*GoRoute(
      path: "/evaluationPlan",
      //name: ,
      builder: (context, state) => const EvaluationPlanScreen(),
    ),*/
    GoRoute(
      path: "/schedule",
      //name:
      builder: (context, state) => const ScheduleScreen(),
    ),
    GoRoute(
      path: "/user",
      //name:
      builder: (context, state) => const UserScreen(),
    ),
    /*GoRoute(
      path: "/theme",
      //name:
      builder: (context, state) => const HorarioScreen(),
    ),*/
  ],
);
