import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText(
    String this.data, {
    Key? key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor = 1,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
  })  : textSpan = null,
        super(key: key);

  const AppText.rich(
    this.textSpan, {
    Key? key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
  })  : data = null,
        super(key: key);

  final String? data;

  final InlineSpan? textSpan;

  final TextStyle? style;

  final StrutStyle? strutStyle;

  final TextAlign? textAlign;

  final TextDirection? textDirection;

  final Locale? locale;

  final bool? softWrap;

  final TextOverflow? overflow;

  final double? textScaleFactor;

  final int? maxLines;

  final String? semanticsLabel;

  final TextWidthBasis? textWidthBasis;

  final TextHeightBehavior? textHeightBehavior;

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = style;
    if (style == null || style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(style);
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle!
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    final textAlign =
        this.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    final softWrap = this.softWrap ?? defaultTextStyle.softWrap;
    final overflow = this.overflow ??
        effectiveTextStyle?.overflow ??
        defaultTextStyle.overflow;
    final maxLines = this.maxLines ?? defaultTextStyle.maxLines;
    final textScaler = TextScaler.linear(
        textScaleFactor ?? MediaQuery.textScaleFactorOf(context));
    final textWidthBasis =
        this.textWidthBasis ?? defaultTextStyle.textWidthBasis;
    final textHeightBehavior =
        this.textHeightBehavior ?? defaultTextStyle.textHeightBehavior;

    Widget result = textSpan != null
        ? RichText(
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaler: textScaler,
            maxLines: maxLines,
            strutStyle: strutStyle,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
            text: TextSpan(
              style: effectiveTextStyle,
              text: data ?? '',
              children: textSpan != null ? <InlineSpan>[textSpan!] : null,
            ),
          )
        : Text(
            data ?? '',
            textAlign: textAlign,
            textDirection: textDirection,
            locale: locale,
            softWrap: softWrap,
            overflow: overflow,
            textScaler: textScaler,
            maxLines: maxLines,
            strutStyle: strutStyle,
            textWidthBasis: textWidthBasis,
            textHeightBehavior: textHeightBehavior,
            style: effectiveTextStyle,
          );
    if (semanticsLabel != null) {
      result = Semantics(
        textDirection: textDirection,
        label: semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }
    return result;
  }
}
