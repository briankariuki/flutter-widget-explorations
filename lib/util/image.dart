import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewtworkImageWrapper extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const NewtworkImageWrapper({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
  });

  @override
  State<NewtworkImageWrapper> createState() => _NewtworkImageWrapperState();
}

class _NewtworkImageWrapperState extends State<NewtworkImageWrapper> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
      placeholder: (
        _,
        __,
      ) =>
          Container(
        color: Colors.black12,
      ),
      errorWidget: (_, __, ___) => Container(
        color: Colors.black45,
      ),
    );
  }
}
