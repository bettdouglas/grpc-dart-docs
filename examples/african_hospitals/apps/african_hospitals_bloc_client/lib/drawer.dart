import 'package:flutter/material.dart';

Drawer buildDrawer() {
  return Drawer(
    child: Column(
      children: const [
        DrawerHeader(
          child: Text('Hospital Functionalities'),
        ),
        ListTile(
          title: Text('All Hospitals'),
        ),
        ListTile(
          title: Text('Search Hospitals'),
        ),
      ],
    ),
  );
}
