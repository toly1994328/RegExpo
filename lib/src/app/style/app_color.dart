import 'dart:ui';

class AppThemeColor {
  final Color outLineColor;
  final Color dividerColor;
  final Color titleColor;
  final Color subTitleColor;
  final Color activeNavColor;
  final Color navIconColor;

  const AppThemeColor({
    required this.outLineColor,
    required this.dividerColor,
    required this.titleColor,
    required this.subTitleColor,
    required this.activeNavColor,
    required this.navIconColor,
  });

  static const AppThemeColor light = AppThemeColor(
    outLineColor: Color(0xffF2F2F2),
    dividerColor: Color(0xffD1D1D1),
    titleColor: Color(0xff000000),
    subTitleColor: Color(0xffCECBCD),
    activeNavColor: Color(0xffBDBDBD),
    navIconColor: Color(0xff6E6E6E),
  );
//
  static const AppThemeColor dark = AppThemeColor(
    outLineColor: Color(0xff3C3F41),
    dividerColor: Color(0xff323232),
    titleColor: Color(0xff000000),
    subTitleColor: Color(0xffCECBCD),
    activeNavColor: Color(0xff2C2E2F),
    navIconColor: Color(0xffAFB1B3),
  );
}
