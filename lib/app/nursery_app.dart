import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nursery/app/routes.dart';
import 'package:nursery/provider/theme.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class NurseryApp extends StatefulWidget {
  const NurseryApp({super.key});

  @override
  State<NurseryApp> createState() => _NurseryAppState();
}

class _NurseryAppState extends State<NurseryApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<InternetConnectionStatus>(
          initialData: InternetConnectionStatus.connected,
          create: (_) {
            return InternetConnectionChecker().onStatusChange;
          },
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, child){
          return Sizer(
            builder: (context,orientation, screenType){
              return GetMaterialApp(
                  scrollBehavior: MyBehavior(),
              title: 'Amank',
              navigatorKey: rootNavigatorKey,
              routes: Routes.routes,
              initialRoute: '/',
              textDirection: TextDirection.ltr,
              theme: theme.lightTheme(context),
              darkTheme: theme.darkTheme(context),
              debugShowCheckedModeBanner: false,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              ),
              );
            }
          );
        } ,
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}