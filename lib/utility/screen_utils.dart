import 'package:flutter/cupertino.dart';

extension SizerExtensions on num {
  double get h =>
      (MediaQueryData.fromView(WidgetsBinding.instance.window).size.height /
          852) *
          this;

  double get w =>
      (MediaQueryData.fromView(WidgetsBinding.instance.window).size.width /
          393) *
          this;

  double get x => h * w;
}
