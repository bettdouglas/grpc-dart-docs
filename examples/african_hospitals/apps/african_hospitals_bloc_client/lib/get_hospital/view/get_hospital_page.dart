import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../get_hospital.dart';

class GetHospitalPage extends StatelessWidget {
  const GetHospitalPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return GetHospitalView(id: id);
  }
}

class GetHospitalView extends StatelessWidget {
  const GetHospitalView({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetHospitalBloc, GetHospitalState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.maybeWhen(
                orElse: () => '',
                loaded: (hospital) => hospital.name,
                notFound: (_) => 'Hospital Not Found',
                failure: (_, __) => 'Error',
                loading: (_) => 'Loading...',
              ),
            ),
          ),
          body: state.when(
            initial: () => const Center(child: Text('Initial')),
            loading: (message) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                const SizedBox(height: 20),
                Text(message),
              ],
            ),
            loaded: (hospital) => Center(
              child: Text(hospital.toProto3Json().toString()),
            ),
            notFound: (message) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Icon(Icons.error),
                ),
                const SizedBox(height: 20),
                Text(message),
              ],
            ),
            failure: (error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error Getting Hospitals'),
                  const SizedBox(height: 20),
                  Text(error),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<GetHospitalBloc>()
                          .add(GetHospitalEvent.started(id: id));
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
