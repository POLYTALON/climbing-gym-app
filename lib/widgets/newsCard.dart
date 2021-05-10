import 'package:climbing_gym_app/models/News.dart';
import 'package:flutter/material.dart';

class NewsCard extends StatefulWidget {
  @override
  final News
      news; // <--- generates the error, "Field doesn't override an inherited getter or setter"
  NewsCard({News news}) : this.news = news;

  SharingDialogState createState() => new SharingDialogState(news);
}

class SharingDialogState extends State<NewsCard> {
  SharingDialogState(this.news);
  final News news;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: new Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: ClipRRect(
                child:
                    Image.network(this.news.imageUrls[0], fit: BoxFit.contain),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(this.news.content,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 15)),
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // mainAxisAlignment

                      children: [
                        Text(this.news.creator,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w800,
                                fontSize: 15)),
                        Text(this.news.date.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w800,
                                fontSize: 15)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
