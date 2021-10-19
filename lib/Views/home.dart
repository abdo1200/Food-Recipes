import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart'as http;
import 'package:apprecipes/Components/Background.dart';
import 'package:apprecipes/Models/recipeModel.dart';
import 'package:apprecipes/Views/recipe_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final formGlobalKey = GlobalKey<FormState>();
  List<RecipeModel> recipes=[];
  getRecipes(String query) async{
    recipes=[];
    String url = "https://api.edamam.com/search?q=$query=chicken&app_id=24193b66&app_key=b75ff52cef7bd7f22416474300affaee";
    var respone = await http.get(url);
    Map<String,dynamic> jsonData=jsonDecode(respone.body);
    jsonData["hits"].forEach((element){
      //print(element.asstoString());
      RecipeModel recipe=new RecipeModel();
      recipe= RecipeModel.fromMap(element['recipe']);
      recipes.add(recipe);
    });
    setState(() {
    });

  }
  TextEditingController textEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          backGround(),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30,left: 30,right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: kIsWeb?MainAxisAlignment.start:MainAxisAlignment.center,
                        children: [
                          Text('Food ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Colors.white),),
                          Text('Recipes ',style: TextStyle(color: Colors.orange,fontSize: 18,fontWeight: FontWeight.w500),),
                          Icon(Icons.fastfood,color: Colors.orange,)
                        ],
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2,vertical: 1),
                            color: Colors.orange,
                            child: Text('What ',style:TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold))
                          ),
                          Text(' will you cook today ?',style:TextStyle(fontSize: 18,color: Colors.white)),
                        ],
                      ), SizedBox(height: 30,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Expanded(
                              child: Form(
                                key: formGlobalKey,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter any ingridients';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Enter Ingridients",
                                      hintStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white.withOpacity(.5),
                                      )
                                  ),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white
                                  ),
                                  controller: textEditingController,
                                ),
                              ),
                            ),
                            SizedBox(width: 16,),
                            InkWell(
                              onTap: (){
                                if (formGlobalKey.currentState.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Processing Data')),
                                  );
                                  getRecipes(textEditingController.text);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 3,horizontal: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.orange,
                                ),
                                child: Icon(Icons.search,color: Colors.white,),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: recipes.isNotEmpty?GridView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ClampingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        mainAxisExtent: 200,
                        mainAxisSpacing: 10
                    ),
                    children: List.generate(recipes.length, (index){
                      return RecipieTile(
                        title: recipes[index].label,
                        desc:recipes[index].source,
                        imgUrl: recipes[index].image,
                        url: recipes[index].url,
                      );
                    }),

                  ):
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.asset('assets/icon.png',height: 200,width: 200,)),
                        SizedBox(height: 10,),
                        Text("No Recipes",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 20),)
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                        posturl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    colors: [Colors.orange, Colors.white],
                    begin: FractionalOffset.centerRight,
                    end: FractionalOffset.centerLeft),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.imgUrl,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 200,
                    padding: EdgeInsets.symmetric(horizontal: 7,vertical: 5),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.orange, Colors.white],
                            begin: FractionalOffset.centerRight,
                            end: FractionalOffset.centerLeft),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          widget.desc,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                            fontFamily: 'Overpass',),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
        ),
      ],
    );
  }
}

