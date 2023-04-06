import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:grpc/grpc.dart';

part 'get_hospital_event.dart';
part 'get_hospital_state.dart';
part 'get_hospital_bloc.freezed.dart';

class GetHospitalBloc extends Bloc<GetHospitalEvent, GetHospitalState> {
  GetHospitalBloc({
    required this.hospitalServiceClient,
  }) : super(const GetHospitalState.initial()) {
    on<GetHospitalEvent>((event, emit) async {
      await event.when(started: (hospitalId) async {
        try {
          emit(GetHospitalState.loading('Getting hospital: $hospitalId'));
          final response = await hospitalServiceClient.getHospital(
            GetHospitalRequest(
              id: hospitalId,
            ),
          );
          emit(GetHospitalState.loaded(hospital: response));
        } on GrpcError catch (e, st) {
          if (e.code == StatusCode.notFound) {
            emit(
              GetHospitalState.notFound(
                message: 'Hospital with id: $hospitalId not found',
              ),
            );
          } else {
            emit(
              GetHospitalState.failure(
                error: e.toString(),
                stackTrace: st,
              ),
            );
          }
        }
      });
    });
  }

  final HospitalServiceClient hospitalServiceClient;
}
