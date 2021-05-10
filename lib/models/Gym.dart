import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Gym extends Equatable {
  final String name;
  final String imageUrl;
  final String city;

  @override
  List<Object> get props => [name, city, imageUrl];

  Gym({this.name, this.imageUrl, this.city});

  factory Gym.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Gym(
        name: data['name'] ?? '',
        city: data['city'] ?? '',
        imageUrl: data['imageUrl'] ?? '');
  }
}
