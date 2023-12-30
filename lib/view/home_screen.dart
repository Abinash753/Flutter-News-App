import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/models/news_channels_headlines_model.dart';
import 'package:flutter_news_app/view/categories_screen.dart';
import 'package:flutter_news_app/view_model/news_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../resources/components/textStyle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//list of news type
enum FilterList { bbcNews, aryNews, independent, reuters, cnn, aljazeera }

class _HomeScreenState extends State<HomeScreen> {
  //initializing the NewsViewModel to fetch data
  NewsViewModle newsViewModle = NewsViewModle();
  //
  FilterList? selectedMenu;
//formatting the  date time
  final dateFormat = DateFormat('m E, y');

  //default  news id
  String changeName = "ary-news";

  @override
  Widget build(BuildContext context) {
    //initializing the width and height of the sceeen
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          //category  icon
          icon: Image.asset(
            "assets/category_icon.png",
          ),
          onPressed: () {
            Get.to(const CategoriesScreen());
          },
        ),
        centerTitle: true,
        title: Text(
          "News",
          style: FontStyles.screenTitleStyle,
        ),
        //popup menu button
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              icon: Icon(
                Icons.more_vert,
                color: Colors.red[400],
                size: 33,
              ),
              onSelected: (FilterList item) {
                setState(() {
                  selectedMenu = item;
                  //set the "name variable based on the selected enum value directly"
                  switch (item) {
                    case FilterList.bbcNews:
                      changeName = "bbc-news";
                      break;
                    case FilterList.aryNews:
                      changeName = "ary-news";
                      break;
                    case FilterList.aljazeera:
                      changeName = 'al-jazeera-english';
                      break;
                    default:
                      changeName = "bbc-news";
                  }
                  newsViewModle.fetchNewsChannelHeadlinesAPI(changeName);
                });

                setState(() {
                  //newsViewModle.fetchNewsChannelHeadlinesAPI();
                  selectedMenu = item;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<FilterList>>[
                    const PopupMenuItem<FilterList>(
                      value: FilterList.bbcNews,
                      child: Text("BBC News"),
                    ),
                    const PopupMenuItem<FilterList>(
                      value: FilterList.aryNews,
                      child: Text("Ary News"),
                    ),
                    const PopupMenuItem<FilterList>(
                      value: FilterList.aljazeera,
                      child: Text("Aljazeera"),
                    ),
                  ])
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: height * .40,
            width: width,
            color: const Color.fromARGB(255, 241, 239, 236).withOpacity(0.4),
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModle.fetchNewsChannelHeadlinesAPI(changeName),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 60,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());

                      return SizedBox(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: height * 0.6,
                              width: width * .99,
                              padding: EdgeInsets.symmetric(
                                horizontal: height * .02,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index]
                                              .urlToImage !=
                                          null
                                      ? snapshot
                                          .data!.articles![index].urlToImage
                                          .toString()
                                      : 'https://i.pinimg.com/474x/97/aa/84/97aa847d061a14894178805f1d551500.jpg',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(child: spinKit2),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            //
                            Positioned(
                              bottom: 13,
                              left: 23,
                              child: Card(
                                elevation: 5,
                                color: Color.fromARGB(255, 235, 231, 225)
                                    .withOpacity(0.7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                //
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  alignment: Alignment.bottomCenter,
                                  height: height * .20,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width * 0.65,
                                        //title
                                        child: Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      //
                                      const Spacer(),
                                      SizedBox(
                                        width: width * 0.65,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            //source
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            //date and time
                                            Text(
                                              dateFormat.format(dateTime),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          //bottom scroll  view of the news
          Padding(
            padding: const EdgeInsets.all(17.0),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModle.fetchCategoriesNewsAPIs("General"),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 60,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  );
                } else {
                  return ListView.builder(
                    //scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot
                          .data!.articles![index].publishedAt
                          .toString());
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 13),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: snapshot
                                    .data!.articles![index].urlToImage
                                    .toString(),
                                fit: BoxFit.cover,
                                height: height * .17,
                                width: width * .3,
                                placeholder: (context, url) => Container(
                                  child: const SpinKitCircle(
                                    size: 60,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            //
                            Expanded(
                                child: Container(
                              height: height * .17,
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                children: [
                                  //title of the news
                                  Text(
                                    snapshot.data!.articles![index].title
                                        .toString(),
                                    maxLines: 3,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),
                                  //
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //news source name
                                      Text(
                                        snapshot
                                            .data!.articles![index].source!.name
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                      //date
                                      Text(
                                        dateFormat.format(dateTime),
                                        style: GoogleFonts.poppins(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

//
const spinKit2 = SpinKitFadingCircle(
  color: Colors.green,
  size: 50,
);
