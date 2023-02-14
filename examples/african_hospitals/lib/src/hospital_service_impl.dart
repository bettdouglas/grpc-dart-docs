// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:grpc/grpc.dart';

import 'package:hospitals/src/hospital_repository.dart';

import 'generated/index.dart';

class HospitalService extends HospitalServiceBase {
  final HospitalRepository hospitalRepository;
  HospitalService({
    required this.hospitalRepository,
  });

  @override
  Future<Hospital> getHospital(
    ServiceCall call,
    GetHospitalRequest request,
  ) async {
    final id = request.id;
    final hospital = await hospitalRepository.getHospital(request.id);
    if (hospital == null) {
      throw GrpcError.notFound('Hospital with id: $id not found');
    }
    return hospital;
  }

  @override
  Future<ListHospitalsResponse> listHospitals(
    ServiceCall call,
    ListHospitalsRequest request,
  ) async {
    return ListHospitalsResponse(
      hospitals: await hospitalRepository.getAllHospitals(),
    );
  }

  @override
  Future<SearchHospitalsResponse> searchHospitals(
    ServiceCall call,
    SearchHospitalsRequest request,
  ) async {
    String? name;
    String? country;

    if (request.hasName()) {
      name = request.name;
    }
    if (request.hasCountry()) {
      country = request.country;
    }

    return SearchHospitalsResponse(
      hospitals: await hospitalRepository.searchHospitals(
        name: name,
        country: country,
      ),
    );
  }
}
