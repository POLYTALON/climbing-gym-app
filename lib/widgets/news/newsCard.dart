import 'package:climbing_gym_app/models/News.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

class NewsCard extends StatefulWidget {
  //NewsCard({News news, Function onClickNews});

  NewsCard({@required News news, @required Function onClickNews})
      : news = news,
        onClickNews = onClickNews;

  final News news;
  final Function onClickNews;

  _NewsCardState createState() => new _NewsCardState(news, onClickNews);
}

class _NewsCardState extends State<NewsCard> {
  final News news;
  final Function onClickNews;
  _NewsCardState(this.news, this.onClickNews);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: new Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                    onPressed: onClickNews(this.news), child: Text("open")),
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
                    Text(DateFormat('dd.MM.yyyy').format(this.news.date),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                  ],
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(this.news.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15)),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: ClipRRect(
                    child: Stack(
                      children: <Widget>[
                        Center(child: CircularProgressIndicator()),
                        Center(
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: this.news.imageUrls[0],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
