import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:new_game/controllers/controller.dart';
import 'package:url_launcher/url_launcher.dart';

class S7Gaming extends StatefulWidget {
  S7Gaming({super.key});

  @override
  State<S7Gaming> createState() => _S7GamingState();
}

class _S7GamingState extends State<S7Gaming> {
  late InAppWebViewController? viewController;
  String userAgent = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            InAppWebView(
              key: widget.key,
              initialUrlRequest:
                  URLRequest(url: WebUri(afController.result.value)),
              onLoadStart: (controller, url) async {
                String? ua = await controller.evaluateJavascript(
                    source: 'navigator.userAgent');
                userAgent = ua ?? 'Failed to get User-Agent.';
                print('debug url $url');
                loginRegisterEvent(controller, context, url.toString());
              },
              onLoadResource: (controller, resource) {
                depoUsdtEvent(controller, context);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;

                if (!afController.listExclude.contains(uri.scheme)) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(
                      uri,
                    );
                    return NavigationActionPolicy.CANCEL;
                  }
                }
                return NavigationActionPolicy.ALLOW;
              },
              onWebViewCreated: (controller) {
                viewController = controller; // Fetch the user agent
              },
              onConsoleMessage: (controller, consoleMessage) {
                if (consoleMessage.message == 'success') {
                  onlinePaymentEvent(controller, context);
                }
              },
              initialSettings:
                  InAppWebViewSettings(userAgent: "FAppEvent,$userAgent"),
              initialUserScripts: UnmodifiableListView<UserScript>([]),
            ),
          ],
        ),
      ),
    );
  }

  void loginRegisterEvent(
      InAppWebViewController controller, BuildContext context, String url) {
    var name = 'login_register';
    String jsScript = """
                (function() {
                  // Check if the Flutter JS bridge is available
                    const formId = document.getElementById('FormRegister')?.id || 'Form not found';
                    const username = document.getElementById('username_register')?.value || '';
                    const currency = document.getElementById('currency')?.value || '';

                    // Send data to Flutter via callHandler
                    window.flutter_inappwebview.callHandler('login_register', formId, username, currency);
              
                })();
                """;

    // Evaluate the script once the WebView is ready
    controller.evaluateJavascript(source: jsScript);

    //----------------------register
    controller.addJavaScriptHandler(
      handlerName: name,
      callback: (args) {
        // The args will contain the data sent from JavaScript
        String formId = args[0];
        String username = args[1];
        String currency = args[2];

        final Map<dynamic, dynamic> eventValues = {
          "content_id": name,
          "content_key": username,
          "content_value": currency
        };
        print('debug $name $eventValues');
        if (url == 'https://m.s7s7c.com/') {
          afController.appsflyerSDK.logEvent(event: name, value: eventValues);
        }
      },
    );
  }

  void onlinePaymentEvent(
      InAppWebViewController controller, BuildContext context) {
    var name = 'payment_online_form';
    String jsScript = """
  (function() {
    try {
      const formId = document.getElementById('online_form')?.id || 'Form not found';
      const amount = document.getElementById('amount')?.value || '0';
      const payType = document.getElementById('payType')?.value || 'Unknown';
      window.flutter_inappwebview.callHandler('payment', formId, amount, payType);
    } catch (error) {
      console.error('Error executing payment script:', error);
      window.flutter_inappwebview.callHandler('paymentError', error.message);
    }
  })();
""";

    controller.evaluateJavascript(source: jsScript);
    // Add JavaScript handlers
    controller.addJavaScriptHandler(
      handlerName: 'payment',
      callback: (args) {
        // Extract arguments sent from JavaScript
        String formId = args[0];
        String amount = args[1];
        String payType = args[2];

        // Log an event with Appsflyer or handle further
        final Map<String, dynamic> eventValues = {
          "af_content_id": name,
          "af_revenue": amount,
          "payment_method": payType,
          "af_currency": 'INR',
        };
        print('debug $name $eventValues');

        if (amount.isNotEmpty) {
          afController.appsflyerSDK.logEvent(event: name, value: eventValues);
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'paymentError',
      callback: (args) {
        String errorMessage = args[0];
        print('JavaScript Error: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error in JavaScript: $errorMessage')),
        );
      },
    );
  }

  void depoUsdtEvent(InAppWebViewController controller, BuildContext context) {
    var name = 'payment_depo_usdt';
    String jsScript = """
  (function() {
    try {
      const success = false;
      const formId = document.getElementById('depo_usdt_form')?.id || 'Form not found';
      const receiverAddress = document.getElementById('bankaccnoText')?.innerText || '';
      const amount = document.getElementById('depo_amt')?.value || '0';
      const rate = document.querySelector('input[name="usdt_rate"]')?.value || 'Unknown';
      const bankId = document.getElementById('bank')?.value || 'Unknown';
      const minAmount = document.getElementById('min_usdt')?.value || 'Unknown';
      const maxAmount = document.getElementById('max_usdt')?.value || 'Unknown';

      const submitButton = document.getElementById('btn-submit');

    submitButton.addEventListener('click', function(event) {
      // Prevent the default form submission
      event.preventDefault();

      const success = true; // Mark the form submission as successful
    });

      window.flutter_inappwebview.callHandler('depositForm', formId, receiverAddress, amount, rate, bankId, success);
    } catch (error) {
      console.error('Error executing deposit script:', error);
      window.flutter_inappwebview.callHandler('depositFormError', error.message);
    }
  })();
""";

    controller.evaluateJavascript(source: jsScript);

    controller.addJavaScriptHandler(
      handlerName: 'depositForm',
      callback: (args) {
        // Extract the arguments from JavaScript
        String formId = args[0];
        String receiverAddress = args[1];
        String amount = args[2];
        String rate = args[3];
        String bankId = args[4];
        bool success = args[5];
        print('debug success $success');
        amount = '${int.parse(amount) * int.parse(rate)}';
        // Log event or process the data

        final Map<String, dynamic> eventValues = {
          "af_content_id": name,
          "af_revenue": amount,
          "af_currency": 'INR',
          "receiver_address": receiverAddress,
          "rate": rate,
          "bank_id": bankId,
        };
        print('debug $name $eventValues');
        int amountInt = int.parse(amount);
        if (amountInt > 0) {
          afController.appsflyerSDK.logEvent(event: name, value: eventValues);
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'depositFormError',
      callback: (args) {
        String errorMessage = args[0];
        print('JavaScript Error: $errorMessage');
      },
    );
  }
}
