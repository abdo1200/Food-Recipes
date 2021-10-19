import 'package:flutter/material.dart';
class RecipeModel{
  String label;
  String image;
  String source;
  String url;

  RecipeModel({this.url,this.source,this.image,this.label});
  factory RecipeModel.fromMap(Map<String,dynamic> parsedJson){
    return RecipeModel(
      url: parsedJson['url'],
      label: parsedJson['label'],
      image: parsedJson['image'],
      source: parsedJson['source']
    );
  }
}