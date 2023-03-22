part of 'list_hospitals_bloc.dart';

@freezed
class ListHospitalsEvent with _$ListHospitalsEvent {
  const factory ListHospitalsEvent.started() = _Started;
}
