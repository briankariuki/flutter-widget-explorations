import 'package:flutter/material.dart';

class DisplayLarge extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final int? maxLines;
  final double? letterSpacing;

  const DisplayLarge({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.61,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w700,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: Theme.of(context).textTheme.displayLarge!.copyWith(
            height: lineHeight,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
          ),
    );
  }
}

class DisplayMedium extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;

  final FontStyle fontStyle;
  final int? maxLines;
  final double? letterSpacing;

  const DisplayMedium({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.61,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w700,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
            height: lineHeight,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
          ),
    );
  }
}

class DisplaySmall extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;

  final FontStyle fontStyle;
  final int? maxLines;
  final double? letterSpacing;

  const DisplaySmall({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.61,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w700,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: Theme.of(context).textTheme.displaySmall!.copyWith(
            height: lineHeight,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
          ),
    );
  }
}

class HeadlineMedium extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;

  final FontStyle fontStyle;
  final int? maxLines;
  final double? letterSpacing;

  const HeadlineMedium({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.61,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w700,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            height: lineHeight,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
          ),
    );
  }
}

class HeadlineSmall extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;

  final FontStyle fontStyle;
  final int? maxLines;
  final double? letterSpacing;

  const HeadlineSmall({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.61,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w700,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            height: lineHeight,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
          ),
    );
  }
}

class TitleLarge extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;

  final FontStyle fontStyle;
  final int? maxLines;
  final double? letterSpacing;

  const TitleLarge({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.61,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w700,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            height: lineHeight,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
          ),
    );
  }
}

class BodyLarge extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;

  final int? maxLines;
  final double? letterSpacing;

  const BodyLarge({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.57,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w500,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            height: lineHeight,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
          ),
    );
  }
}

class BodyMedium extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;

  final FontStyle fontStyle;
  final int? maxLines;
  final double? letterSpacing;

  const BodyMedium({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.57,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w500,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            height: lineHeight,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
          ),
    );
  }
}

class TitleMedium extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;

  final FontStyle fontStyle;
  final int? maxLines;
  final double? letterSpacing;

  const TitleMedium({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.57,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w500,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            height: lineHeight,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
          ),
    );
  }
}

class TitleSmall extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;

  final FontStyle fontStyle;
  final int? maxLines;
  final double? letterSpacing;

  const TitleSmall({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.57,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w500,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            height: lineHeight,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
          ),
    );
  }
}

class BodySmall extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;

  final FontStyle fontStyle;
  final int? maxLines;

  final double? letterSpacing;

  const BodySmall({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.83,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w600,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            height: lineHeight,
            fontWeight: fontWeight,
            color: color,
            fontFamily: fontFamily,
            letterSpacing: letterSpacing,
            fontStyle: fontStyle,
          ),
    );
  }
}

class Small extends StatelessWidget {
  final String title;
  final Color color;
  final double lineHeight;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final String fontFamily;
  final FontWeight fontWeight;

  final FontStyle fontStyle;
  final double fontSize;
  final int? maxLines;
  final double? letterSpacing;

  const Small({
    Key? key,
    required this.title,
    required this.color,
    this.lineHeight = 1.83,
    this.overflow = TextOverflow.visible,
    this.textAlign = TextAlign.left,
    this.fontFamily = 'Inter',
    this.fontWeight = FontWeight.w600,
    this.fontSize = 11.0,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
        height: lineHeight,
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
        fontFamily: fontFamily,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      ),
    );
  }
}

class SmallBold extends StatelessWidget {
  final String title;
  final Color color;
  final double? letterSpacing;

  const SmallBold({
    Key? key,
    required this.title,
    required this.color,
    this.letterSpacing,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.visible,
      style: TextStyle(
        fontSize: 12,
        color: color,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
