import 'package:hospitals/src/generated/index.dart';
import 'package:hospitals/src/hospital_repository.dart';
import 'package:test/test.dart';

void main() {
  test('readHospitalsFromCsv', () async {
    final res = await readHospitalsFromCsv();

    expect(res, isNotEmpty);
    expect(
      res.first,
      // equals(
      //   'Country,Facility name,Facility type,Ownership,Lat,Long,LL source,uuid'
      //       .split(','),
      // ),
      Hospital(
        country: 'Angola',
        name: 'Hospital Barra Do Dande',
        type: 'Hospital',
        ownership: 'Govt.',
        latLng: LatLng(
          latitude: -8.656,
          longitude: 13.4919,
        ),
        id: '58281511-980f-40f3-a391-f55fa3c685c8',
      ),
    );
  });

  group('HospitalRepository', () {
    final existingId = '58281511-980f-40f3-a391-f55fa3c685c8';

    late HospitalRepository hospitalRepository;

    setUpAll(() async {
      final hospitals = await readHospitalsFromCsv().then(
        (value) => value.take(10).toList(),
      );
      hospitalRepository = HospitalRepository(hospitals: hospitals);
    });
    test('getAllHospitals', () async {
      final got = await hospitalRepository.getAllHospitals();
      expect(got.length, equals(10));
    });

    test('searchHospitals', () async {
      var got = await hospitalRepository.searchHospitals(
        name: 'Barra Do Dand',
        country: 'Angola',
      );
      expect(got, hasLength(1));
      got = await hospitalRepository.searchHospitals(
        name: 'Bula Matadi Health Centre',
        country: 'Kenya',
      );
      expect(got, isEmpty);
    });
    test('getHospital returns null if not found', () async {
      final got = await hospitalRepository.getHospital(
        '$existingId nnnnnnnn',
      );
      expect(got, isNull);
    });
    test('getHospital returns hospital if found', () async {
      final got = await hospitalRepository.getHospital(
        existingId,
      );
      expect(got, isNotNull);
    });
  });
}
