# CRUD APIs with stormberry ORM.

## TODO
## What is stormberry

Stormberry is a strongly-typed postgres ORM for dart to provide easy bindings between your dart classes and postgres database. It supports all kinds of relations without any complex configuration.

It allows us to query do CRUD tasks on the postgres without us having to write SQL queries. It's a time saver in many situations and prevents some mistakes we could make as developers when writing SQL queries. 

Check it out at [pub.dev](https://pub.dev/packages/stormberry). 

In this guide,let's try implementing a bereal like app where users will upload photos. Users will be able to view all users in our database and see their photos as well. 
This will show us aspects of CRUD and work with a real database.


To install it, let's create a dart package called `server`
```bash
mkdir be-real-clone
dart create -t console server
```

It relies on code generation to generate the SQL queries we'll be sending to the database. Let's add stormberry and build_runner dependencies. 
```bash
cd server/
dart pub add stormberry
dart pub add build_runner --dev
```
### User Model
Let's say we want to model a User in the database. The user will have a unique id, a username, a phone which may be present or not and the creation date. We'll need to create an abstract class with the defined properties. 
We'll also hash the user's password with a secret key so that during login, we can check the password and return a JWT we can use to authenticate requests. 


:::tip

You can follow along yourself by cloning the repo at this [be-real-clone](https://github.com/bettdouglas/be-real-clone.git).
```bash
git clone https://github.com/bettdouglas/be-real-clone.git
cd be-real-clone
git checkout 7876f99
```
:::

```dart title=lib/database/models.dart
import 'package:stormberry/stormberry.dart';

part 'models.schema.dart';

@Model(
  tableName: 'accounts',
)
abstract class User {
  // the firebase id
  @PrimaryKey()
  String get id;

  String get username;

  String? get phone;

  DateTime get createdAt;

  String get passwordHash;
}
```
As you can see, we annotated the class with `@Model` annotation. This tells stormberry to create a model with the defined properties. 

In order to generate the database code, you can start the build_runner. This will generate a user repository which we can use to do various CRUD tasks with ease. 
```bash
dart run build_runner build
```

Once build_runner completes building, you'll need to create a postgres database so that stormberry can create the changes in our database. 
```bash
psql -U $POSTGRES_USER
```
Once in the postgres shell, let's create a database called `bereal`. 
```bash
CREATE TABLE bereal;
```
Once created, you can exit the postgres shell and now try running our migrations. 

### Migrations

To run the migrations, we'll call the stormberry dart process and supply it with the various database connection parameters. 
```bash
dart run stormberry migrate --no-ssl --db bereal --username **** --password ****** --host localhost --port 5432
```
Once it connects successfully, you should see the following created. 
```bash

Database: connecting to bereal at localhost...
Database: connected
Getting schema changes of bereal
=========================
++ TABLE accounts
=========================
Do you want to apply these changes? (yes/no): yes
Database schema changed, applying updates now:
---
CREATE TABLE IF NOT EXISTS "accounts" (
"id" text NOT NULL,"username" text NOT NULL,"phone" text NULL,"created_at" timestamp NOT NULL,"password_hash" text NOT NULL
)
---
ALTER TABLE "accounts"
ADD PRIMARY KEY ( "id" )
========================
---
DATABASE UPDATE SUCCESSFUL
```

With the migrations out of place, let's now connect to the database on dart and do some CRUD tasks. 
### CRUD with stormberry
We'll need to store the connection properties in an environment file for security reasons. 

We'll use the awesome (dotenv)[https://pub.dev/packages/dotenv] package to load this information from any specified environment file.
Let's install it 
```bash
dart pub add dotenv
```

Let's create a file called `.env` with the following contents and add it to .gitignore so that we don't check it into version control. 

```bash
POSTGRES_DB=bereal
POSTGRES_USER=***
POSTGRES_PASSWORD=******
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_SCHEMA=public
POSTGRES_SSL=disable
```

Now, let's go into the `bin/server.dart` and read the variables from the environment file. We'll specifically tell 
```dart
import 'package:dotenv/dotenv.dart';
import 'package:stormberry/stormberry.dart';

void main(List<String> arguments) {
  final dotEnv = DotEnv(includePlatformEnvironment: true)..load(['.env']);

  final database = Database(
    database: dotEnv.getOrElse(
      'POSTGRES_DB',
      () => throw Exception('POSTGRES_DB not defined'),
    ),
    host: dotEnv.getOrElse(
      'POSTGRES_DB',
      () => throw Exception('POSTGRES_DB not defined'),
    ),
    port: int.parse(dotEnv.getOrElse(
      'POSTGRES_DB',
      () => throw Exception('POSTGRES_DB not defined'),
    )),
    useSSL: false,
    password: dotEnv.getOrElse(
      'POSTGRES_DB',
      () => throw Exception('POSTGRES_DB not defined'),
    ),
  );
}
```
We're basically throwing an Exception if the variable is not defined. With our database in place, let's import the `models.dart` with the queries in place. 

## Examples of basic database operations.
### Insert a user
```dart
await database.users.insertOne(
  UserInsertRequest(
    id: 'id',
    username: 'user1',
    createdAt: DateTime.now(),
    passwordHash: 'passwordHash',
  ),
);
```
### Query a user
```dart
final gotUser = await database.users.queryUser('id');
if (gotUser != null) {
  // user found
  print(gotUser.id);
  print(gotUser.username);
  print(gotUser.createdAt);
  print(gotUser.phone);
}
```

### Update a user
In the update, we use an UserUpdateRequest with the only specific fields we want to update. 
```dart
await database.users.updateOne(
  UserUpdateRequest(id: 'id', phone: '+254345678'),
);
final updatedUser = await database.users.queryUser('id');
```

### Delete a user
```dart
await database.users.deleteOne('id');
```
You can see how easy stormberry makes life for us. We'd be busy writing SQL queries but now we're focused on implementing the business logic. It also uses views which is a really nice thing. 

:::tip

You can follow along yourself by cloning the repo at this [be-real-clone](https://github.com/bettdouglas/be-real-clone.git).
```bash
git clone https://github.com/bettdouglas/be-real-clone.git
cd be-real-clone
git checkout e7103c8
```
:::


## gRPC User Service
We'll want to create a gRPC user service that will have all CRUD functionality of creating, reading, updating and deleting of users. Let's define a user model message in `protos/models.proto`.
```protobuf
syntax = "proto3";

package bereal;

import "google/protobuf/timestamp.proto";

message User {
    string id = 1;
    string username = 2;
    string phone = 3;
    google.protobuf.Timestamp created_at = 4;
}
```
You'll also notice the `import "google/protobuf/timestamp.proto";` statement. Google defines a set of protobuf messages that are commonly used. They are known as Well They can be imported and shared across many projects. The full list of google defined types can be found here. [Protocol Buffers Well-Known Types
](https://protobuf.dev/reference/protobuf/google.protobuf/)

Let's create another file which will contain the user service like. Here I used the extension (vscode-proto3)[https://marketplace.visualstudio.com/items?itemName=zxh404.vscode-proto3] on VsCode to generate this service. I stripped out some parts which weren't in use so now we have the following. 

```protobuf
syntax = "proto3";

package bereal;

import "models.proto";
import "google/protobuf/empty.proto";
import "google/protobuf/field_mask.proto";

// Generated according to https://cloud.google.com/apis/design/standard_methods
service UserService {
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse) {}

  rpc GetUser(GetUserRequest) returns (User) {}

  rpc CreateUser(CreateUserRequest) returns (CreateUserResponse) {}

  rpc UpdateUser(UpdateUserRequest) returns (User){}

  rpc DeleteUser(DeleteUserRequest) returns (google.protobuf.Empty) {}

  /// Login a user with the given username and password.
  // Returns an access token and refresh token upon successful login.
  rpc Login(LoginRequest) returns (LoginResponse) {}
}


message ListUsersRequest {
  int32 page_size = 1;
  string page_token = 2;
}

message ListUsersResponse {
  repeated User users = 1;
  string next_page_token = 2;
}

message GetUserRequest {
  string id = 1;
}

message CreateUserRequest {
  User user = 1;
  string password = 2;
}

message CreateUserResponse {
    User user = 1;
    string jwt = 2;
}

message UpdateUserRequest {
  User user = 1;
  // The update mask applies to the resource. For the `FieldMask` definition,
  // see https://developers.google.com/protocol-buffers/docs/reference/google.protobuf#fieldmask
  google.protobuf.FieldMask update_mask = 2;
}

message DeleteUserRequest {
  // The resource name of the user to be deleted.
  string id = 1;
}

message LoginRequest {
    string username = 1;
    string password = 2;
}

message LoginResponse {
    string access_token = 1;
    string refresh_token = 2;
}
```

You can also see two new imports of 
```protobuf
import "google/protobuf/empty.proto";
import "google/protobuf/field_mask.proto";
```
These are part of the [Protocol Buffers Well-Known Types](https://protobuf.dev/reference/protobuf/google.protobuf/). The `Empty` message comes from `google/protobuf/empty.proto` and is used to signify null. 

When we delete a user, we just send back an `Empty` message to acknowledge that the deletion is done. 

The other FieldMask comes from `google/protobuf/field_mask.proto`. This is used to specify which parameters of a message should be masked/used when doing updates. It contains paths which is a List of strings pointing to which values should be used in the update. 

In the UpdateUser method, you'll see we pass an instance of `UpdateUserRequest` which contains the `User` we want to update and the `FieldMask`. 

### Generate gRPC Stubs
To make it easy to regenerate the protos when we change things, let's create a script called `generate-protos.sh` where we'll put instructions to generate the gRPC stubs. 

```bash
#! /bin/bash
set -euo pipefail

mkdir -p lib/grpc-gen/

# Generate models only
protoc -I protos/ --dart_out=lib/grpc-gen/ protos/models.proto 

# Generate Well-Known Types
protoc -I protos/ --dart_out=lib/grpc-gen/ google/protobuf/timestamp.proto google/protobuf/field_mask.proto google/protobuf/empty.proto

# Generate models + grpc stubs
protoc -I protos/ --dart_out=grpc:lib/grpc-gen/ protos/user_service.proto
```

We can then execute the script with 
```bash
./generate-protos.sh
```
This will create a directory called `lib/grpc-gen` then generate the stubs for us. 

Once the classes have been generated, you'll notice the compiler wants us to add the `protobuf` package. Let's add it to our dependencies together with grpc.
```bash
dart pub add protobuf grpc
```

### Implementing the User Service
Let's create a folder called services with a file named `user_service.dart` where we'll implement the `UserService` logic. 

```dart title="lib/services/user_service.dart"
import 'package:server/grpc-gen/models.pb.dart';
import 'package:server/grpc-gen/google/protobuf/empty.pb.dart';
import 'package:server/grpc-gen/user_service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class UserService extends UserServiceBase {
  @override
  Future<CreateUserResponse> createUser(ServiceCall call, CreateUserRequest request) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<LoginResponse> login(ServiceCall call, LoginRequest request) async {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Empty> deleteUser(ServiceCall call, DeleteUserRequest request) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<User> getUser(ServiceCall call, GetUserRequest request) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<ListUsersResponse> listUsers(ServiceCall call, ListUsersRequest request) {
    // TODO: implement listUsers
    throw UnimplementedError();
  }

  @override
  Future<User> updateUser(ServiceCall call, UpdateUserRequest request) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
```

This user service will need an instance of the `UserRepository` generated by stormberry. When we do `db.users`, stormberry uses an extension method to bind the database class with an instance of the `UserRepository`. 

```dart
class UserService extends UserServiceBase {
  final UserRepository userRepository;
  // other methods here
}
```
Once we import the `UserRepository`, you'll notice that there's a conflict between class names. We'll use import aliases to fix this. We'll alias the classes from `package:server/grpc-gen/models.pb.dart` with grpc and change update the method signatures to match well as below. The resulting class will be as the following. You'll see that the return value of the updated `UserService` will have `grpc.` as a prefix. 
```dart
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:server/database/models.dart';
import 'package:server/grpc-gen/google/protobuf/empty.pb.dart';
import 'package:server/grpc-gen/models.pb.dart' as grpc;
import 'package:server/grpc-gen/user_service.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class UserService extends UserServiceBase {
  final UserRepository userRepository;
  UserService({
    required this.userRepository,
  });

  @override
  Future<CreateUserResponse> createUser(ServiceCall call, CreateUserRequest request) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<LoginResponse> login(ServiceCall call, LoginRequest request) async {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Empty> deleteUser(ServiceCall call, DeleteUserRequest request) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<grpc.User> getUser(ServiceCall call, GetUserRequest request) {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<ListUsersResponse> listUsers(
      ServiceCall call, ListUsersRequest request) {
    // TODO: implement listUsers
    throw UnimplementedError();
  }

  @override
  Future<grpc.User> updateUser(ServiceCall call, UpdateUserRequest request) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
```

With that out of the way, let's now implement the methods. 

### CreateUser
We'll need to add the package `uuid` in order to generate unique user ids. I hope the stormberry package will enable us to specify defaults for us. But because that's not currently possible, let's add the uuid package to our package dependencies. 

```bash
dart pub add uuid
```
After adding this, since we'll mostly be converting our user object from the stormberry generated classes in many service implementions, let's create an extension method to convert from a stormberry `User` class to grpc generated `User` class. 

```dart
extension AsGrpcUser on UserView {
  grpc.User asGrpcUser() {
    return grpc.User(
      createdAt: Timestamp.fromDateTime(createdAt),
      id: id,
      phone: phone,
      username: username,
    );
  }
}
```

With that, we'll also need to hash the password the user supplied us with. We're going to use the package [dbcrypt](https://pub.dev/packages/dbcrypt). 
The package helps us with hashing passwords and checking if a specific password matches a specific hash using the OpenBSD bcrypt scheme.

We'll also create two helper methods to assist us with password hashing and checking if the password supplied is correct at login time. 

Let's add the `dbcrypt` and `jose` package to assist with these three tasks.

```bash
dart pub add dbcrypt jose
```

```dart title="lib/utils/auth_utils.dart"
String hashPassword(String password) {
  return DBCrypt().hashpw(password, DBCrypt().gensalt());
}

bool checkPassword(String password, String passwordHash) {
  return DBCrypt().checkpw(password, passwordHash);
}
```

We're also going to have a method to create and validate JWT tokens. We're going to use the jose package to assist us with this. 

```dart  title="lib/utils/auth_utils.dart"
String createJwt(
  BaseUserView user, {
  Duration expiry = const Duration(days: 2),
}) {
  final dotEnv = DotEnv(includePlatformEnvironment: true)..load(['.env']);
  final secretKey = dotEnv.getOrElse(
    'SECRET_KEY',
    () => throw 'SECRET_KEY not defined',
  );
  final claims = JsonWebTokenClaims.fromJson({
    "exp": expiry.inSeconds,
    "iss": "bereal-clone.com",
  });
  final builder = JsonWebSignatureBuilder();
  builder.addRecipient(
    JsonWebKey.fromJson(
      {
        "k": secretKey,
        "kty": 'oct',
      },
    ),
    algorithm: 'HS256',
  );
  builder.jsonContent = {
    'id': user.id,
    'username': user.username,
    'phone': user.phone,
  };
  final jwt = builder.build();
  return jwt.toCompactSerialization();
}

Future<Map<String, dynamic>> decodeJwt(String token) async {
  final dotEnv = DotEnv(includePlatformEnvironment: true)..load(['.env']);
  final secretKey = dotEnv.getOrElse(
    'SECRET_KEY',
    () => throw 'SECRET_KEY not defined',
  );
  final unverified = JsonWebToken.unverified(token);
  final keyStore = JsonWebKeyStore()
    ..addKey(JsonWebKey.fromJson({
      "kty": "oct",
      "k": secretKey,
    }));
  final verified = await unverified.verify(keyStore);
  if (verified) {
    final claims = unverified.claims.toJson();
    return claims;
  } else {
    throw Exception('Invalid token');
  }
}
```

With that out of the way, we can now create the user. When creating the user, we check if a user with the same name already exists. We later hash the password, save the user and create a JWT token to be used for subsequent requests. 

```dart  title="lib/services/auth_service.dart"
@override
Future<CreateUserResponse> createUser(
  ServiceCall call,
  CreateUserRequest request,
) async {
  final user = request.user;
  final username = user.username;
  final withSimilarUserName = await userRepository.query(
    UserNameQuery(),
    username,
  );
  if (withSimilarUserName != null) {
    throw GrpcError.alreadyExists(
      'User with username: $username already exists',
    );
  }
  final id = Uuid().v4();
  // call method to hash password using OpenBSD
  final passwordHash = hashPassword(request.password);
  await userRepository.insertOne(
    UserInsertRequest(
      id: id,
      username: username,
      createdAt: DateTime.now(),
      passwordHash: passwordHash,
    ),
  );
  final gotUser = await userRepository.queryBaseView(id);
  return CreateUserResponse(
    user: gotUser!.asGrpcUser(),
    jwt: createJwt(gotUser),
  );
}
```
Here we take the details from the user request and save the user to the database. We then get the user and return the response to the client. 


## Login
In this method, the user will send the usernane and password as part of the `LoginRequest` and we'll issue a `jwt` as part of the `LoginResponse`.
We query the user and get his password hash then compare it with the sent password. If they match, the server returns a jwt. 

```dart  title="lib/services/auth_service.dart"
@override
Future<LoginResponse> login(ServiceCall call, LoginRequest request) async {
  final username = request.username;
  final password = request.password;
  final user = await userRepository.query(UserNameQuery(), username);
  if (user == null) {
    throw GrpcError.notFound('$username not found');
  }
  final passwordsMatch = checkPassword(password, user.passwordHash);
  if (passwordsMatch) {
    final jwt = createJwt(user);
    return LoginResponse(
      accessToken: jwt,
    );
  }
  throw GrpcError.unauthenticated('Wrong username and password');
}
```

### DeleteUser 
This will be really simple. We delete the user and send back an acknowledgment to the user that the user has been deleted. 

```dart  title="lib/services/auth_service.dart"
@override
Future<Empty> deleteUser(
  ServiceCall call,
  DeleteUserRequest request,
) async {
  await userRepository.deleteOne(request.id);
  return Empty();
}
```

### GetUser
The request will receive a `id` and get the user with the requested `id`. 

```dart  title="lib/services/auth_service.dart"
@override
Future<grpc.User> getUser(ServiceCall call, GetUserRequest request) async {
  final user = await userRepository.queryUser(request.id);
  if (user == null) {
    throw GrpcError.notFound();
  }
  return user.asGrpcUser();
}
```

### ListUsers
In this method, the client will send us the `previousPageToken`(offset) or 0 if not specified. We'll send back 100 users per request together with the `nextPageToken`. 
The implementation will be
```dart  title="lib/services/auth_service.dart"
@override
Future<ListUsersResponse> listUsers(
  ServiceCall call,
  ListUsersRequest request,
) async {
  final offSet = int.tryParse(request.pageToken) ?? 0;
  final users = await userRepository.queryUsers(
    QueryParams(offset: offSet, limit: 100),
  );
  return ListUsersResponse(
    nextPageToken: '${offSet + 100}',
    users: users.map((e) => e.asGrpcUser()).toList(),
  );
}
```

### UpdateUser
When updating the user, the client will send the `User` who needs to be updated, together with the fields that he wants updated. In our case, only the username and phone number can be updated. Our implementation will thus look like the following. 
```dart  title="lib/services/auth_service.dart"
@override
Future<grpc.User> updateUser(
  ServiceCall call,
  UpdateUserRequest request,
) async {
  final user = request.user;
  final updateMaskPaths = request.updateMask.paths;
  String? username;
  String? phone;

  for (var path in updateMaskPaths) {
    if (path == 'username') {
      username = user.username;
    }
    if (path == 'phone') {
      phone = user.phone;
    }
  }

  final userUpdateRequest = UserUpdateRequest(
    id: user.id,
    phone: phone,
    username: username,
  );
  await userRepository.updateOne(userUpdateRequest);
  final updatedUser = await userRepository.queryUser(user.id);
  return updatedUser!.asGrpcUser();
}
```
We'll use the `UserUpdateRequest` from stormberry passing the fields which need to be updated as nullables. If null, stormberry will not update the specified field. We'll then check the `UpdateMask` paths to see which fields does the client want to update. 

:::tip

You can test the server at this point by cloning the repo and connect to it using [kreya](https://kreya.app) desktop client.
```bash
git clone https://github.com/bettdouglas/be-real-clone.git
cd be-real-clone
git checkout c4cca3b
dart run bin/server.dart
```
:::

### Authentication
Right now, this server can be queried by anyone. The only methods that need to be open to the public are the `Login` and `CreateUser` method. All other methods should require proper authorization through the use of a token. 
When someone logs in successfully, the server returns a jwt as part of the `LoginResponse` object. 
For authentication, we're going to create an interceptor that will stop all unauthenticated requests. 
We're going to extract the full name of the method from the request call metadata and extract the methodName. 


```dart title="lib/interceptors/auth_interceptor.dart"
import 'package:server/auth_utils.dart';
import 'package:grpc/grpc.dart';

Future<GrpcError?> authInterceptor(
  ServiceCall call,
  ServiceMethod method,
) async {
  final openMethods = [
    '/bereal.UserService/Login',
    '/bereal.UserService/CreateUser',
  ];
  final metadata = call.clientMetadata ?? {};
  print(call.clientMetadata);
  final methodName = metadata[':path'];
  if (openMethods.contains(methodName)) {
    return null;
  }
  final token = metadata['authorization'];
  if (token == null) {
    return GrpcError.unauthenticated('Token not found');
  }
  try {
    final claims = await decodeJwt(token);
    metadata
        .addAll(claims.map((key, value) => MapEntry(key, value.toString())));
    return null;
  } on InvalidTokenException {
    return GrpcError.unauthenticated();
  } catch (e) {
    return GrpcError.unknown();
  }
}
```

In the server, we'll need to specify this as an interceptor when creating the server. 
```dart
void main() {
  final dotEnv = DotEnv(includePlatformEnvironment: true)..load(['.env']);
  final database = Database();


  final interceptors = <Interceptor>[
    authInterceptor,
  ];
  final server = Server(
    [UserService(userRepository: database.users)],
    interceptors,
  );
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(dotEnv.getOrElse('PORT', () => '8087'));

  await server.serve(address: ip, port: port);

  print('Server running at $ip on $port');
}
```

With this, we can now validate that only logged in users have access to the database. 

:::tip

You can follow along yourself by cloning the repo at this [be-real-clone](https://github.com/bettdouglas/be-real-clone.git).
```bash
git clone https://github.com/bettdouglas/be-real-clone.git
cd be-real-clone
git checkout e335467
dart run bin/server.dart
```
:::