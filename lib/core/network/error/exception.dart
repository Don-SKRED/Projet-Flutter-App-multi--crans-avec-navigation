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
  const UnauthorizedException() : super('Session expirée, reconnecte-toi');
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
  const ServerException() : super('Le serveur a rencontré un problème');
}

class UnknownException extends AppException {
  const UnknownException() : super('Une erreur inattendue est survenue');
}
