import 'package:flutter/material.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/models/sales_model.dart';
import 'package:sales_management/screens/add_product/add_product_screen.dart';
import 'package:sales_management/screens/add_product/component/add_new_item.dart';
import 'package:sales_management/screens/dashboard/dashbaord_screen.dart';
import 'package:sales_management/screens/detail/detail_screen.dart';
import 'package:sales_management/screens/register/register_screen.dart';
import 'package:sales_management/screens/report/reports.dart';
import 'package:sales_management/screens/splash/splash_screen.dart';

class Pages {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (context) {
          return const SplashScreen();
        });
      case Routes.register:
        return MaterialPageRoute(builder: (context) {
          return RegisterScreen();
        });
      case Routes.dashboard:
        return MaterialPageRoute(builder: (context) {
          return const DashbaordScreen();
        });
      case Routes.add:
        return MaterialPageRoute(builder: (context) {
          int type = settings.arguments as int;
          return AddProductScreen(
            type: type,
          );
        });
      case Routes.addItem:
        return MaterialPageRoute(builder: (context) {
          int type = settings.arguments as int;
          return AddNewItem(
            type: type,
          );
        });
      case Routes.reports:
        return MaterialPageRoute(builder: (context) {
          List<dynamic> data = settings.arguments as List;
          int type = data[0];
          String title = data[1];
          return Reports(
            type: type,
            title: title,
          );
        });
      case Routes.detail:
        return MaterialPageRoute(builder: (context) {
          final arguments = settings.arguments as List;
          Datum model = arguments[0] as Datum;
          int type = arguments[1] as int;

          return DetailScreen(
            
            model: model,
            type: type,
          );
        });
      default:
        return _ErroRoute();
    }
  }

  static Route<dynamic> _ErroRoute() {
    return MaterialPageRoute(builder: (context) {
      return const Scaffold(
        body: Center(
          child: Text('Error Route'),
        ),
      );
    });
  }
}
