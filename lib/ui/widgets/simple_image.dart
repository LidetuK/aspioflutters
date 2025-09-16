import 'package:flutter/material.dart';

class SimpleImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const SimpleImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  State<SimpleImage> createState() => _SimpleImageState();
}

class _SimpleImageState extends State<SimpleImage> {
  bool _hasError = false;
  int _currentProxyIndex = 0;

  // List of reliable CORS proxy services
  final List<String> _proxyServices = [
    'https://api.allorigins.win/raw?url=',
    'https://corsproxy.io/?',
    'https://api.codetabs.com/v1/proxy?quest=',
  ];

  String get _currentImageUrl {
    if (_currentProxyIndex < _proxyServices.length) {
      return _proxyServices[_currentProxyIndex] + Uri.encodeComponent(widget.imageUrl);
    }
    return widget.imageUrl; // Direct URL as final fallback
  }

  void _tryNextProxy() {
    if (_currentProxyIndex < _proxyServices.length) {
      setState(() {
        _currentProxyIndex++;
        _hasError = false;
      });
    } else {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl.isEmpty) {
      return _buildPlaceholder('No Image');
    }

    if (_hasError) {
      return _buildPlaceholder('Image Unavailable');
    }

    return Image.network(
      _currentImageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('Image load failed with proxy $_currentProxyIndex: $error');
        _tryNextProxy();
        
        if (_hasError) {
          return _buildPlaceholder('Image Unavailable');
        }
        
        // Still trying proxies, show loading
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(String text) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image,
            size: 32,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
