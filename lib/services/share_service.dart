import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  Future<void> shareText(String text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  }

  Future<void> sharePngFromBoundary({
    required GlobalKey boundaryKey,
    String? text,
  }) async {
    // Ensure the boundary has had a chance to paint before capture.
    await WidgetsBinding.instance.endOfFrame;
    final ctx = boundaryKey.currentContext;
    if (ctx == null) {
      throw StateError('Share preview is not ready yet.');
    }
    final boundary = ctx.findRenderObject();
    if (boundary is! RenderRepaintBoundary) {
      throw StateError('Share preview could not be prepared.');
    }
    if (boundary.debugNeedsPaint) {
      await WidgetsBinding.instance.endOfFrame;
    }
    final image = await boundary.toImage(pixelRatio: 3);
    final bd = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bd == null) {
      throw StateError('Share image bytes were empty.');
    }
    final bytes = bd.buffer.asUint8List();
    await _shareBytes(bytes, text: text);
  }

  Future<void> _shareBytes(Uint8List bytes, {String? text}) async {
    final file = XFile.fromData(
      bytes,
      mimeType: 'image/png',
      name: 'personasphere_result.png',
    );
    await SharePlus.instance.share(
      ShareParams(files: [file], text: text),
    );
  }
}
