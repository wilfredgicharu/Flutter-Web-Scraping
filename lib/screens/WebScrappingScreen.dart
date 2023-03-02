import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import '../model_news.dart';
import 'news_description.dart';

class WebScrappingScreen extends StatefulWidget {
  const WebScrappingScreen({Key? key}) : super(key: key);

  @override
  State<WebScrappingScreen> createState() => _WebScrappingScreenState();
}

class _WebScrappingScreenState extends State<WebScrappingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              largeTitle: Text('News'),
            ),
          ];
        },
        body: Container(
          child: FutureBuilder<List<ModelNews>>(
              future: _getNews(),
              builder: (context, snapshot) {
                if(snapshot.hasData){

                  List<ModelNews> news_list = snapshot.data!;

                  if(news_list.isNotEmpty){
                    //  return info_body(SheIQquestions().sample_news);
                    return info_body(news_list);
                  }else{
                    return
                      Center(child: Text('No news available'));
                  }

                }else if (snapshot.hasError){
                  return Center(child: Text('Error'),);

                }else{
                  return Center(child: CircularProgressIndicator(),);
                }

              }
          ),
        ),
      ),
    );
  }

  Widget info_body(List<ModelNews> health_resources) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // itemCount: NotificationData.health_resources_list.length,
      itemCount: health_resources.length,
      itemBuilder: (context, index) {
        int index_2 = index +1;

        ModelNews news =health_resources[index];
        // ModelNews();

        // //

        ModelNews news_next =
        health_resources.last == health_resources[index]
            ? health_resources[index]
            : health_resources[index_2];

        // Map item = NotificationData.health_resources_list[index];
        if (index == 0) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: news.image!,
                          fit: BoxFit.cover,
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            height: 160,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            height: 160,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: EdgeInsets.all(8),
                            decoration: new BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                              color: Colors.pink,
                            ),
                            padding: EdgeInsets.all(4),
                            width: 60,
                            height: 24,
                            child: Center(
                              child: Text(
                                'featured',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            news.title!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${news.body!}',
                            style: TextStyle(fontSize: 13),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16,),
            ],
          );
        } else {
          return Container(
            margin: EdgeInsets.only(bottom: 4,top: 8, left: 16, right: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewsDescription(news_next.title, news_next.link)));
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: CachedNetworkImage(
                      imageUrl: news.image!,
                      fit: BoxFit.cover,
                      height: 120,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                news.title!,
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${news.body}',
                                style: TextStyle(fontSize: 11),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<List<ModelNews>> _getNews() async {

    List<ModelNews> newsResults = [];

    try {
      final response = await http.Client()
          .get(Uri.parse("https://missdotafrica.digital/category/top-news/"));

      if (response.statusCode == 200) {
        var document = parse(response.body);
        var newsUnfiltered = document.getElementsByClassName('blog-post');

        for (var element in newsUnfiltered) {
          var body = element.getElementsByClassName('post-excerpt').first.text;
          var duration =
              element.getElementsByClassName('post-read-time').first.text;
          var date = element.getElementsByClassName('entry-date').first.text;
          var title = element
              .getElementsByClassName('entry-title')
              .first
              .children
              .first
              .text;
          var image = element
              .getElementsByClassName('inhype-post-image')
              .first
              .attributes['data-style']
              .toString();
          var link = element
              .getElementsByClassName('inhype-post-image-wrapper')
              .first
              .children
              .first
              .attributes['href']
              .toString();

          var refineImage = image.substring(22, image.length - 2);

          Map<String,dynamic> data ={
            "image": refineImage,
            "title": title,
            "date": date,
            "duration": duration,
            "body": body,
            "link": link
          };

          ModelNews news = ModelNews(data);

          newsResults.add(news);
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }

    return newsResults;
  }
}