import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uniprocess_app/config/menu/menu_items.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        setState(() {
          navDrawerIndex = value;
        });

        final menuItem = appMenuItems[value];
        context.push(menuItem.link);
      },
      children: [
        const Padding(
          padding: const EdgeInsets.fromLTRB(28, 20, 16, 10),
          child: Text(
            "Menu",
            style: TextStyle(fontSize: 20),
          ),
        ),
        ...appMenuItems.sublist(0, 4).map(
              (item) => NavigationDrawerDestination(
                  icon: Icon(item.icon), label: Text(item.title)),
            ),
        const Padding(
          padding: EdgeInsets.fromLTRB(30, 16, 30, 10),
          child: Divider(
            color: Colors.black,
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
          child: Text(
            "Mas opciones",
            style: TextStyle(fontSize: 20),
          ),
        ),
        ...appMenuItems.sublist(4).map(
              (item) => NavigationDrawerDestination(
                  icon: Icon(item.icon), label: Text(item.title)),
            ),
      ],
    );
  }
}
