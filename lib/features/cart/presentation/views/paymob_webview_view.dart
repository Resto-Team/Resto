import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:resto/core/network/paymob_constants.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class PaymobWebViewScreen extends StatefulWidget {
  final String clientSecret;

  const PaymobWebViewScreen({super.key, required this.clientSecret});

  @override
  State<PaymobWebViewScreen> createState() => _PaymobWebViewScreenState();
}

class _PaymobWebViewScreenState extends State<PaymobWebViewScreen> {
  late final WebViewController _controller;
  late final String _url;
  bool _isLoading = true;
  bool _isHandled = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _url = PaymobConstants.getUnifiedCheckoutUrl(widget.clientSecret);
    developer.log('Opening Paymob Unified Checkout URL: $_url', name: 'Paymob');

    final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36')
      ..setBackgroundColor(Colors.white)
      ..setOnConsoleMessage((JavaScriptConsoleMessage message) {
        developer.log('JS [${message.level.name}]: ${message.message}', name: 'Paymob');
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            developer.log('Page started: $url', name: 'Paymob');
            if (mounted) setState(() => _isLoading = true);
            _checkUrl(url);
          },
          onPageFinished: (String url) {
            developer.log('Page finished: $url', name: 'Paymob');
            if (mounted) setState(() => _isLoading = false);
            _checkUrl(url);
          },
          onWebResourceError: (WebResourceError error) {
            developer.log(
              'WebResourceError: ${error.description}, code: ${error.errorCode}, type: ${error.errorType}',
              name: 'Paymob',
            );
            if (mounted && _isLoading) {
              setState(() {
                _errorMessage = error.description;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            developer.log('Navigating to: ${request.url}', name: 'Paymob');
            _checkUrl(request.url);
            return NavigationDecision.navigate;
          },
        ),
      );

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      final androidController = controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    controller.loadRequest(Uri.parse(_url));
    _controller = controller;
  }

  void _checkUrl(String url) {
    if (_isHandled) return;

    final uri = Uri.tryParse(url);
    if (uri == null) return;

    // Paymob Callback / Redirection URL parameters
    if (uri.queryParameters.containsKey('success')) {
      final success = uri.queryParameters['success'];
      if (success == 'true') {
        _isHandled = true;
        if (mounted) Navigator.pop(context, true);
      } else if (success == 'false') {
        _isHandled = true;
        if (mounted) Navigator.pop(context, false);
      }
    } else if (url.contains('txn_response_code=APPROVED') || url.contains('approved=true')) {
      _isHandled = true;
      if (mounted) Navigator.pop(context, true);
    } else if (url.contains('txn_response_code=DECLINED') || url.contains('txn_response_code=CANCELLED')) {
      _isHandled = true;
      if (mounted) Navigator.pop(context, false);
    }
  }

  Future<void> _openInExternalBrowser() async {
    final uri = Uri.parse(_url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Online Payment',
          style: TextStyle(
            color: AppColors.lightTextPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: _openInExternalBrowser,
              icon: const Icon(
                Icons.open_in_browser,
                color: AppColors.primaryColor,
                size: 20,
              ),
              label: const Text(
                'فتح في المتصفح الخارجي',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          if (_errorMessage != null && !_isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                          _isLoading = true;
                        });
                        _controller.reload();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: const Text('Retry', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SafeArea(
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'لو تم الدفع من المتصفح الخارجي:',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'تم الدفع بنجاح',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
