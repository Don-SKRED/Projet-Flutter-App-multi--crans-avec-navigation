enum RoleCredit { realisateur, acteur, actrice, scenariste }

class Credits {
  final int _id;
  final int filmId;
  final int personneId;
  final RoleCredit role;
  final String? personnage; // nom du personnage, si acteur/actrice

  const Credits(
    this._id, {
    required this.filmId,
    required this.personneId,
    required this.role,
    this.personnage,
  });
  int get id => _id;
  factory Credits.fromJson(Map<String, dynamic> json) => Credits(
    json['id'],
    filmId: json['filmId'],
    personneId: json['personneId'],
    role: RoleCredit.values.byName(json['role']),
    personnage: json['personnage'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'filmId': filmId,
    'personneId': personneId,
    'role': role.name,
    'personnage': personnage,
  };

  String get roleLabel {
    switch (role) {
      case RoleCredit.realisateur:
        return 'Réalisateur·rice';
      case RoleCredit.acteur:
        return 'Acteur';
      case RoleCredit.actrice:
        return 'Actrice';
      case RoleCredit.scenariste:
        return 'Scénariste';
    }
  }
}
