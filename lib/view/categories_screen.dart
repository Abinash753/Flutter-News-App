import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/view_model/news_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  //initializing the NewsViewModel to fetch data
  NewsViewModle newsViewModle = NewsViewModle();
//formatting the  date time
  final dateFormat = DateFormat('m E, y');
  //list of categories
  List<String> categoryList = [
    "General",
    "Entertainment",
    "Health",
    "Sports",
    "Business",
    "Technology"
  ];

  //default  category
  String caategoryName = "General";
  @override
  Widget build(BuildContext context) {
    //initializing the width and height of the sceeen
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          caategoryName = categoryList[index];
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                              color: caategoryName == categoryList[index]
                                  ? Colors.orange
                                  : const Color.fromARGB(255, 179, 172, 172),
                              borderRadius: BorderRadius.circular(18)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(
                              child: Text(categoryList[index].toString(),
                                  style: GoogleFonts.pollerOne(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  )),
                            ),
                          ),
                        ));
                  }),
            ),
            const SizedBox(
              height: 15,
            ),
            //future builder
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModle.fetchCategoriesNewsAPIs(caategoryName),
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
                                          snapshot.data!.articles![index]
                                              .source!.name
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
      ),
    );
  }
}
