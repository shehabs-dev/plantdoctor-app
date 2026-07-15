import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../config/localization/generated/l10n.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../network_system/presentation/cubit/connectivity/connectivity_cubit.dart';

class MinistryPage extends StatefulWidget {
  const MinistryPage({super.key});

  @override
  State<MinistryPage> createState() => _MinistryPageState();
}

class _MinistryPageState extends State<MinistryPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  static final _url = EnvConfig.ministryUrl;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _isLoading = true;
            _hasError = false;
          }),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (error) {
            if (error.isForMainFrame == true) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(_url));
  }

  void _reload() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _controller.loadRequest(Uri.parse(_url));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit, ConnectivityState>(
      // ── Auto-reload when coming back online ────────────────────────
      listener: (context, state) {
        if (state is ConnectivityOnline && _hasError) {
          _reload();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // ── WebView — always in tree so state is preserved ────────
            Opacity(
              opacity: _hasError ? 0 : 1,
              child: WebViewWidget(controller: _controller),
            ),

            // ── Loading indicator ─────────────────────────────────────
            if (_isLoading && !_hasError)
              const Center(child: CircularProgressIndicator()),

            // ── Offline / error state ─────────────────────────────────
            if (_hasError) _buildErrorState(context),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOnline =
        context.watch<ConnectivityCubit>().state is ConnectivityOnline;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPaddingH.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSizes.avatarXxl.r,
              height: AppSizes.avatarXxl.r,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isOnline ? Icons.error_outline_rounded : Icons.wifi_off_rounded,
                size: AppSizes.iconXl.r,
                color: colorScheme.error,
              ),
            ),
            SizedBox(height: AppSizes.spaceMd.h),
            Text(
              isOnline ? S.of(context).serverError : S.of(context).offlineError,
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.spaceMd.h),
            SizedBox(
              width: 160.w,
              child: ElevatedButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(S.of(context).retry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
