import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Gym extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String city;

  @override
  List<Object> get props => [name, city, imageUrl];

  Gym({this.id, this.name, this.imageUrl, this.city});

  factory Gym.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return Gym(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        city: data['city'] ?? '',
        imageUrl: data['imageUrl'] ?? '');
  }
}
