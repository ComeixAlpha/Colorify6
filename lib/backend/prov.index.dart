import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/backend/providers/page.prov.dart';
import 'package:colorify/backend/providers/particle.prov.dart';
import 'package:colorify/backend/providers/progress.prov.dart';
import 'package:colorify/backend/providers/socket.prov.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider<Pageprov>(create: (_) => Pageprov()),
  ChangeNotifierProvider<Particleprov>(create: (_) => Particleprov()),
  ChangeNotifierProvider<Blockprov>(create: (_) => Blockprov()),
  ChangeNotifierProvider<Progressprov>(create: (_) => Progressprov()),
  ChangeNotifierProvider<Socketprov>(create: (_) => Socketprov()),
];
