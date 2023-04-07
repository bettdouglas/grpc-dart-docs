// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:african_hospitals_riverpod_client/list_hospitals/list_hospitals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListHospitalsBody', () {
    testWidgets('renders Text', (tester) async { 
      await tester.pumpWidget(
        MaterialApp(home: ListHospitalsBody()),
      );

      expect(find.byType(Text), findsOneWidget);
    });
  });
}
