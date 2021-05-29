import 'package:cloud_firestore/cloud_firestore.dart';

class Route {
  final String id;
  final String name;
  final String type;
  final List<String> comments;
  final List<int> rating;
  final List<String> builders;
  final DateTime date;
  final String difficulty;
  final String gymId;
  final String holds;
  final List<String> imageUrls;

  @override
  List<Object> get props => [
        id,
        name,
        type,
        comments,
        rating,
        builders,
        date,
        difficulty,
        gymId,
        holds,
        imageUrls
      ];

  Route(
      {this.id,
      this.name,
      this.type,
      this.comments,
      this.rating,
      this.builders,
      this.date,
      this.difficulty,
      this.gymId,
      this.holds,
      this.imageUrls});

  factory Route.fromFirestore(DocumentSnapshot doc, DocumentSnapshot fields) {
    Map docData = doc.data();
    Map fieldsData = fields.data();
    return Route(
        id: doc.id ?? '',
        comments: docData['comments'] ?? [],
        rating: docData['rating'] ?? [],
        builders: fieldsData['builders'] ?? [],
        date: fieldsData['date'] ?? DateTime.now(),
        difficulty: fieldsData['difficulty'] ?? '',
        gymId: fieldsData['gymid'] ?? '',
        holds: fieldsData['holds'] ?? '',
        name: fieldsData['name'] ?? '',
        type: fieldsData['type'] ?? '',
        imageUrls: fieldsData['imageUrls'] ?? []);
  }
}
