import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'The server could not complete the request.',
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Check your connection and try again.',
  ]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Your session has expired.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local data could not be read.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'The response was not understood.']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong.']);
}
