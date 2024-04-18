import 'package:dartt_certified/view/view_cicor.dart';
import 'package:dartt_certified/view/view_home.dart';
import 'package:dartt_certified/view/view_jbrugada.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final pages = <GetPage>[
    GetPage(name: PageRoutes.home, page: () => const ViewHome()),
    GetPage(name: PageRoutes.jbrugada, page: () => const ViewJbrugada()),
    GetPage(name: PageRoutes.cicor, page: () => const ViewCicor()),
  ];
}

abstract class PageRoutes {
  static const String home = '/home';
  static const String jbrugada = '/jbrugada';
  static const String cicor = '/cicor';
}
