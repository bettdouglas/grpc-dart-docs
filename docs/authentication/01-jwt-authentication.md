# JWT Authentication

## Overview

JWTs(JSON Web Tokens) are cyptographically signed JSON text information. The payload section of a JWT can contain a number of claims. A receiver of a JWT can verify that the claims haven't been altered because any change to the payload data would invalidate the signature.

In this example code, the only claim will be that the client has authenticated with a given username. The gRPC server verifies the username and password received by the client and sends back an Auth message that contains the JWT. In subsequent gRPC calls the client sends the JWT back to the server inside the header information.

## Example Proto File

```proto title="example.proto"
message UserLogin {
    string user_name = 1;
    string password = 2;
}

message AuthResponse {
    bool authenticated = 1;
    string jwt_data = 2;
}

service ExampleService {
    rpc Authenticate (UserLogin) returns (AuthResponse);
}
```

## gRPC Server

### Add Interceptor to gRPC Server

You must have a gRPC interceptor on the server side that rejects an gRPC request if the JWT is missing or has an invalid signature.
```dart title="main.dart"
final server = Server(
  [ExampleService()],
  <Interceptor>[authInterceptor],
  CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
);
```

### Implement Interceptor

Here the authInterceptor rejects incoming gRPC requests if they have a missing/invalid JWT in the client metadata. The authInterceptor call also allows the gRPC request if it's an Authenticate call because the client doesn't have the JWT yet. The jaguar_jwt package is being used here to issue and verify JWTs on both ends, but there are other JWT packages that you could use. The secret JWT key is loaded from a text file on the server.
```dart title="auth_interceptor.dart"
FutureOr<GrpcError?> authInterceptor(ServiceCall call, ServiceMethod method) {
  if (call.clientMetadata?[':path'] == null) {
    return GrpcError.unauthenticated();
  }
  if (call.clientMetadata![':path']!.toLowerCase().contains('authenticate')) {
    return null; // allow all authenticate RPC calls
  }
  try {
    final jwt = call.clientMetadata!['jwt'];
    if (jwt == null) {
      return GrpcError.unauthenticated();
    }
    final claimSet = verifyJwtHS256Signature(
      jwt,
      SecuritySettings.secretJwtKey,
    );
    if (claimSet.subject?.isEmpty ?? true) {
      return GrpcError.unauthenticated();
    }
  } on JwtException {
    return GrpcError.unauthenticated();
  }

  return null; // authenticated by signed JWT
}
```

### Implement Authenticate Method

The server's authenticate method has verified the username and password sent by the client and returns a Auth response that contains the JWT generated with the claim set and secret JWT key. 
```dart title="authenticate.dart"
final claimSet = JwtClaim(subject: request.userName);
try {
  final jwt = issueJwtHS256(claimSet, SecuritySettings.secretJwtKey);
  return AuthResponse(
    authenticated: true,
    jwtData: jwt,
   );
} on JsonUnsupportedObjectError {
 return AuthResponse(
    authenticated: false,
    jwtData: '',
 );
}
```

## gRPC Client

### Add Interceptor to Client Stub

Just as on the server, the client must also have an interceptor. The client interceptor injects the JWT into the gRPC header on all non-authenticate calls.
```dart
stub = ExampleServiceClient(
  channel,
  options: CallOptions(
    timeout: const Duration(seconds: 30),
  ),
  interceptors: <ClientInterceptor>[AuthInterceptor()],
);
```

### Implement Client Interceptor Class

Unlike the server, a client interceptor is a class that overrides the interceptUnary and interceptStreaming methods from the ClientInterceptor base class. You'll need to provide the JWT you receive from the server. You can store the JWT in state management.
```dart title="auth_interceptor.dart"
class AuthInterceptor implements ClientInterceptor {
  @override
  ResponseStream<R> interceptStreaming<Q, R>(
      ClientMethod<Q, R> method,
      Stream<Q> requests,
      CallOptions options,
      ClientStreamingInvoker<Q, R> invoker) {
    final jwt = // Read JWT from state management.
    var newOptions = options.mergedWith(
      CallOptions(metadata: <String, String>{
        'jwt': jwt,
      }),
    );
    return invoker(
      method,
      requests,
      newOptions,
    );
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request,
      CallOptions options, ClientUnaryInvoker<Q, R> invoker) {
    final jwt = // Read JWT from state management.
    var newOptions = options.mergedWith(
      CallOptions(metadata: <String, String>{
        'jwt': jwt,
      }),
    );
    return invoker(
      method,
      request,
      newOptions,
    );
  }
}
```

### Implement Authenticate Function

Here is a simple client gRPC authenticate function that sends the username and password in a request to the server and gets the signed JWT in the response.
```dart title="authenticate.dart"
Future<Auth> authenticate(String userName, String password) async {
  final request = UserLogin(
    userName: userName,
    password: password,
  );

  final response = await stub.authenticate(request);

  return Auth(
    authenticated: response.authenticated,
    authenticationToken: response.jwtData,
  );
}
```