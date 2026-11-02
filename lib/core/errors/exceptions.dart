class ServerException implements Exception {
  const ServerException([this.message]);
  final String? message;
}

class NetworkException implements Exception {
  const NetworkException([this.message]);
  final String? message;
}

class UnauthorizedException implements Exception {
  const UnauthorizedException([this.message]);
  final String? message;
}

class CacheException implements Exception {
  const CacheException([this.message]);
  final String? message;
}

class ParsingException implements Exception {
  const ParsingException([this.message]);
  final String? message;
}

class ValidationException implements Exception {
  const ValidationException([this.message]);
  final String? message;
}
