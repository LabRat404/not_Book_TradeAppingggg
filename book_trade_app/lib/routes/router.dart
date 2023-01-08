import 'package:flutter/material.dart';
import 'package:trade_app/screens/home_page.dart';
import 'package:trade_app/screens/search.dart';
import 'package:trade_app/widgets/nav_bar.dart';
import 'package:trade_app/screens/login_page.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const LoginPage());
    case NavBar.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const NavBar());
    case HomePage.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomePage());
    case SearchPage.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const SearchPage());
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
