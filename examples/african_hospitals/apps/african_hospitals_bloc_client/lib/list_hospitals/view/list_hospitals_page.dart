import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../list_hospitals.dart';

class ListHospitalsPage extends StatelessWidget {
  const ListHospitalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ListHospitalsBloc(),
      child: const ListHospitalsView(),
    );
  }
}

class ListHospitalsView extends StatelessWidget {
  const ListHospitalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListHospitalsBloc, ListHospitalsState>(
      builder: (context, state) {
        // TODO: return correct widget based on the state.
        return const SizedBox();
      },
    );
  }
}
