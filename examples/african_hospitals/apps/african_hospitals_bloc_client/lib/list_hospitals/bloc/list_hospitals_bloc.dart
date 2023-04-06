import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';

part 'list_hospitals_event.dart';
part 'list_hospitals_state.dart';
part 'list_hospitals_bloc.freezed.dart';

class ListHospitalsBloc extends Bloc<ListHospitalsEvent, ListHospitalsState> {
  final HospitalServiceClient hospitalServiceClient;

  ListHospitalsBloc({
    required this.hospitalServiceClient,
  }) : super(const ListHospitalsState.initial()) {
    on<ListHospitalsEvent>((event, emit) async {
      await event.when(
        started: () async {
          try {
            emit(
              const ListHospitalsState.loading('Fetching list of hospitals'),
            );
            // Send the request to the server
            final response = await hospitalServiceClient.listHospitals(
              ListHospitalsRequest(),
            );
            final hospitals = response.hospitals;
            emit(ListHospitalsState.loaded(hospitals: hospitals));
          } on GrpcError catch (e, st) {
            emit(
              ListHospitalsState.failure(error: e.toString(), stackTrace: st),
            );
          }
        },
      );
    });
  }
}
