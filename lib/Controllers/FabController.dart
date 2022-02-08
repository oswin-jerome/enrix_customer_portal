import 'package:get/get.dart';

class FabController extends GetxController {
  RxBool isOpen = true.obs;
  changeState(state) {
    isOpen.value = state;
  }
}
