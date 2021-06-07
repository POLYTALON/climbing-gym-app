import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/models/News.dart';
import 'package:climbing_gym_app/services/newsService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;

class NewsCard extends StatefulWidget {
  NewsCard({@required News news, @required bool isDeletable})
      : news = news,
        isDeletable = isDeletable;

  final News news;
  final bool isDeletable;

  _NewsCardState createState() => new _NewsCardState(news, isDeletable);
}

class _NewsCardState extends State<NewsCard> {
  News news;
  bool isDeletable;
  _NewsCardState(this.news, this.isDeletable);

  @override
  void didUpdateWidget(NewsCard oldWidget) {
    if (news != widget.news || isDeletable != widget.isDeletable) {
      setState(() {
        news = widget.news;
        isDeletable = widget.isDeletable;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
      child: GestureDetector(
        onTap: onPressNews,
        child: new Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            this.news.title,
                            textAlign: TextAlign.center,
                            style: Constants.subHeaderText,
                          )),
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
                          if (this.isDeletable)
                            Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                    onPressed: () {
                                      onPressDelete(context);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Constants.polyRed,
                                    )))
                        ],
                      ),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  void onPressNews() {
    final newsDetails = locator<NewsService>();
    newsDetails.showNews(this.news);
  }

  void onPressDelete(BuildContext context) {
    final db = locator<NewsService>();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            'Delete News',
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Would you like to delete this news?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                child: Text("No")),
            TextButton(
                onPressed: () async {
                  bool isDeleted = await db.deleteNews(this.news.id);
                  if (isDeleted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Text("Yes")),
          ],
        );
      },
    );
  }
}
