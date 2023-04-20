import 'package:african_hospitals_riverpod_client/get_hospital/provider/get_hospital_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// {@template get_hospital_body}
/// Body of the GetHospitalPage.
///
/// Add what it does
/// {@endtemplate}
class GetHospitalBody extends ConsumerWidget {
  /// {@macro get_hospital_body}
  const GetHospitalBody({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(getHospitalProvider(id));
    return state.when(
      data: (hospital) {
        if (hospital == null) {
          return Center(
            child: Text('Hospital $id not found'),
          );
        } else {
          return Center(child: Text(hospital.toString()));
        }
      },
      error: (error, stackTrace) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Error Getting Hospitals'),
            const SizedBox(height: 20),
            Text(error.toString()),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(getHospitalProvider(id));
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
