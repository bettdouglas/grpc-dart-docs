// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:african_hospitals_riverpod_client/list_hospitals/list_hospitals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListHospitalsPage', () {
    group('route', () {
      test('is routable', () {
        expect(ListHospitalsPage.route(), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders ListHospitalsView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: ListHospitalsPage()));
      expect(find.byType(ListHospitalsView), findsOneWidget);
    });
  });
}
