import 'package:cloud_firestore/cloud_firestore.dart';

class Route {
  final String id;
  final String name;
  final String type;
  final List<Map<String, DateTime>> comments;
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

  factory Route.fromFirestore(DocumentSnapshot doc, DocumentSnapshot ratings) {
    Map docData = doc.data();
    Map ratingsData = ratings.data();
    return Route(
        id: doc.id ?? '',
        name: docData['name'] ?? '',
        builders: docData['builders'] ?? [],
        date: docData['date'] ?? DateTime.now(),
        difficulty: docData['difficulty'] ?? '',
        gymId: ratingsData['gymid'] ?? '',
        holds: docData['holds'] ?? '',
        type: docData['type'] ?? '',
        imageUrls: docData['imageUrls'] ?? [],
        comments: ratingsData['comments'] ?? [],
        rating: ratingsData['rating'] ?? []);
  }
}
