import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MinistryPage extends StatefulWidget {
  const MinistryPage({super.key});

  @override
  State<MinistryPage> createState() => _MinistryPageState();
}

class _MinistryPageState extends State<MinistryPage> {
  late final WebViewController controller;
  bool isLoading = true; // track loading state

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://moa.gov.eg'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
