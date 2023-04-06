import 'dart:developer';

import 'package:grpc/grpc.dart';

// Picked from StackOverflow
// https://stackoverflow.com/questions/72949714/how-to-intercept-grpc-response/72949742#72949742

class LoggerInterceptor extends ClientInterceptor {
  static final LoggerInterceptor _instance = LoggerInterceptor._();
  static LoggerInterceptor get instance => _instance;

  LoggerInterceptor._();

  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request,
      CallOptions options, ClientUnaryInvoker<Q, R> invoker) {
    // Log the request
    log(
      'Grpc request. '
      'method: ${method.path}, '
      'request: $request',
    );
    final response = super.interceptUnary(
      method,
      request,
      options,
      invoker,
    );
    // Registers callback to be called when the future completes
    response.then((r) {
      log(
        'Grpc response. '
        'method: ${method.path}, '
        'response: $r',
      );
    });

    return response;
  }
}
