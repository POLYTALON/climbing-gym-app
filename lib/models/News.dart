import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String id;
  final String gymid;
  final String title;
  final String link;
  final String content;
  final String creator;
  final DateTime date;
  final List<dynamic> imageUrls;
  final bool isGlobal;

  @override
  List<Object> get props =>
      [id, gymid, title, link, content, creator, date, imageUrls, isGlobal];

  News(
      {this.id,
      this.gymid,
      this.title,
      this.link,
      this.content,
      this.creator,
      this.date,
      this.imageUrls,
      this.isGlobal});

  factory News.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return News(
      id: doc.id,
      gymid: data['gymid'] ?? '',
      title: data['title'] ?? '',
      link: data['link'] ?? '',
      content: data['content'] ?? '',
      creator: data['creator'] ?? '',
      date: data['date'] != null
          ? new DateTime.fromMillisecondsSinceEpoch(data['date'].seconds * 1000)
          : '',
      imageUrls: data['imageUrls'] ?? '',
      isGlobal: data['isGlobal'] == true ? true : false,
    );
  }
}
