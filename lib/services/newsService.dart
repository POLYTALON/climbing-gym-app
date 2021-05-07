import 'package:climbing_gym_app/models/News.dart';
import 'package:flutter/material.dart';

class NewsService with ChangeNotifier {
  List<News> newsList = [
    News(
        creator: "God",
        publishDate: DateTime.utc(2021, 11, 9),
        text: "Genialer Entwickler implementiert die News Page",
        imageUrl:
            "https://media.metaebene.me/media/raumzeit/rz062-albert-einstein.jpg"),
    News(
        creator: "Polytalon",
        publishDate: DateTime.utc(2021, 11, 9),
        text: "Polytalon sponsert Entwicklerteam mit Freibier",
        imageUrl:
            "https://res.cloudinary.com/deloma/image/upload/h_256,q_85/v1/images/product/8dfad5ec-9ae6-40d8-8513-c965005da483.jpg?pfdrid_c=true"),
    News(
        creator: "Nail Oezmen,",
        publishDate: DateTime.utc(2021, 11, 9),
        text:
            "Entwickler verspätet sich 2x zum Weekly und muss Kasten sponsern",
        imageUrl:
            "https://images-na.ssl-images-amazon.com/images/I/61S3AN1vr7L._AC_SX679_.jpg"),
    News(
        creator: "Longy Texty,",
        publishDate: DateTime.utc(2021, 11, 9),
        text:
            "News haben manchmal sehr lange Texte. Die Frage ist, wie wird diese hier dann angezeigt? Overflowt etwas?",
        imageUrl:
            "https://www.memesmonkey.com/images/memesmonkey/21/21a016d77731b49ece2c8ab4baf9dcc2.jpeg"),
  ];
}
