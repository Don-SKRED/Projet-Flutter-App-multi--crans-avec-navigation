class Film {
  final int _id;
  final String title;
  final int release;
  final String synopsis;
  final String genre;
  final String poster;

  const Film(
    this._id, {
    required this.title,
    required this.release,
    required this.synopsis,
    required this.genre,
    required this.poster,
  });

  int get id => _id;

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      json['id'],
      title: json['title'],
      release: json['release'],
      synopsis: json['synopsis'],
      genre: json['genre'],
      poster: json['poster'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'title': title,
      'release': release,
      'synopsis': synopsis,
      'genre': genre,
      'poster': poster,
    };
  }
}
