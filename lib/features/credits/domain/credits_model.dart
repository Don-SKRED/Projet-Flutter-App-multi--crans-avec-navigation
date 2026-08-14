enum RoleCredit { realisateur, acteur, actrice, scenariste }

class Credits {
  final int _id;
  final int filmId;
  final int personId;
  final RoleCredit role;
  final String? personnage; // nom du personnage, si acteur/actrice

  const Credits(
    this._id, {
    required this.filmId,
    required this.personId,
    required this.role,
    this.personnage,
  });
  int get id => _id;
  factory Credits.fromJson(Map<String, dynamic> json) => Credits(
    json['id'],
    filmId: json['filmId'],
    personId: json['personId'],
    role: RoleCredit.values.byName(json['role']),
    personnage: json['personnage'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'filmId': filmId,
    'personId': personId,
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
