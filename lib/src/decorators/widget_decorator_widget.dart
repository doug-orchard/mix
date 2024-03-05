import 'package:flutter/material.dart';

import '../core/attributes_map.dart';
import '../core/decorator.dart';
import '../factory/mix_provider_data.dart';
import 'align_widget_decorator.dart';
import 'aspect_ratio_widget_decorator.dart';
import 'clip_widget_decorator.dart';
import 'fractionally_sized_box_widget_decorator.dart';
import 'intrinsic_widget_decorator.dart';
import 'opacity_widget_decorator.dart';
import 'scale_widget_decorator.dart';
import 'sized_box_widget_decorator.dart';
import 'transform_widget_decorator.dart';
import 'visibility_widget_decorator.dart';

// Default order of decorators and their logic:
const _defaultOrder = [
  // 1. VisibilityDecorator: Controls overall visibility. If the widget is set to be invisible,
  // none of the subsequent decorations are processed, providing an early exit and optimizing performance.
  VisibilityDecoratorAttribute,

  // 2. SizedBoxDecorator: Explicitly sets the size of the widget before any other transformations are applied.
  // This ensures that the widget occupies a predetermined space, which is crucial for layouts that require exact dimensions.
  SizedBoxDecoratorAttribute,

  // 3. FractionallySizedBoxDecorator: Adjusts the widget's size relative to its parent's size,
  // allowing for responsive layouts that scale with the parent widget. This decorator is applied after
  // explicit sizing to refine the widget's dimensions based on available space.
  FractionallySizedBoxDecoratorAttribute,

  // 4. AlignDecorator: Aligns the widget within its allocated space, which is especially important
  // for positioning the widget correctly before applying any transformations that could affect its position.
  // Alignment is based on the size constraints established by previous decorators.
  AlignDecoratorAttribute,

  // 5. IntrinsicHeightDecorator: Adjusts the widget's height to fit its child's intrinsic height,
  // ensuring that the widget does not force its children to conform to an unnatural height. This is particularly
  // useful for widgets that should size themselves based on content.
  IntrinsicHeightDecoratorAttribute,

  // 6. IntrinsicWidthDecorator: Similar to the IntrinsicHeightDecorator, this adjusts the widget's width
  // to its child's intrinsic width. This decorator allows for content-driven width adjustments, making it ideal
  // for widgets that need to wrap their content tightly.
  IntrinsicWidthDecoratorAttribute,

  // 7. AspectRatioDecorator: Maintains the widget's aspect ratio after sizing adjustments.
  // This decorator ensures that the widget scales correctly within its given aspect ratio constraints,
  // which is critical for preserving the visual integrity of images and other aspect-sensitive content.
  AspectRatioDecoratorAttribute,

  // 8. ScaleDecorator: Scales the widget according to a given scale factor. This decorator is applied after
  // the aspect ratio is considered to ensure the widget scales uniformly, affecting its overall size and maintaining
  // the aspect ratio integrity.
  ScaleDecoratorAttribute,

  // 9. TransformDecorator: Applies arbitrary transformations, such as rotation, scaling, and translation.
  // Transformations are applied after all sizing and positioning adjustments to modify the widget's appearance
  // and position in more complex ways without altering the logical layout.
  TransformDecoratorAttribute,

  // 10. Clip Decorators: Applies clipping in various shapes to the transformed widget, shaping the final appearance.
  // Clipping is one of the last steps to ensure it is applied to the widget's final size, position, and transformation state.
  ClipOvalDecoratorAttribute,
  ClipRRectDecoratorAttribute,
  ClipPathDecoratorAttribute,
  ClipTriangleDecoratorAttribute,
  ClipRectDecoratorAttribute,

  // 11. OpacityDecorator: Modifies the widget's opacity as the final decoration step. Applying opacity last ensures
  // that it does not influence the layout or transformations, serving purely as a visual effect to alter the transparency
  // of the widget and its decorations.
  OpacityDecoratorAttribute,
];

class RenderDecoratorAttributes extends StatelessWidget {
  const RenderDecoratorAttributes({
    required this.mix,
    required this.child,
    super.key,
    this.orderOfDecorators = const [],
  });

  final MixData mix;
  final Widget child;
  final List<Type> orderOfDecorators;

  @override
  Widget build(BuildContext context) {
    final decorators = mix.whereType<DecoratorAttribute>();

    return _decorateWidgetWithSpecs(child, decorators, orderOfDecorators, mix);
  }
}

List<DecoratorSpec> _resolveDecoratorSpecs(
  Iterable<DecoratorAttribute> decorators,
  List<Type> orderOfDecorators,
  MixData mix,
) {
  final decoratorMap = AttributeMap<DecoratorAttribute>(decorators).toMap();

  final listOfDecorators = {
    ...orderOfDecorators,
    ..._defaultOrder,
    ...decoratorMap.keys,
  }.toList().reversed;

  final specs = <DecoratorSpec>[];

  for (final decoratorType in listOfDecorators) {
    final decorator = decoratorMap.remove(decoratorType);
    if (decorator == null) continue;
    specs.add(decorator.resolve(mix) as DecoratorSpec);
  }

  return specs;
}

Widget _decorateWidgetWithSpecs(
  Widget child,
  Iterable<DecoratorAttribute> decorators,
  List<Type> orderOfDecorators,
  MixData mix,
) {
  var current = child;

  if (decorators.isEmpty) return child;

  final specs = _resolveDecoratorSpecs(decorators, orderOfDecorators, mix);

  for (final spec in specs) {
    current = spec.build(current);
  }

  return current;
}
