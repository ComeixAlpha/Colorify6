import 'dart:io';

import 'package:colorify/backend/prov.index.dart';
import 'package:colorify/backend/utils/permisson.dart';
import 'package:colorify/frontend/components/no_permisson.dart';
import 'package:colorify/frontend/scaffold/body.dart';
import 'package:colorify/frontend/scaffold/bottombar.dart';
import 'package:colorify/frontend/scaffold/topbar.dart';
import 'package:colorify/ui/basic/xframe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

SharedPreferences? pref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    windowManager.center();
  }

  requestStorage().then(
    (v) {
      if (!v) {
        OverlayEntry? oe;
        oe = OverlayEntry(
          builder: (v) => NoPermisson(
            onCallClose: () => oe?.remove(),
          ),
        );
        XFrame.insert(oe);
      }
    },
  );

  runApp(
    MultiProvider(
      providers: providers,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowResized() async {
    if (Platform.isWindows) {
      final size = await windowManager.getSize();
      if (size.width <= 380) {
        windowManager.setSize(Size(380, size.height));
      }
      if (size.height <= 750) {
        windowManager.setSize(Size(size.width, 750));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [],
    );

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ));

    final mqs = MediaQuery.of(context).size;

    return XFrame(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Topbar(
                  width: mqs.width,
                  height: mqs.height * 0.1,
                ),
                Body(
                  width: mqs.width,
                  height: mqs.height * 0.9,
                ),
              ],
            ),
            const Positioned(
              bottom: 14,
              child: Bottombar(),
            )
          ],
        ),
      ),
    );
  }
}
