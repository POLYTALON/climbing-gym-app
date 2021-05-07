import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Gym extends Equatable {
  Gym({@required this.name, @required this.imageUrl});

  final String name;
  final String imageUrl;

  @override
  List<Object> get props => [name, imageUrl];
}
