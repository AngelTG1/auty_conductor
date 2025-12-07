import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyWebViewPage extends StatefulWidget {
  const PrivacyWebViewPage({super.key});

  @override
  State<PrivacyWebViewPage> createState() => _PrivacyWebViewPageState();
}

class _PrivacyWebViewPageState extends State<PrivacyWebViewPage> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse("https://auty.up.railway.app/global/es/privacy"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Política de Privacidad",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),

          if (isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF235EE8)),
            ),
        ],
      ),
    );
  }
}
