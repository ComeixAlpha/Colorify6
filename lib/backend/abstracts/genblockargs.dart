import 'dart:io';
import 'package:colorify/backend/abstracts/rgbmapping.dart';
import 'package:colorify/backend/extensions/on_string.dart';
import 'package:colorify/backend/providers/block.prov.dart';
import 'package:colorify/frontend/pages/block/block_arguments.dart';
import 'package:colorify/frontend/scaffold/bottombar.dart';
import 'package:image/image.dart';

class GenBlockArguments {
  Image? image;
  List<int?> size;
  int interpolation;
  String? pkName;
  String? pkAuth;
  String? pkDesc;
  String? version;
  List<int?>? basicOffset;
  final int plane;
  final int colordistance;
  final bool stairType;
  bool useStruct;
  final bool dithering;

  String? staircaseGap;
  String? fscoe;
  String? wsDelay;

  final Directory outDir;
  final List<RGBMapping> palette;
  final GenerateType type;

  GenBlockArguments({
    required this.image,
    required this.size,
    required this.interpolation,
    required this.outDir,
    required this.palette,
    required this.pkName,
    required this.pkAuth,
    required this.pkDesc,
    required this.version,
    required this.basicOffset,
    required this.plane,
    required this.colordistance,
    required this.stairType,
    required this.useStruct,
    required this.dithering,
    required this.staircaseGap,
    required this.fscoe,
    required this.wsDelay,
    required this.type,
  });

  static GenBlockArguments from(
    Blockprov provider, {
    required GenerateType type,
    required Image? image,
    required Directory outDir,
  }) {
    return GenBlockArguments(
      type: type,
      image: image,
      size: [
        btecresizew.text.toInt(),
        btecresizeh.text.toInt(),
      ],
      interpolation: provider.interpolation,
      outDir: outDir,
      palette: provider.filteredPalette,
      pkName: btecpkname.text,
      pkAuth: btecpkauth.text,
      pkDesc: btecpkdesc.text,
      version: btecflattn.text,
      basicOffset: [
        btecbox.text.toInt(),
        btecboy.text.toInt(),
        btecboz.text.toInt(),
      ],
      plane: provider.plane,
      colordistance: provider.rgb,
      stairType: provider.stairType,
      useStruct: provider.useStruct,
      dithering: provider.dithering,
      staircaseGap: btecstaircasegap.text,
      fscoe: btecfscoe.text,
      wsDelay: btecwscommanddelay.text,
    );
  }
}
