
import 'package:flutter/material.dart';
import 'package:orderly/core/ui/widgets/rotating_widget.dart';
import 'package:orderly/core/utils/assets/assets.dart';

Widget appLoaderAnimated({
  double size = 80,
}) =>
    RotatingWidget(
      child: AppLoader(size: size),
    );

class AppLoader extends StatelessWidget {
  final double size;

  const AppLoader({
    super.key,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.companyLogo,
      height: size,
      width: size,
    );
  }
}
