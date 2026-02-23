
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:orderly/core/bloc_provider/bloc_provider_wrapper.dart';
import 'package:orderly/core/init/init_app.dart';
import 'package:orderly/core/router/app_router.dart';
import 'package:orderly/core/ui/theme/colors.dart';


Future<void> main() async {
  await initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProviderWrapper(
      child: MaterialApp.router(
        title: '',
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.white,
          fontFamily: 'Ubuntu',
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
          ),
        ),
        builder: EasyLoading.init(),
      ),
    );
  }
}
