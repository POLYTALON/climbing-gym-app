import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';

class News extends Equatable {
  final String title;
  final String content;
  final String creator;
  final DateTime date;
  final List<dynamic> imageUrls;
  final bool isGlobal;

  @override
  List<Object> get props =>
      [title, content, creator, date, imageUrls, isGlobal];

  News(
      {this.title,
      this.content,
      this.creator,
      this.date,
      this.imageUrls,
      this.isGlobal});

  factory News.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return News(
      title: data['title'] ?? '',
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
