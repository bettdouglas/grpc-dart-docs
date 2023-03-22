// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:fast_csv/fast_csv.dart' as fast_csv;

import 'package:hospitals/src/generated/index.dart';

Future<List<Hospital>> readHospitalsFromCsv() async {
  final hospitalsPath = 'data/hospitals.csv';
  final fileContents = await File(hospitalsPath).readAsString();
  return fast_csv
      .parse(fileContents)
      // first row in .csv mostly contains column names
      .skip(1)
      .map(
        (e) => Hospital(
          country: e[0],
          name: e[1],
          type: e[2],
          ownership: e[3],
          latLng: LatLng(
            latitude: double.parse(e[4]),
            longitude: double.parse(e[5]),
          ),
          id: e[7],
        ),
      )
      .toList();
}

class HospitalRepository {
  final List<Hospital> hospitals;
  HospitalRepository({
    required this.hospitals,
  });

  Future<List<Hospital>> getAllHospitals() async {
    return hospitals;
  }

  Future<List<Hospital>> searchHospitals({
    String? name,
    String? country,
  }) async {
    var filtered = hospitals;
    if (country != null) {
      filtered = hospitals.where((h) => h.country == country).toList();
    }

    if (name != null) {
      return filtered
          .where((h) => h.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    return filtered;
  }

  Future<Hospital?> getHospital(String id) async {
    try {
      return hospitals.firstWhere((h) => h.id == id);
    } on StateError {
      return null;
    }
  }
}
