import 'package:equatable/equatable.dart';

class Rating extends Equatable {
  final List<dynamic> comments;
  final List<dynamic> ratings;

  @override
  List<Object> get props => [comments, ratings];

  Rating({this.comments, this.ratings});

  factory Rating.fromFirestore(List<String> comments, List<int> ratings) {
    return Rating(comments: comments, ratings: ratings);
  }
}
