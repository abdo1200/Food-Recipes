import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class RecipeView extends StatefulWidget {
  final String posturl;
  RecipeView({this.posturl});

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  String finalurl;
  final Completer<WebViewController> _controller= Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if(widget.posturl.contains('http://')){
      finalurl=widget.posturl.replaceAll('http://', 'https://');
    }else{
      finalurl=widget.posturl;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blueGrey, const Color(0xFF253236),]
              )
          ),
        ),
        backgroundColor: Colors.grey,
        title:  Row(
          mainAxisAlignment: kIsWeb?MainAxisAlignment.start:MainAxisAlignment.center,
          children: [
            Text('Food ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),),
            Text('Recipes ',style: TextStyle(color: Colors.orange,fontSize: 18,fontWeight: FontWeight.w500),),
            Icon(Icons.fastfood,color: Colors.orange,)
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height-100,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: widget.posturl,
                javascriptMode: JavascriptMode.unrestricted
                ,
                onWebViewCreated: (WebViewController webviewcon){
                  setState(() {
                    _controller.complete(webviewcon) ;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
