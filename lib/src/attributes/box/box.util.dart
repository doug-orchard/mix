import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/attributes/box/box.attributes.dart';

class BoxUtility {
  const BoxUtility();

  /// Rotate property
  BoxAttributes rotate(int value) => BoxAttributes(rotate: value);

  /// Margin property
  BoxAttributes margin(EdgeInsets insets) => BoxAttributes(margin: insets);

  /// Padding property
  BoxAttributes padding(EdgeInsets insets) => BoxAttributes(padding: insets);

  /// Opacity
  BoxAttributes opacity(double value) => BoxAttributes(opacity: value);

  /// Aspect Ratio
  BoxAttributes aspectRatio(double value) => BoxAttributes(aspectRatio: value);

  /// Background color attribute
  BoxAttributes backgroundColor(Color color) =>
      BoxAttributes(backgroundColor: color);

  /// Height
  BoxAttributes height(double height) => BoxAttributes(height: height);

  /// Width
  BoxAttributes width(double width) => BoxAttributes(width: width);

  /// Max height attribute
  BoxAttributes maxHeight(double maxHeight) =>
      BoxAttributes(maxHeight: maxHeight);

  /// Max width attribute
  BoxAttributes maxWidth(double maxWidth) => BoxAttributes(maxWidth: maxWidth);

  /// Min height attribute
  BoxAttributes minHeight(double minHeight) =>
      BoxAttributes(minHeight: minHeight);

  /// Min width attribute
  BoxAttributes minWidth(double minWidth) => BoxAttributes(minWidth: minWidth);

  Radius _circular(double? value) => Radius.circular(value ?? 0.0);

  /// Border radius
  BoxAttributes borderRadius(BorderRadius radius) =>
      BoxAttributes(borderRadius: radius);

  /// Rounded border radius
  BoxAttributes rounded(double value) =>
      borderRadius(BorderRadius.all(_circular(value)));

  BoxAttributes roundedOnly({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    return borderRadius(
      BorderRadius.only(
        topLeft: _circular(topLeft),
        topRight: _circular(topRight),
        bottomLeft: _circular(bottomLeft),
        bottomRight: _circular(bottomRight),
      ),
    );
  }

  /// Flex
  BoxAttributes flex(int value) => BoxAttributes(flex: value);

  /// FlexFit
  BoxAttributes flexFit(FlexFit value) => BoxAttributes(flexFit: value);

  /// Expanded
  BoxAttributes expanded() => const BoxAttributes(flexFit: FlexFit.tight);

  /// Flexible
  BoxAttributes flexible() => const BoxAttributes(flexFit: FlexFit.loose);

  /// Border color for all borde sides
  BoxAttributes borderColor(Color color) =>
      BoxAttributes(border: Border.all(color: color));

  /// Border width for all border sides
  BoxAttributes borderWidth(double width) =>
      BoxAttributes(border: Border.all(width: width));

  /// Border style for all border sides
  BoxAttributes borderStyle(BorderStyle style) {
    return BoxAttributes(border: Border.all(style: style));
  }

  BoxAttributes shadow({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
  }) {
    const boxShadow = BoxShadow();

    return BoxAttributes(
      boxShadow: boxShadow.copyWith(
        color: color,
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    );
  }

  /// Hidden property
  BoxAttributes hidden([bool? condition = true]) =>
      BoxAttributes(hidden: condition);
}
