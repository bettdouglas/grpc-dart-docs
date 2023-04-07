import 'package:flutter/material.dart';
import 'package:african_hospitals_riverpod_client/get_hospital/widgets/get_hospital_body.dart';

/// {@template get_hospital_page}
/// A description for GetHospitalPage
/// {@endtemplate}
class GetHospitalPage extends StatelessWidget {
  /// {@macro get_hospital_page}
  const GetHospitalPage({
    super.key,
    required this.id,
  });

  final String id;

  /// The static route for GetHospitalPage
  static Route<dynamic> route({required String id}) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => GetHospitalPage(id: id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetHospitalView(
        id: id,
      ),
    );
  }
}

/// {@template get_hospital_view}
/// Displays the Body of GetHospitalView
/// {@endtemplate}
class GetHospitalView extends StatelessWidget {
  /// {@macro get_hospital_view}
  const GetHospitalView({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return GetHospitalBody(id: id);
  }
}
