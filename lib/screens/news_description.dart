import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../model_news.dart';

class NewsDescription extends StatefulWidget {
  final String? pageTitle;
  final String? url;

  NewsDescription(this.pageTitle, this.url);

  @override
  State<NewsDescription> createState() => _WebViewState();
}

class _WebViewState  extends State<NewsDescription>{
  double progress = 0;

  InAppWebViewController? controler;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          widget.pageTitle!,
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        centerTitle: true,

      ),
      body: Stack(children: [
        InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse(widget.url!),
          ),
          onWebViewCreated: (InAppWebViewController _controller) {
            controler = _controller;
          },
          onProgressChanged:
              (InAppWebViewController _controller, int _progress) {
            setState(() {
              progress = _progress / 100;
            });
          },
        ),
        progress < 1
            ? SizedBox(
          child: LinearProgressIndicator(
            color: Colors.pink,
            backgroundColor: Colors.white,
            value: progress,
          ),
        )
            : SizedBox()
      ]),
    );
    throw UnimplementedError();
  }
}


