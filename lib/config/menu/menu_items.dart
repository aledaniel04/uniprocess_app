import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subtitle;
  final String link;
  final IconData icon;

  const MenuItem(
      {required this.title,
      required this.subtitle,
      required this.link,
      required this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(
      title: "Inicio",
      subtitle: "pantalla de inicio",
      link: "/",
      icon: Icons.start),
  /* MenuItem(
      title: "lista de Estudiantes",
      subtitle: "todas las Listas",
      link: "/studentsList",
      icon: Icons.list_alt),
  MenuItem(
      title: "lista de Asistencias",
      subtitle: "todas las Asistencias",
      link: "/attendance",
      icon: Icons.assignment),
  MenuItem(
      title: "Lista de Notas",
      subtitle: "todas las notas",
      link: "/qualification",
      icon: Icons.wrap_text),*/
  MenuItem(
      title: "Reporte",
      subtitle: "todas los reportes",
      link: "/reports",
      icon: Icons.report),
  MenuItem(
      title: "plan de evaluacion",
      subtitle: "todas los planes de evaluacion",
      link: "/evaluationPlan",
      icon: Icons.ev_station),
  MenuItem(
      title: "Horarios",
      subtitle: "todas los horarios",
      link: "/schedule",
      icon: Icons.schedule),
  MenuItem(
      title: "Panel de usuario",
      subtitle: "datos del usuario",
      link: "/user",
      icon: Icons.account_circle),
  MenuItem(
      title: "tema",
      subtitle: "todo los temas",
      link: "/theme",
      icon: Icons.theater_comedy),
];
