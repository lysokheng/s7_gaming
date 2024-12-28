import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_game/controllers/appflyer_sdk.dart';
import 'package:new_game/views/s7_gaming.dart';

class AFController extends GetxController {
  RxString devkey = 'KDL3G3gCBvDDaco6g9zwQn'.obs;
  RxString appID = 'com.s7.gaming'.obs;
  AppsFlyerSDK appsflyerSDK = AppsFlyerSDK();
  RxString result = ''.obs;
  RxList<String> luaList = RxList.empty();
  final storage = GetStorage();
  var listExclude = [
    "http",
    "https",
    "file",
    "chrome",
    "data",
    "javascript",
    "about"
  ];
  RxString luaValue = ''.obs;
  RxInt value = 0.obs;

  Future<void> initAF() async {
    appsflyerSDK.option();
    appsflyerSDK.init();
    result.value = 'https://m.s7s7c.com';
    Get.off(() => S7Gaming());
  }
}
