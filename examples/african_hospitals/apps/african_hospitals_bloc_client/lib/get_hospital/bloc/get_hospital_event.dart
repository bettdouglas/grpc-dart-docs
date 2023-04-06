part of 'get_hospital_bloc.dart';

@freezed
class GetHospitalEvent with _$GetHospitalEvent {
  const factory GetHospitalEvent.started({
    required String id,
  }) = _Started;
}
