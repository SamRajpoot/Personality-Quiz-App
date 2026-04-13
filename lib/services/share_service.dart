import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareText(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }

  Future<void> sharePngFromBoundary({
    required GlobalKey boundaryKey,
    String? text,
  }) async {
    final ctx = boundaryKey.currentContext;
    if (ctx == null) return;
    final boundary = ctx.findRenderObject();
    if (boundary is! RenderRepaintBoundary) return;
    final image = await boundary.toImage(pixelRatio: 3);
    final bd = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bd == null) return;
    final bytes = bd.buffer.asUint8List();
    await _shareBytes(bytes, text: text);
  }

  Future<void> _shareBytes(Uint8List bytes, {String? text}) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/personasphere_result.png');
    await file.writeAsBytes(bytes);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], text: text),
    );
  }
}
