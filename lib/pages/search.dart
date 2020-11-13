import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_movie/models/AllMovie.dart';
import 'package:flutter_movie/models/SearchResult.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class SearchPage extends StatefulWidget {
  @override
  State createState() {
    return _SearchState();
  }
}

class _SearchState extends State<SearchPage> {
  var _textController = TextEditingController();
  List<String> title = List();
  List<String> image = List();
  Map<int,Search> list;
  var poster;
  String imdbid;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    var mediaQueryData = MediaQuery.of(context);
    final double widthScreen = mediaQueryData.size.width;
    final double appBarHeight = kToolbarHeight;
    final double paddingTop = mediaQueryData.padding.top;
    final double paddingBottom = mediaQueryData.padding.bottom;
    final double heightScreen =
        mediaQueryData.size.height - paddingBottom - paddingTop - appBarHeight;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                height: size.height * 0.2,
                child: Stack(
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        height: size.height * 0.2 - 27,
                        decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(36),
                                bottomRight: Radius.circular(36))),
                        child: Row(
                          children: [
                            Text(
                              "Search Movie",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 54,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 4), // changes position of shadow
                              )
                            ]),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                    color: Colors.red.withOpacity(0.9),
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  //suffixIcon: SvgPicture.asset("icon/loupe.svg")
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                title.clear();
                                image.clear();
                                // var response = await http.get(
                                //     "https://www.omdbapi.com/?apikey=a1a70288&t=" +
                                //         _textController.text);
                                // var result = searchResultFromJson(response.body);
                                // print(response.body);
                                // poster = result.poster;
                                // imdbid = result.imdbId;
                                var all = await http.get(
                                    "https://www.omdbapi.com/?apikey=a1a70288&s=" +
                                        _textController.text);
                                var resultAllMovie = allMovieFromJson(all.body);
                                list = resultAllMovie.search.asMap();

                                print(all.body);
                                print(list[1].title);
                                for (var i = 0; i < list.length; i++) {
                                  print(list[i].poster);
                                  title.add(list[i].title);
                                  image.add(list[i].poster);
                                }
                                setState(() {});
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.red.withOpacity(0.9),
                                size: 20.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              // OutlineButton(
              //   onPressed: () async {
              //     title.clear();
              //     image.clear();
              //     // var response = await http.get(
              //     //     "https://www.omdbapi.com/?apikey=a1a70288&t=" +
              //     //         _textController.text);
              //     // var result = searchResultFromJson(response.body);
              //     // print(response.body);
              //     // poster = result.poster;
              //     // imdbid = result.imdbId;
              //     var all = await http.get(
              //         "https://www.omdbapi.com/?apikey=a1a70288&s=" +
              //             _textController.text);
              //     var resultAllMovie = allMovieFromJson(all.body);
              //     var list = resultAllMovie.search.asMap();
              //
              //     print(all.body);
              //     print(list[1].title);
              //     for (var i = 0; i < list.length; i++) {
              //       print(list[i].poster);
              //       title.add(list[i].title);
              //       image.add(list[i].poster);
              //     }
              //     setState(() {});
              //   },
              //   textColor: Colors.blue,
              //   borderSide: BorderSide(
              //       color: Colors.blue, width: 1.0, style: BorderStyle.solid),
              //   child: Text('Search',),
              // ),
              // (poster != null && poster != "N/A")
              //     ? GestureDetector(
              //         onTap: () async {
              //           String ws = 'https://202.28.34.250/IonicMovie/api/Movie/'+imdbid;
              //           var response = await http.get(ws,headers: {HttpHeaders.acceptHeader: 'application/json'});
              //           print(response.body);
              //         },
              //         child: Image.network(poster),
              //       )
              //     : Container()
            ],
          ),
          (list != null) ? ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: list
                .entries
                .map((e) => Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                      child: Card(
                        color: Colors.white12,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black12, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                e.value.poster,
                                height: 180,
                                width: 120,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Expanded(
                              child: Container(

                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        e.value.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Year release:   ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                              color: Colors.white,
                                              ),
                                        ),
                                        Text(
                                          e.value.year,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(
                                              color: Colors.white.withOpacity(0.7),
                                              ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "IMDBid:   ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                              color: Colors.white,
                                              ),
                                        ),
                                        Text(
                                          e.value.imdbId,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                              color: Colors.white.withOpacity(0.7),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ):Container(),
          // GridView.count(
          //   // Create a grid with 2 columns. If you change the scrollDirection to
          //   // horizontal, this produces 2 rows.
          //   physics: ClampingScrollPhysics(),
          //   childAspectRatio: 120/180,
          //   crossAxisCount: 3,
          //   crossAxisSpacing: 4.0,
          //   mainAxisSpacing: 8.0,
          //   shrinkWrap: true,
          //   scrollDirection: Axis.vertical,
          //   // Generate 100 widgets that display their index in the List.
          //   children: title.asMap().entries
          //       .map((e) => Card(
          //     color: Colors.white12,
          //                     shape: RoundedRectangleBorder(
          //                       side: BorderSide(color: Colors.black12, width: 1),
          //                       borderRadius: BorderRadius.circular(10),),
          //         child: Container(
          //     child: Column(
          //         children: [
          //
          //           Image.network(image[e.key],height: 180,
          //                                     width: 120,fit: BoxFit.fill,)
          //         ],
          //     ),
          //   ),
          //       )).toList(),
          // ),
        ],
      ),
    );
  }
}
