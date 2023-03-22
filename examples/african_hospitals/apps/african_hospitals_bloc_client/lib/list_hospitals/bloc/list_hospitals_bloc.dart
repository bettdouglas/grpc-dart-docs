import 'package:african_hospitals_client/african_hospitals_client.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_hospitals_event.dart';
part 'list_hospitals_state.dart';
part 'list_hospitals_bloc.freezed.dart';

class ListHospitalsBloc extends Bloc<ListHospitalsEvent, ListHospitalsState> {
  ListHospitalsBloc() : super(const ListHospitalsState.initial()) {
    on<ListHospitalsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
