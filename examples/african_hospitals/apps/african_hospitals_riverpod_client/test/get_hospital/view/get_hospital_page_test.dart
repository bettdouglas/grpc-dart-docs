// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:african_hospitals_riverpod_client/get_hospital/get_hospital.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GetHospitalPage', () {
    group('route', () {
      test('is routable', () {
        expect(GetHospitalPage.route(id: 'na'), isA<MaterialPageRoute>());
      });
    });

    testWidgets('renders GetHospitalView', (tester) async {
      await tester.pumpWidget(MaterialApp(home: GetHospitalPage(id: 'na')));
      expect(find.byType(GetHospitalView), findsOneWidget);
    });
  });
}
