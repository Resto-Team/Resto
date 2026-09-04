import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:resto/core/di/di.dart';
import 'package:resto/core/helpers/cache_helper.dart';
import 'package:resto/core/helpers/shared_prefs.dart';
import 'package:resto/core/routing/app_router.dart';
import 'package:resto/core/routing/navigator_key.dart';
import 'package:resto/core/routing/routes.dart';
import 'package:resto/core/theme/app_theme.dart';
import 'package:resto/core/theme/manager/theme_cubit.dart';
import 'package:resto/core/theme/manager/theme_state.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Initialize cache
  await CacheHelper().initCacheHelper();
  await setupServiceLocator();
  await dotenv.load(fileName: ".env");

  final token = await SharedPrefs.getToken();
  final initialRoute = token != null && token.isNotEmpty
      ? Routes.rootView
      : Routes.loginView;

  runApp(Resto(initialRoute: initialRoute));

  FlutterNativeSplash.remove();
}

class Resto extends StatelessWidget {
  const Resto({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ThemeCubit>()..loadSavedTheme(),
      child: ScreenUtilPlusInit(
        designSize: const Size(430, 932),
        ensureScreenSize: true,
        splitScreenMode: true,
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final themeMode = state is ThemeLoaded
                ? state.themeMode
                : getIt<ThemeCubit>().themeMode;
            return MaterialApp(
              navigatorKey: navigatorKey,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,
              onGenerateRoute: AppRouter().generateRoute,
              debugShowCheckedModeBanner: false,
              initialRoute: initialRoute,
            );
          },
        ),
      ),
    );
  }
}
