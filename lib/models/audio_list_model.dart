// To parse this JSON data, do
//
//     final audioListModel = audioListModelFromJson(jsonString);

import 'dart:convert';

AudioListModel audioListModelFromJson(String str) => AudioListModel.fromJson(json.decode(str));

String audioListModelToJson(AudioListModel data) => json.encode(data.toJson());

class AudioListModel {
  final int total;
  final List<AudioModel> data;

  AudioListModel({
    required this.total,
    required this.data,
  });

  factory AudioListModel.fromJson(Map<String, dynamic> json) => AudioListModel(
    total: json["total"],
    data: List<AudioModel>.from(json["data"].map((x) => AudioModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AudioModel {
  final int id;
  final String title;
  final dynamic summary;
  final String url;
  final dynamic fileExt;
  final String modified;

  AudioModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.url,
    required this.fileExt,
    required this.modified,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) => AudioModel(
    id: json["id"],
    title: json["title"],
    summary: json["summary"],
    url: json["url"],
    fileExt: json["file_ext"],
    modified: json["modified"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "summary": summary,
    "url": url,
    "file_ext": fileExt,
    "modified": modified,
  };
}