
import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';

import 'package:orderly/core/ui/widgets/app_text.dart';
import 'package:orderly/core/ui/widgets/custom_button.dart';
import 'package:orderly/core/utils/assets/assets.dart';




class AppErrorWidget extends StatelessWidget {
  final String errorTitle;
  final String errorMessage;
  final String? buttonText;
  final VoidCallback? onTap;
  final String? packageName;
  final String? assetsImage;
  final double iconSize;
  final double topSpacing;
  final Color bgColor;
  final String? stack;

  const AppErrorWidget({
    Key? key,
    required this.errorTitle,
    this.errorMessage = '',
    this.buttonText,
    this.onTap,
    this.packageName,
    this.assetsImage,
    this.iconSize = 140,
    this.topSpacing = 140,
    this.bgColor = Colors.white,
    this.stack = "",
  }) : super(key: key);
  
  get SvgPicture => null;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      child:
          stack != "" ? _scrollableErrorWidget(context) : _errorWidget(context),
    );
  }

  Widget _scrollableErrorWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _errorContent(context),
            if (onTap != null)
              CustomButton(
                text: buttonText ?? "Retry",
                onPressed: (){
                  onTap;
                },
              ),
            if (stack != "")
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.redAccent, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    stack!,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _errorWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: topSpacing),
        _errorContent(context),
      ],
    );
  }

  Widget _errorContent(BuildContext context) {
    final theme = Theme.of(context);
    final image = assetsImage ?? Assets.noData;
    final isSvg = assetsImage?.toLowerCase().endsWith('.svg') ?? false;
    final package = assetsImage == null ? "" : packageName;
    return Column(
      children: [
        Center(
          child: isSvg
              ? SvgPicture.asset(
                  image,
                  width: iconSize,
                  height: iconSize,
                  package: package,
                )
              : Image.asset(
                  image,
                  width: iconSize,
                  height: iconSize,
                  package: package,
                ),
        ),
        const SizedBox(height: 8),
        AppText(
          errorTitle,
          style: theme.primaryTextTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w500, color: AppColors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        if (errorMessage.isNotEmpty)
          AppText(
            errorMessage,
            style: theme.primaryTextTheme.bodyMedium
                ?.copyWith(height: 2, color: AppColors.darkElectricBlue),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 8),
        if (onTap != null && stack == "")
          CustomButton(
            text: buttonText ?? "Retry",
            onPressed: ()=> onTap,
          ),
      ],
    );
  }
}
