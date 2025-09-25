import 'package:flutter/material.dart';

ColorScheme _colorScheme = ColorScheme.fromSeed(
  seedColor: Colors.black,
  brightness: Brightness.dark,
  dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
);

ThemeData theme = ThemeData(
  colorScheme: _colorScheme,
  scaffoldBackgroundColor: _colorScheme.surfaceBright,
);
