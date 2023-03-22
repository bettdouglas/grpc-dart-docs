part of 'list_hospitals_bloc.dart';

@freezed
class ListHospitalsState with _$ListHospitalsState {
  const factory ListHospitalsState.initial() = _Initial;
  const factory ListHospitalsState.loading(String message) = _Loading;
  const factory ListHospitalsState.loaded({
    required List<Hospital> hospitals,
  }) = _Loaded;
  const factory ListHospitalsState.failure({
    required String error,
    StackTrace? stackTrace,
  }) = _Failure;
}
