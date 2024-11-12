import 'package:daily_verse/constants/app_strings.dart';
import 'package:daily_verse/helpers/app_init_helper.dart';
import 'package:daily_verse/providers/appearance_provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:nb_utils/nb_utils.dart';

var logger = Logger();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInit.initMain();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const ProviderScope(
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // bool isAppLoading = ref.watch(isAppLoadingProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appName,
          // ignore: deprecated_member_use
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          theme: FlexColorScheme.light(scheme: FlexScheme.redM3, useMaterial3: true, fontFamily: 'Poppins').toTheme,
          darkTheme: FlexColorScheme.dark(scheme: FlexScheme.redM3, useMaterial3: true, fontFamily: 'Poppins').toTheme,
          themeMode: getThemeMode(ref),
          home: const Root(),
        );
      },
    );
  }
}

class Root extends ConsumerStatefulWidget {
  const Root({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RootState();
}

class _RootState extends ConsumerState<Root> with TickerProviderStateMixin {
  //Anim
  late AnimationController controller;
  Tween<double> tween = Tween(begin: 0.8, end: 1);

  @override
  void initState() {
    super.initState();
    //Anim
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    controller.repeat(reverse: true);

    afterBuildCreated(() {
      _init();
    });
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  _init() async {
    ref.read(appearanceProvider.notifier).loadAppearance();
    await AppInit.initLocalNotif();
    if (mounted) {
      AppInit.initAppData(context, ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xff740938) : const Color(0xffAF1740),
      body: Container(
        decoration: const BoxDecoration(),
        child: Center(
          child: ScaleTransition(
            scale: tween.animate(CurvedAnimation(parent: controller, curve: Curves.ease)),
            // child: Image(
            //   height: 100.h,
            //   width: 100.w,
            //   image: const AssetImage('assets/icon/icon_round.png'),
            // ),
          ),
        ),
      ),
    );
  }
}
