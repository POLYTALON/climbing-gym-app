import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppRoute extends Equatable {
  final String id;
  final String name;
  final String type;
  //final List<Map<String, DateTime>> comments;
  //final List<int> rating;
  final List<dynamic> builders;
  final DateTime date;
  final String difficulty;
  final String gymId;
  final String holds;
  final List<dynamic> imageUrls;

  @override
  List<Object> get props => [
        id,
        name,
        type,
        //comments,
        //rating,
        builders,
        date,
        difficulty,
        gymId,
        holds,
        imageUrls
      ];

  AppRoute(
      {this.id,
      this.name,
      this.type,
      //this.comments,
      //this.rating,
      this.builders,
      this.date,
      this.difficulty,
      this.gymId,
      this.holds,
      this.imageUrls});

  factory AppRoute.fromFirestore(DocumentSnapshot doc) {
    Map docData = doc.data();
    print(docData);
    // Map ratingsData = ratings.data();
    return AppRoute(
        id: doc.id ?? '',
        name: docData['name'] ?? '',
        builders: docData['builders'] ?? [],
        date: docData['date'] != null
            ? new DateTime.fromMillisecondsSinceEpoch(
                docData['date'].seconds * 1000)
            : '',
        difficulty: docData['difficulty'] ?? '',
        gymId: docData['gymid'] ?? '',
        holds: docData['holds'] ?? '',
        type: docData['type'] ?? '',
        imageUrls: docData['imageUrls'] ?? []);
    //comments: ratingsData['comments'] ?? [],
    //rating: ratingsData['rating'] ?? []);
  }
}
