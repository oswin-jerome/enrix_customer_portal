import 'package:get/get.dart';

class DrawerController extends GetxController {
  RxString currentPage = 'Home'.obs;

  void changePage(String page) {
    currentPage.value = page;
  }
}
