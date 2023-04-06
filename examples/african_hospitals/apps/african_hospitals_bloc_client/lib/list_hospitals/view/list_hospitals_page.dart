import 'package:african_hospitals_bloc_client/get_hospital/get_hospital.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../list_hospitals.dart';

class ListHospitalsPage extends StatefulWidget {
  const ListHospitalsPage({super.key});

  @override
  State<ListHospitalsPage> createState() => _ListHospitalsPageState();
}

class _ListHospitalsPageState extends State<ListHospitalsPage> {
  @override
  void initState() {
    context.read<ListHospitalsBloc>().add(const ListHospitalsEvent.started());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const ListHospitalsView();
  }
}

class ListHospitalsView extends StatelessWidget {
  const ListHospitalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListHospitalsBloc, ListHospitalsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('African Hospitals'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: state.when(
              initial: () => const SizedBox(),
              loading: (msg) => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              loaded: (hospitals) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final hospital = hospitals[index];
                    return ListTile(
                      title: Text(hospital.name),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GetHospitalPage(id: hospital.id),
                          ),
                        );
                        context
                            .read<GetHospitalBloc>()
                            .add(GetHospitalEvent.started(id: hospital.id));
                      },
                    );
                  },
                  itemCount: hospitals.length,
                );
              },
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
                            .read<ListHospitalsBloc>()
                            .add(const ListHospitalsEvent.started());
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
