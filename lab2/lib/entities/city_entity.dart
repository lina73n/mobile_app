class FilmEntity {
  late String id;
  late String name;
  late String country;
  late String description;
  late int yearOfFoundation;
  late List<String> imageUrls;

  FilmEntity(this.id, this.name, this.country, this.description,
      this.yearOfFoundation, this.imageUrls);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "country": country,
        "yearOfFoundation": yearOfFoundation,
        "imageUrls": imageUrls
      };

  static getFilmList(List data) {
    List<FilmEntity> result = [];
    for (final film in data) {
      List<String> imageUrls =
          (film['imageUrls'] as List).map((e) => e as String).toList();
      result.add(FilmEntity(film['id'], film['name'], film['description'],
          film['country'], film['yearOfFoundation'], imageUrls));
    }
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is FilmEntity) {
      return other.id == id;
    } else if (other is Map<Object?, Object?>) {
      Map<String, dynamic> temp =
          other.map((key, value) => MapEntry(key.toString(), value));
      return temp['id'] == id;
    }

    return false;
  }

  @override
  int get hashCode => name.hashCode ^ country.hashCode;
}
