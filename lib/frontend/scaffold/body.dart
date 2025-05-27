import 'package:colorify/backend/providers/page.prov.dart';
import 'package:colorify/frontend/pages/block/page_block.dart';
import 'package:colorify/frontend/pages/particle/page_particle.dart';
import 'package:colorify/frontend/pages/socket/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  final double width;
  final double height;
  const Body({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final pageprov = context.watch<Pageprov>();
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF26232a),
      child: [
        PageParticle(width: width, height: height),
        PageBlock(width: width, height: height),
        const SocketPage(),
      ][pageprov.page],
    );
  }
}
