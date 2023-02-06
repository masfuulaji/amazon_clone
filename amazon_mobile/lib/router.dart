import 'package:amazon_mobile/common/widgets/bottom_bar.dart';
import 'package:amazon_mobile/features/auth/screens/auth_screen.dart';
import 'package:amazon_mobile/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(builder: (_) => const AuthScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case BottomBar.routeName:
      return MaterialPageRoute(builder: (_) => const BottomBar());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${routeSettings.name}'),
          ),
        ),
      );
  }
}
