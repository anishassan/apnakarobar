import 'package:flutter/material.dart';
import 'package:sales_management/bindings/routes.dart';
import 'package:sales_management/extensions/size_extension.dart';
import 'package:sales_management/gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.of(context).pushReplacementNamed(Routes.register);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Assets.images.splash.image(
        width: context.getSize.width,height: context.getSize.height,
        fit: BoxFit.fill
      ),
    );
  }
}