part of 'get_hospital_bloc.dart';

@freezed
class GetHospitalState with _$GetHospitalState {
  const factory GetHospitalState.initial() = _Initial;
  const factory GetHospitalState.loading(String message) = _Loading;
  const factory GetHospitalState.loaded({
    required Hospital hospital,
  }) = _Loaded;
  const factory GetHospitalState.notFound({
    required String message,
  }) = _NotFound;
  const factory GetHospitalState.failure({
    required String error,
    StackTrace? stackTrace,
  }) = _Failure;
}
