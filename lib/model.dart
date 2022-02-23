// To parse this JSON data, do
//
//     final data = dataFromJson(jsonString);

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

List<Data> dataFromJson(String str) => List<Data>.from(json.decode(str).map((x) => Data.fromJson(x)));

String dataToJson(List<Data> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Data {
    Data({
        required this.circleText,
        required this.title,
        required this.content,

    });

    String circleText;
    String title;
    String content;
   

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        circleText: json["circleText"],
        title: json["title"],
        content: json["Content"],
        
    );

    Map<String, dynamic> toJson() => {
        "circleText": circleText,
        "title": title,
        "Content": content,
        
    };
}
