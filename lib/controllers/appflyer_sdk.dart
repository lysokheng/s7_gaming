import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:new_game/controllers/controller.dart';

class AppsFlyerSDK {
  late AppsflyerSdk appsflyerSdk;

  Future<void> option() async {
    AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
      afDevKey: afController.devkey.value,
      appId: afController.appID.value,
      timeToWaitForATTUserAuthorization: 10,
    );
    appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  }

  Future<void> init() async {
    appsflyerSdk.initSdk(
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true,
      registerConversionDataCallback: true,
    );
  }

  Future<bool?> logEvent(
      {required String event, required Map<dynamic, dynamic> value}) {
    print('debug: af -------- $event, $value');
    return appsflyerSdk.logEvent(event, value);
  }
}
