import 'package:flutter/material.dart';
import 'package:african_hospitals_riverpod_client/list_hospitals/provider/provider.dart';

/// {@template list_hospitals_body}
/// Body of the ListHospitalsPage.
///
/// Add what it does
/// {@endtemplate}
class ListHospitalsBody extends ConsumerWidget {
  /// {@macro list_hospitals_body}
  const ListHospitalsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listHospitalsProvider);
    return state.when(
      data: (hospitals) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final hospital = hospitals[index];
            return ListTile(
              title: Text(hospital.name),
              onTap: () {},
            );
          },
          itemCount: hospitals.length,
        );
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
                ref.invalidate(listHospitalsProvider);
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

class HospitalsListView extends StatelessWidget {
  const HospitalsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
