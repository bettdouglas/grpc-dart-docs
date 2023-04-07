import 'package:flutter/material.dart';
import 'package:african_hospitals_riverpod_client/list_hospitals/widgets/list_hospitals_body.dart';

/// {@template list_hospitals_page}
/// A description for ListHospitalsPage
/// {@endtemplate}
class ListHospitalsPage extends StatelessWidget {
  /// {@macro list_hospitals_page}
  const ListHospitalsPage({super.key});

  /// The static route for ListHospitalsPage
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(builder: (_) => const ListHospitalsPage());
  }
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ListHospitalsView(),
    );
  }  
}

/// {@template list_hospitals_view}
/// Displays the Body of ListHospitalsView
/// {@endtemplate}
class ListHospitalsView extends StatelessWidget {
  /// {@macro list_hospitals_view}
  const ListHospitalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListHospitalsBody();
  }
}
