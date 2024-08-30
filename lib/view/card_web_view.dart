import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CardWebView extends StatefulWidget {
  const CardWebView({super.key});

  @override
  State<CardWebView> createState() => _CardWebViewState();
}

class _CardWebViewState extends State<CardWebView> {
  late final WebViewController controller;

  // Future<WebViewController> _loadUrl() async {
  //   final controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setBackgroundColor(const Color(0x00000000))
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) {
  //           debugPrint('Progress: $progress');
  //         },
  //       ),
  //     );
  //   await controller.loadRequest(Uri.parse('https://kampuskart.gop.edu.tr'));

  //   return controller;
  // }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse("https://kampuskart.gop.edu.tr"),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOGÜ Yemekhane'),
        centerTitle: true,
      ),
      // body: FutureBuilder(
      //   future: _loadUrl(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     final controller = snapshot.data as WebViewController;
      //     return Center(
      //       child: WebViewWidget(controller: controller),
      //     );
      //   },
      // ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
