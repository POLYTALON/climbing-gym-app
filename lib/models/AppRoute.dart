import 'package:climbing_gym_app/models/RouteColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppRoute extends Equatable {
  final String id;
  final String name;
  final String type;
  final List<dynamic> builders;
  final DateTime date;
  final RouteColor difficulty;
  final String gymId;
  final String holds;
  final List<dynamic> imageUrls;

  @override
  List<Object> get props =>
      [id, name, type, builders, date, difficulty, gymId, holds, imageUrls];

  AppRoute(
      {this.id,
      this.name,
      this.type,
      this.builders,
      this.date,
      this.difficulty,
      this.gymId,
      this.holds,
      this.imageUrls});

  factory AppRoute.fromFirestore(DocumentSnapshot doc) {
    Map docData = doc.data();
    return AppRoute(
        id: doc.id ?? '',
        name: docData['name'] ?? '',
        builders: docData['builders'] ?? [],
        date: docData['date'] != null
            ? new DateTime.fromMillisecondsSinceEpoch(
                docData['date'].seconds * 1000)
            : '',
        difficulty: RouteColor(docData['difficulty'] ?? ''),
        gymId: docData['gymid'] ?? '',
        holds: docData['holds'] ?? '',
        type: docData['type'] ?? '',
        imageUrls: docData['imageUrls'] ?? []);
  }
}
