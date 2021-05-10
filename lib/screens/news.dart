import 'package:climbing_gym_app/models/News.dart';
import 'package:climbing_gym_app/services/databaseService.dart';
import 'package:climbing_gym_app/widgets/newsCard.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:provider/provider.dart';

const polyDark = Color(0x121212);

class NewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var news = Provider.of<List<News>>(context);
    print("the news:" + news.toString());
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Constants.polyGreen,
        ),
        body: Container(
            color: Constants.polyDark,
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: news.length,
                itemBuilder: (BuildContext context, int index) {
                  print("aha: " + news.toString());
                  return Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: NewsCard(
                        news: news[index],
                      ));
                }))
        /*
          child: ChangeNotifierProvider<NewsService>(
              create: (context) => NewsService(),
              child: Consumer<NewsService>(
                builder: (context, newsService, child) {
                  return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: newsService.newsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: NewsCard(
                              news: News(
                                  publishDate: DateTime.utc(2021, 5, 5),
                                  creator:
                                      '${newsService.newsList[index].creator}',
                                  text: '${newsService.newsList[index].text}',
                                  imageUrl:
                                      '${newsService.newsList[index].imageUrl}')),
                        );
                      });
                },
              ))),
              */
        );
  }
}
