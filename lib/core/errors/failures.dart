import 'package:education_app/core/errors/exceptions.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  Failure({required this.message, required this.statusCode})
    : assert(
        statusCode is String || statusCode is int,
        'StatusCode cannot be a ${statusCode.runtimeType}',
      );

  final String message;
  // case statusCode from firebase usually is a string -> type is dynamic
  final dynamic statusCode;

  String get errorMessage =>
      '$statusCode${statusCode is String ? '' : 'Error '}: $message';

  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, required super.statusCode});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, required super.statusCode});

  ServerFailure.fromException(ServerException e)
    : this(message: e.message, statusCode: e.statusCode);
}
