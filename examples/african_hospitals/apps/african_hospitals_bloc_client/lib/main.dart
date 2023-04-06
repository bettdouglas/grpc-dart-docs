import 'package:african_hospitals_bloc_client/get_hospital/bloc/get_hospital_bloc.dart';
import 'package:african_hospitals_bloc_client/list_hospitals/list_hospitals.dart';
import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = AfricanHospitalsClient.client(
      host: '10.0.2.2',
      isSecure: false,
      port: 9980,
      interceptors: [],
    );
    return RepositoryProvider<HospitalServiceClient>(
      create: (context) => client,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ListHospitalsBloc(
              hospitalServiceClient: context.read<HospitalServiceClient>(),
            ),
          ),
          BlocProvider(
            create: (context) => GetHospitalBloc(
              hospitalServiceClient: context.read<HospitalServiceClient>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter gRPC Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const ListHospitalsPage(),
        ),
      ),
    );
  }
}
