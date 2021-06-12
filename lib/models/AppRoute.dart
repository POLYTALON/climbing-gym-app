import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppRoute extends Equatable {
  final String id;
  final String name;
  final String type;
  final String builder;
  final DateTime date;
  final String difficulty;
  final String gymId;
  final String holds;
  final String imageUrl;
  bool isTried;
  bool isDone;

  @override
  List<Object> get props => [
        id,
        name,
        type,
        builder,
        date,
        difficulty,
        gymId,
        holds,
        imageUrl,
        isTried,
        isDone
      ];

  AppRoute(
      {this.id,
      this.name,
      this.type,
      this.builder,
      this.date,
      this.difficulty,
      this.gymId,
      this.holds,
      this.imageUrl,
      this.isTried,
      this.isDone});

  factory AppRoute.fromFirestore(
      DocumentSnapshot doc, bool isTried, bool isDone) {
    Map docData = doc.data();
    return AppRoute(
        id: doc.id ?? '',
        name: docData['name'] ?? '',
        builder: docData['builder'] ?? '',
        date: docData['date'] != null
            ? new DateTime.fromMillisecondsSinceEpoch(
                docData['date'].seconds * 1000)
            : '',
        difficulty: docData['difficulty'] ?? '',
        gymId: docData['gymid'] ?? '',
        holds: docData['holds'] ?? '',
        type: docData['type'] ?? '',
        imageUrl: docData['imageUrl'] ?? '',
        isTried: isTried,
        isDone: isDone);
  }
}
