import 'dart:io';

import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/backend/extensions/on_string.dart';
import 'package:colorify/backend/providers/particle.prov.dart';
import 'package:colorify/frontend/pages/particle/particle_arguments.dart';
import 'package:colorify/frontend/scaffold/bottombar.dart';
import 'package:image/image.dart';

class GenParticleArguments {
  Image? image;
  List<int?> size;
  int interpolation;
  double? heig;
  double? rx;
  double? ry;
  double? rz;
  String? pkName;
  String? pkAuth;
  String? pkDesc;
  final int plane;
  final GenerateType type;
  GenerateMode mode;
  final Directory outDir;
  final List<RGBMapping> mappings;

  GenParticleArguments({
    required this.image,
    required this.size,
    required this.interpolation,
    required this.heig,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.pkName,
    required this.pkAuth,
    required this.pkDesc,
    required this.plane,
    required this.type,
    required this.mode,
    required this.outDir,
    required this.mappings,
  });

  static GenParticleArguments from(
    Particleprov provider,
    Image? image,
    GenerateType type,
    Directory outDir,
  ) {
    return GenParticleArguments(
      image: image,
      size: [
        ptecresizew.text.toInt(),
        ptecresizeh.text.toInt(),
      ],
      interpolation: provider.interpolation,
      heig: ptecHeight.text.toDouble(),
      rx: ptecrx.text.toDouble(),
      ry: ptecry.text.toDouble(),
      rz: ptecrz.text.toDouble(),
      pkName: ptecpkname.text,
      pkAuth: ptecpkauth.text,
      pkDesc: ptecpkdesc.text,
      plane: provider.plane,
      type: type,
      mode: provider.mode,
      outDir: outDir,
      mappings: provider.mappings,
    );
  }
}
