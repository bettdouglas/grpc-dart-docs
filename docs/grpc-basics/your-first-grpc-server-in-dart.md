---
sidebar_position: 1
---

# Your First gRPC server

In this guide, we aim to create our first gRPC server that will enable us to: 

- List all African hospitals.
- Filter hospitals by name.
- Find the nearest-n hospitals to some LatLng.
- Filter hospitals by country e.g All hospitals in Kenya, Uganda.

We'll also deploy the server to Google Cloud Run and get a free HTTPS server

## Protobuf service definition.

In gRPC, we communicate through sending messages. Unlike REST where we send `JSON` data, here we define a contract through which the client and the server will communicate with. in gRPC, we use protobuf language to define our API contract.

### Protobuf Messages

Create a file at `src/protoc/hospitals.proto`:

```protobuf title="src/protoc/hospitals.proto"
syntax = "proto3";

package hospitals;

message Hospital {
  string id = 1;
  string name = 2;
  string type = 3;
  string ownership = 4;
  LatLng latLng = 5;
}

message LatLng {
  float latitude = 1;
  float longitude = 2;
}
```

In our `hospitals` example, we're defining that the `LatLng` message will contain two fields, `latitude` and `longitude`. The `Hospital` message will contain attributes like `id`, `name`, `type`, `ownership` and `LatLng`.


