import 'package:flutter/material.dart';

/// Web-safe image widgets.
///
/// On Flutter web, `Image.network`/`NetworkImage` fetch cross-origin images via
/// XHR and THROW on CORS/load failure (unlike Android). Without an error
/// handler that throw is reported to the zone and pauses the VS Code debugger
/// ("breaks on exception"), freezing the app a couple of seconds after a screen
/// that shows remote images. These widgets always supply an `errorBuilder`, so
/// a failed image degrades to a fallback instead of throwing.

/// Circular avatar that falls back to [fallbackAsset] when [url] is empty or
/// fails to load.
class AppAvatar extends StatelessWidget {
  final String? url;
  final double radius;
  final String fallbackAsset;

  const AppAvatar({
    super.key,
    required this.url,
    this.radius = 24,
    this.fallbackAsset = 'images/avatar1.png',
  });

  @override
  Widget build(BuildContext context) {
    final double size = radius * 2;
    final Widget fallback =
        Image.asset(fallbackAsset, width: size, height: size, fit: BoxFit.cover);
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: (url != null && url!.isNotEmpty)
            ? Image.network(
                url!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback,
              )
            : fallback,
      ),
    );
  }
}

/// Rectangular network image with a safe fallback.
class AppNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppNetworkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: const Color(0xFFE8DDD0),
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined,
            color: Colors.white70),
      ),
    );
  }
}
