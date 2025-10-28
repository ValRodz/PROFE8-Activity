import 'package:flutter/material.dart';

/// NetImage tries the primary URL first, then falls back to two reliable CDNs
/// (Unsplash, Picsum) so your UI never breaks if a host blocks/decodes badly.
class NetImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const NetImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  State<NetImage> createState() => _NetImageState();
}

class _NetImageState extends State<NetImage> {
  late final List<String> _candidates;
  int _idx = 0;

  static const _unsplash =
      'https://images.everydayhealth.com/images/diet-nutrition/apples-101-about-1440x810.jpg?w=508';
  static const _picsum = 'https://picsum.photos/seed/flutterfruit/800/600';

  bool _likelyBlocked(String u) {
    final host = Uri.tryParse(u)?.host.toLowerCase() ?? '';
    return host.contains('pinimg.com') || host.contains('pinterest');
  }

  @override
  void initState() {
    super.initState();
    // If the primary is a known-problem host, try fallbacks first.
    if (_likelyBlocked(widget.url)) {
      _candidates = [_unsplash, _picsum, widget.url];
    } else {
      _candidates = [widget.url, _unsplash, _picsum];
    }
  }

  @override
  Widget build(BuildContext context) {
    final img = Image.network(
      _candidates[_idx],
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.black12,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(strokeWidth: 2),
        );
      },
      errorBuilder: (context, error, stack) {
        // Try next candidate, if any
        if (_idx < _candidates.length - 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _idx += 1);
          });
          return Container(
            width: widget.width,
            height: widget.height,
            color: Colors.black12,
          );
        }
        // All failed: show a simple placeholder
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.black12,
          alignment: Alignment.center,
          child: const Icon(Icons.broken_image, color: Colors.grey, size: 28),
        );
      },
    );

    if (widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: img);
    }
    return img;
  }
}