In protobuf, we model messages the same way we model Classes in Object Oriented Programming. We use other messages to build messages. If you need to understand this better, please have a look at [Protocol Buffers documentation](https://developers.google.com/protocol-buffers/docs/overview).

After defining our messages, we need to create a service which defines what methods the server will implement which means what methods the client can call. 

We use the syntax 
```protobuf
service ServiceName {
  rpc MethodName (RequestMessage) returns (ResponseMessage);
}

message RequestMessage {
  // message attributes go here
}

message ResponseMessage {
  // message attributes go here
}
```

The method name represents the name of the method. The `RequestMessage` and `ResponseMessage` are messages. So the client will send a `RequestMessage` and get a `ResponseMessage` should the call be successful. 

In the case of hospitals, we want to implement three methods
```protobuf title="src/protoc/hospitals.proto"
syntax = "proto3";

package hospitals;

service HospitalService {
  // Lists all hospitals
  rpc ListHospitals (ListHospitalsRequest) returns (ListHospitalsResponse);
  // Gets a single hospital by id
  rpc GetHospital (GetHospitalRequest) returns (Hospital);
  // Filter hospitals by country or name
  rpc SearchHospitals (SearchHospitalsRequest) returns (SearchHospitalsResponse);
}

message ListHospitalsRequest {}

message ListHospitalsResponse {
  repeated Hospital hospitals = 1;
}

message GetHospitalRequest {
  string id = 1;
}

message SearchHospitalsRequest {
  string country = 1;
  string name = 2;
}

message SearchHospitalsResponse {
  repeated Hospital hospitals = 1;
}

message Hospital {
  string id = 1;
  string name = 2;
  string type = 3;
  string ownership = 4;
  LatLng latLng = 5;
}

message LatLng {
  float latitude = 1;
  float longitude = 2;
}
```


As you can see, we now have a defined service contract which can handle:
- Listing all hospitals.
- Getting a hospital by id.
- Listing hospitals in a specific country. 
- Search hospitals by name.

### Generate Server & Client Stubs 

Define the protobuf contract above in a file called `protos/hospitals.proto`. 

Once you've done that we'll need to run the code generator `protoc` to generate the server and client stubs. `protoc` will generate an abstract class with the methods `ListHospitals`, `GetHospital` & `SearchHospitals`. 

```bash title="protoc_gen.sh"

# Create generated directory where our generated code will be
mkdir -p lib/src/generated/

# Run protoc to generate the client & server stubs
protoc --dart_out=grpc:lib/src/generated -Iprotos hospitals.proto
```

As you can see in the method below, `protoc` generated dart classes & methods that correspond to the messages structure in the `HospitalService` protocol buffer contract.

It's our job to implement the logic of the specified methods. You'll notice that the return type of the methods correspond to the message names we defined in the protobuf contract. This is what we need to implement. 

```dart title="src/hospital_service_impl.dart"
import 'package:grpc/grpc.dart';

import 'generated/index.dart';

class HospitalService extends HospitalServiceBase {
  @override
  Future<Hospital> getHospital(
    ServiceCall call,
    GetHospitalRequest request,
  ) {
    // TODO: implement getHospital
    throw UnimplementedError();
  }

  @override
  Future<ListHospitalsResponse> listHospitals(
    ServiceCall call,
    ListHospitalsRequest request,
  ) {
    // TODO: implement listHospitals
    throw UnimplementedError();
  }

  @override
  Future<SearchHospitalsResponse> searchHospitals(
    ServiceCall call,
    SearchHospitalsRequest request,
  ) {
    // TODO: implement searchHospitals
    throw UnimplementedError();
  }
}

```

### Hospitals Data Source
We're going to use publicly available data for our implementation of hospitals. I cannot remember where I sourced the data from but we have a csv database with hospitals. We're going to extract the country, name, type, ownership, LatLng and id and use this for our gRPC server implementation. It contains 96,395 hospitals. Let's see if it's going to be trouble to handle such data. 

```csv title="data/hospitals.csv"
Country,Facility name,Facility type,Ownership,Lat,Long,LL source,uuid
Angola,Hospital Barra Do Dande,Hospital,Govt.,-8.656,13.4919,Google Earth,58281511-980f-40f3-a391-f55fa3c685c8
Angola,Hospital Dos Dembos,Hospital,Govt.,-8.5026,14.5862,Google Earth,81d3e647-ca75-48b7-80e0-9926c9150360
...
```
Let's create a function to read the data from csv and convert it to a list of `Hospital` objects. 

```dart
import 'dart:io';

import 'package:fast_csv/fast_csv.dart' as fast_csv;

import 'package:hospitals/src/generated/index.dart';

Future<List<Hospital>> readHospitals() async {
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
```

### Hospitals Repository
Let's create a hospitals repository which will handle the tasks of gettingAllHospitals, filtering hospitals and getting a hospital by id.

```dart title="lib/src/hospital_repository.dart"
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

```
With our repository in place, we'll now head over and implement our service. We'll use dependency injection and inject the HospitalRepository into the `HospitalService`.

### GetHospital method

The `GetHospital` rpc method takes a `GetHospitalRequest` as request, and expects a `Hospital` object as a response. 
The `ServiceCall` object passed by the `getHospital` method in the generated `HospitalServiceBase` allows us to access request attributes like `headers`, `metadata` and many more. 

```dart title="src/hospital_service_impl.dart"
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
}

```
### ListHospitals method
The `ListHospitals` method takes a `ListHospitalRequest` message and returns `ListHospitalsResponse` message as the response. We'll just call the repository method to get all hospitals and return a `ListHospitalsResponse` with the hospitals we got from the repository. 

```dart title="src/hospital_service_impl.dart"
  @override
  Future<ListHospitalsResponse> listHospitals(
    ServiceCall call,
    ListHospitalsRequest request,
  ) async {
    return ListHospitalsResponse(
      hospitals: await hospitalRepository.getAllHospitals(),
    );
  }
```

### SearchHospitals
The `SearchHospitals` method takes a `SearchHospitalsRequest` message and returns `SearchHospitalsResponse` message as the response. 

```protobuf title="protos/hospitals.proto"
message SearchHospitalsRequest {
  string country = 1;
  string name = 2;
}
```
As you can see, there can be two filters which can be specified by a request. The trick with gRPC and protocol buffers is that it is doesn't support for `null` values. This means when gRPC serializes the `SearchHospitalsRequest` message from binary to dart code or any other language, the default value for country when not specified by the client is an empty string, `''`. Same as for the name. If the value was an integer, if the value is not specified, it defaults to `zero`. See [default values for common protobuf field types](https://developers.google.com/protocol-buffers/docs/proto#optional).

We can anyway use the generated helper functions to check whether the client has specific fields set. For all fields we define in a message, for instance country and name, we'll get generated methods to check whether the fields we're specified. Then we can transform the request values to nullables and handle our request well. 

```dart title="src/hospital_service_impl.dart"

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

  ```

## Serving the service

Since our `HospitalService` class has implemented the three methods needed by the `HospitalServiceBase`, we can now serve our service so that clients can connect to it. Also if you don't implement a specific method, gRPC dart will return `GrpcError.unimplemented` as an error when the client invokes the unimplemented method. 

The last part is really simple. Here we add the `HospitalService` to a server which expects a list of services. 

Here we'll 
1. Read the hospitals from csv.
2. Create an instance of the HospitalService.
3. Add HospitalService to the server.
4. Start the server on specified host.

```dart title="bin/hospital_server.dart"

void main(List<String> arguments) async {
  // we read the list of hospitals from csv
  final hospitals = await readHospitalsFromCsv();

  // Create instance of the repository
  final hospitalRepository = HospitalRepository(hospitals: hospitals);

  // Create an instance of HospitalService
  final hospitalService = HospitalService(
    hospitalRepository: hospitalRepository,
  );

  // Add the service to the server
  final server = Server([hospitalService]);

  // Start the server running on port 8080
  final address = InternetAddress.anyIPv4;
  final portEnvVariable = Platform.environment['PORT'];
  if (portEnvVariable == null) {
    throw Exception('PORT environment variable not defined');
  }
  final port = int.parse(portEnvVariable);
  await server.serve(address: address, port: port);
  print('Server running on $address on port $port');
}

```

Once you run `dart bin/hospitals_server.dart`, you should see `Server running on InternetAddress('0.0.0.0', IPv4) on port 8080` message in your console. 
This means clients can now connect to port 8080 and seeL traffic. 

## Connecting to the server
The generated client code allows us to connect to the server. The server handles serialization of the messages to binary. Since binary is human unreadable, we'll need to use the generated client code which will deserialize from binary to Plain Dart Objects.

### Client Channel
When connecting to any server, we always need to know where it is on the internet(IP Address) and on what port it's serving/accepting traffic on. The `ClientChannel` object is what we use to define the channel where the communication will be happening on. To create a channel, the essentials we need to define are 
  - port where traffic is being served on.
  - address where the server is hosted.
  - `ChannelOptions`. This is used to configure security, whether TLS/plain http, timeouts etc.

The generated client stubs are what you use to communicate with the server.Every service generated client need an instance of a `ClientChannel`. That's what we'll create for now. 
```dart title="test/hospital_service_test.dart"
  final channel = ClientChannel(
    0.0.0.0, // host address. this will point to localhost for now
    port: 8080,
    options: ChannelOptions(
      credentials: ChannelCredentials.insecure(), // this means we're sending unsecured http traffic.
    ),
  );
  final hospitalServiceClient = HospitalServiceClient(channel);
```

### Calling the rpc methods
Once we've created an instance of a `hospitalClientStub`, this generated class will contain methods that we defined in the protobuf contract. Let's call the various methods so that you can see this come into play. 

#### GetHospital method
```dart title="test/hospital_service_test.dart"
  test('can get hospital', () async {
    final hospital = await hospitalServiceClient.getHospital(
      GetHospitalRequest(id: '58281511-980f-40f3-a391-f55fa3c685c8'),
    );
    expect(hospital, isA<Hospital>());
    print(hospital);
  });
```

#### ListHospitals method

The hospitals contained in the dataset are 96,395. We're just making a check that the length is as we expected. 

```dart title="test/hospital_service_test.dart"
test('returns List with 96,395 hospitals', () async {
  final response = await hospitalServiceClient.listHospitals(
    ListHospitalsRequest(),
  );
  expect(response.hospitals, hasLength(96395));
});
```

#### SearchHospitals method

Let's search for `Bula Matadi Health Centre`. This is a hospital in Angola. 

```dart title="test/hospital_service_test.dart"
test('returns hospitals with the specified names', () async {
  final response = await hospitalServiceClient.searchHospitals(
    SearchHospitalsRequest(name: 'Bula Matadi Health Centre'),
  );
  expect(response.hospitals, hasLength(1));
});
```