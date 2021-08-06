import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppRoute extends Equatable {
  final String id;
  final String type;
  final String builder;
  final DateTime date;
  final String difficulty;
  final String gymId;
  final String holds;
  final String imageUrl;
  final String notes;
  bool isTried;
  bool isDone;
  int ratingCount;
  double rating;

  @override
  List<Object> get props => [
        id,
        type,
        builder,
        date,
        difficulty,
        gymId,
        holds,
        notes,
        imageUrl,
        isTried,
        isDone,
        ratingCount,
        rating,
      ];

  AppRoute(
      {this.id,
      this.type,
      this.builder,
      this.date,
      this.difficulty,
      this.gymId,
      this.holds,
      this.notes,
      this.imageUrl,
      this.isTried,
      this.isDone,
      this.ratingCount,
      this.rating});

  factory AppRoute.fromFirestore(DocumentSnapshot doc, bool isTried,
      bool isDone, int ratingCount, double rating) {
    Map docData = doc.data();
    return AppRoute(
        id: doc.id ?? '',
        builder: docData['builder'] ?? '',
        date: docData['date'] != null
            ? new DateTime.fromMillisecondsSinceEpoch(
                docData['date'].seconds * 1000)
            : '',
        difficulty: docData['difficulty'] ?? '',
        gymId: docData['gymid'] ?? '',
        holds: docData['holds'] ?? '',
        notes: docData['notes'] ?? '',
        type: docData['type'] ?? '',
        imageUrl: docData['imageUrl'] ?? '',
        isTried: isTried,
        isDone: isDone,
        ratingCount: ratingCount,
        rating: rating);
  }
}
