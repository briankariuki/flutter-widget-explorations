import 'dart:math';

import 'package:flutter/material.dart';

import '../models/models.dart';
import 'widgets.dart';

class QuoteCardWidget extends StatefulWidget {
  final Quote quote;

  final Function(Quote quote) onBookmark;
  final Function(Quote quote) onShare;

  const QuoteCardWidget({
    super.key,
    required this.quote,
    required this.onBookmark,
    required this.onShare,
  });

  @override
  State<QuoteCardWidget> createState() => _QuoteCardWidgetState();
}

class _QuoteCardWidgetState extends State<QuoteCardWidget> {
  late Color color;

  @override
  void initState() {
    super.initState();

    color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.format_quote,
                    color: Colors.white,
                    size: 32.0,
                  ),
                  const SizedBox(height: 4.0),
                  Flexible(
                    child: HeadlineSmall(
                      title: widget.quote.content!,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      lineHeight: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Flexible(
                    child: BodyMedium(
                      title: widget.quote.author!.toUpperCase(),
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    splashRadius: 20.0,
                    onPressed: () => widget.onBookmark(widget.quote),
                    icon: Icon(
                      widget.quote.bookmarked == true ? Icons.bookmark : Icons.bookmark_outline,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 2.0),

                  //ToDO implement share

                  // IconButton(
                  //   splashRadius: 20.0,
                  //   onPressed: () => widget.onShare(widget.quote),
                  //   icon: const Icon(
                  //     Icons.share,
                  //     color: Colors.white,
                  //   ),
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
