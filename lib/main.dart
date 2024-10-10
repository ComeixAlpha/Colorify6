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

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  requestStorage().then(
    (v) {
      if (!v) {
        XFrame.insert(OverlayEntry(builder: (v) => const NoPermisson()));
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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
