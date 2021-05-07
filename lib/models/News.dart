import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class News extends Equatable {
  News(
      {@required this.text,
      @required this.imageUrl,
      @required this.publishDate,
      @required this.creator});

  final String text;
  final String imageUrl;
  final DateTime publishDate;
  final String creator;

  @override
  List<Object> get props => [text, imageUrl, publishDate, creator];
}
