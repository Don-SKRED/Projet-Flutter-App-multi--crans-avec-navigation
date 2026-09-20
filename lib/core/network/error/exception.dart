// lib/core/errors/app_exception.dart
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);
  @override
  String toString() => message;
}

class InvalidInputException extends AppException {
  const InvalidInputException() : super("Email ou mot de passe incorrect");
}

class NetworkException extends AppException {
  const NetworkException() : super('Vérifie ta connexion internet');
}

class TimeoutException extends AppException {
  const TimeoutException() : super('La connexion a expiré, réessaie');
}

class UnauthorizedException extends AppException {
  final int? statusCode;

  const UnauthorizedException(
    String s, {
    String message = 'Le serveur a rencontré un problème',
    this.statusCode,
  }) : super(message);
}

class ForbiddenException extends AppException {
  const ForbiddenException() : super("Tu n'as pas accès à cette ressource");
}

class NotFoundException extends AppException {
  const NotFoundException() : super('Ressource introuvable');
}

class ConflictException extends AppException {
  const ConflictException(super.message); // ex: "Cet email est déjà utilisé"
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    String message = 'Le serveur a rencontré un problème',
    this.statusCode,
  }) : super(message);
}

class UnknownException extends AppException {
  const UnknownException() : super('Une erreur inattendue est survenue');
}
