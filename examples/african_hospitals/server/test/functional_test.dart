import 'package:fpdart/fpdart.dart';
import 'package:grpc/grpc.dart';
import 'package:hospitals/src/generated/index.dart';
import 'package:hospitals/src/hospital_repository.dart';

Future<Either<Exception, Hospital>> getHospital(
  ServiceCall serviceCall,
  GetHospitalRequest request,
  HospitalRepository hospitalRepository,
) async {
  throw UnimplementedError();
}
