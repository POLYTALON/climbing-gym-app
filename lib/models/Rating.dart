import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final List<Map<String, Timestamp>> comments;
  final List<dynamic> ratings;

  @override
  List<Object> get props => [comments, ratings];

  Rating({this.comments, this.ratings});

  factory Rating.fromFirestore(
      List<Map<String, Timestamp>> comments, List<int> ratings) {
    var rating = Rating(comments: comments, ratings: ratings);
    print('Inside Model: ' + rating.toString());
    return rating;
  }
}
