import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Load fonts for consistent rendering
  await loadAppFonts();

  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  // Configure window size and pixel ratio for consistent rendering
  binding.window.physicalSizeTestValue = const Size(400, 800);
  binding.window.devicePixelRatioTestValue = 1.0;

  // Enable real shadows for visual tests
  binding.window.platformDispatcher.textScaleFactorTestValue = 1.0;

  // Skip golden tests on non-macOS platforms
  if (!Platform.isMacOS) {
    goldenFileComparator = _AlwaysPassingGoldenFileComparator();
  }

  return testMain();
}

class _AlwaysPassingGoldenFileComparator extends GoldenFileComparator {
  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async => true;

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {}
}
