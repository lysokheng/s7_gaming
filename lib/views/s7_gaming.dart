import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:new_game/controllers/controller.dart';
import 'package:url_launcher/url_launcher.dart';

class S7Gaming extends StatelessWidget {
  S7Gaming({super.key});

  late InAppWebViewController? viewController;

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
              key: key,
              initialUrlRequest:
                  URLRequest(url: WebUri(afController.result.value)),
              onLoadStop: (controller, url) async {
                print('debug: onLoadStop');
              },
              onLoadStart: (controller, url) {
                // Add this
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
                viewController = controller;
              },
              initialUserScripts: UnmodifiableListView<UserScript>([]),
            ),
            Positioned(
              child: InkWell(
                onTap: () {},
                child: Text('Install App'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
