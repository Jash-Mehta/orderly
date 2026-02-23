import 'package:flutter/material.dart';
import 'package:orderly/core/utils/assets/assets.dart';


class AppLoadingIndicator extends StatefulWidget {
  const AppLoadingIndicator({
    super.key,
    this.onlyIcon = false,
  });

  final bool onlyIcon;

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
      const AssetImage(Assets.companyLogo),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.onlyIcon
          ? _buildLoader()
          : Center(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: _buildLoader(),
                ),
              ),
            ),
    );
  }

  Widget? _buildLoader() {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      height: 100,
      width: 100,
      child: Center(
        child: Image.asset(
          Assets.companyLogo,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
