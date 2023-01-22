// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_integration_record/flutter_integration_record.dart';
import 'package:flutter_integration_record/src/widgets/flutter_integration_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlutterIntegrationRecord', () {
    test('can be instantiated', () {
      expect(FlutterIntegrationRecord(child: Container()), isNotNull);
    });
  });
}
