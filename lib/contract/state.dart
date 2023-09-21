import 'package:flutter/material.dart';

abstract class BaseState extends ChangeNotifier {
  double? screenWidth;
  double? screenHeight;
  String? location;
  Object? extra;

  LayoutMode get layoutMode => (1.2 * (screenWidth ?? 0) > (screenHeight ?? 0))
      ? LayoutMode.landscape
      : LayoutMode.portrait;

  bool get isDesktopView => layoutMode == LayoutMode.landscape;
}

void dispose() {}

enum LayoutMode { portrait, landscape }
