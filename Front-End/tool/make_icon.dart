// Builds the square launcher icons from the YallaDo mascot logo (images/logo.jpg).
//
// Produces:
//   * images/app_icon.png     – the logo full-bleed on a 1024 square (legacy icon)
//   * images/app_icon_fg.png  – the logo centered at ~78% on a square filled with
//                               the logo's own background colour, sized for the
//                               Android adaptive-icon safe zone (foreground layer)
//
// It also prints the sampled background colour so it can be set as
// `adaptive_icon_background` in pubspec.yaml for a seamless blend.
//
// Run:  dart run tool/make_icon.dart
import 'dart:io';
import 'package:image/image.dart' as img;

const int size = 1024;

void main() {
  final bytes = File('images/logo.jpg').readAsBytesSync();
  final logo = img.decodeImage(bytes);
  if (logo == null) {
    stderr.writeln('Could not decode images/logo.jpg');
    exit(1);
  }

  // Sample the top-left corner for the background colour.
  final c = logo.getPixel(4, 4);
  final hex = '#${_h(c.r)}${_h(c.g)}${_h(c.b)}';
  stdout.writeln('Sampled background colour: $hex');

  // Legacy icon: logo resized full-bleed to a square.
  final legacy = img.copyResize(logo,
      width: size, height: size, interpolation: img.Interpolation.cubic);
  File('images/app_icon.png').writeAsBytesSync(img.encodePng(legacy));

  // Adaptive foreground: logo at ~78% on a square of the same background colour,
  // so the outer (cropped) ring is just flat background — no visible seam.
  final canvas = img.Image(width: size, height: size, numChannels: 4);
  img.fill(canvas,
      color: img.ColorRgb8(c.r.toInt(), c.g.toInt(), c.b.toInt()));
  final targetW = (size * 0.78).round();
  final scaled = img.copyResize(logo,
      width: targetW, interpolation: img.Interpolation.cubic);
  final dx = ((size - scaled.width) / 2).round();
  final dy = ((size - scaled.height) / 2).round();
  img.compositeImage(canvas, scaled, dstX: dx, dstY: dy);
  File('images/app_icon_fg.png').writeAsBytesSync(img.encodePng(canvas));

  stdout.writeln('Wrote images/app_icon.png and images/app_icon_fg.png');
}

String _h(num v) => v.toInt().toRadixString(16).padLeft(2, '0');
