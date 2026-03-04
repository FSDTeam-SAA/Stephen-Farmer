/* import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_theme_controller.dart';

class RoleBackground extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  const RoleBackground({super.key, required this.child, this.appBar, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    final t = Get.find<AppThemeController>();

    return Obx(() {
      return Scaffold(
        backgroundColor: t.scaffoldBg,
        appBar: appBar,
        bottomNavigationBar: bottomNavigationBar,
        body: Container(
          decoration: t.isInteriorTheme ? BoxDecoration(gradient: t.interiorGradient) : null,
          child: SafeArea(child: child),
        ),
      );
    });
  }
}
 */

import 'package:flutter/material.dart';

class RoleBgColor {
  static const LinearGradient interiorGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xffE6E1DB), Color(0xff847C69)],
  );

  static const BoxDecoration interiorDecoration = BoxDecoration(
    gradient: interiorGradient,
  );

  static bool isInterior(String role) {
    final r = role.toLowerCase().trim();

    return r.contains("interior");
  }

  static BoxDecoration? decoration(String role) {
    if (isInterior(role)) {
      return interiorDecoration;
    }

    return null; // construction হলে gradient নাই
  }

  static Color scaffoldColor(String role) {
    return isInterior(role) ? Colors.transparent : Colors.black;
  }
}
