// To parse this JSON data, do
//
//     final allMovie = allMovieFromJson(jsonString);

import 'dart:convert';

AllMovie allMovieFromJson(String str) => AllMovie.fromJson(json.decode(str));

String allMovieToJson(AllMovie data) => json.encode(data.toJson());

class AllMovie {
  AllMovie({
    this.search,
    this.totalResults,
    this.response,
  });

  List<Search> search;
  String totalResults;
  String response;

  factory AllMovie.fromJson(Map<String, dynamic> json) => AllMovie(
    search: List<Search>.from(json["Search"].map((x) => Search.fromJson(x))),
    totalResults: json["totalResults"],
    response: json["Response"],
  );

  Map<String, dynamic> toJson() => {
    "Search": List<dynamic>.from(search.map((x) => x.toJson())),
    "totalResults": totalResults,
    "Response": response,
  };
}

class Search {
  Search({
    this.title,
    this.year,
    this.imdbId,
    this.type,
    this.poster,
  });

  String title;
  String year;
  String imdbId;
  Type type;
  String poster;

  factory Search.fromJson(Map<String, dynamic> json) => Search(
    title: json["Title"],
    year: json["Year"],
    imdbId: json["imdbID"],
    type: typeValues.map[json["Type"]],
    poster: json["Poster"],
  );

  Map<String, dynamic> toJson() => {
    "Title": title,
    "Year": year,
    "imdbID": imdbId,
    "Type": typeValues.reverse[type],
    "Poster": poster,
  };
}

enum Type { GAME, MOVIE }

final typeValues = EnumValues({
  "game": Type.GAME,
  "movie": Type.MOVIE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
