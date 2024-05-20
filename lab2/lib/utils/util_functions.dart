import 'package:lab2/entities/film_entity.dart';

class UtilFunctions {
  static checkListType(List list) {
    if (list.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static findElement(List<FilmEntity> list, FilmEntity filmEntity) {
    for (final film in list) {
      if (film.name == filmEntity.name && film.country == filmEntity.country) {
        return true;
      }
    }
    return false;
  }
}
