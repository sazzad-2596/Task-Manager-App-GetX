import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../widgets/body_background.dart';
import 'login_screen.dart';
import 'main_bottom_nav_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void splashScreenTimeOut() async {
    bool isLoggedIn = await Get.find<Auth>().checkUserAuthState();

    Future.delayed(const Duration(seconds: 4)).then((value) {
      Get.offAll(isLoggedIn
          ? const MainBottomNavScreen()
          : const LoginScreen());
    });
  }

  @override
  void initState() {
    super.initState();
    splashScreenTimeOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackGround(
        showBottomCircularLoading: true,
        child: Center(
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            width: 120,
          ),
        ),
      ),
    );
  }
}