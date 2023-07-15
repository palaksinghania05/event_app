import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'details.dart';

class Search extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => Navigator.pop(context),
      icon: Icon(Icons.close)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.search),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: getFilterEvents(query: query),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (BuildContext context, index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetail('${data?[index]["id"]}'))),
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              '${data?[index]["banner_image"]}',
                              fit: BoxFit.fill,
                              height: 92,
                              width: 79,
                            )),
                        SizedBox(
                          width: 6,
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    DateFormat.MMMEd().format(DateTime.parse(
                                        '${data?[index]["date_time"]}')),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Icon(
                                    Icons.brightness_1,
                                    color: Colors.blue,
                                    size: 5,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    DateFormat.Hm().format(DateTime.parse(
                                        '${data?[index]["date_time"]}')),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${data?[index]["title"]}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ])
                      ])),
                );
              });
        });
  }

  Widget buildSuggestions(BuildContext context) {
    return Scaffold();
  }

  Future<List> getFilterEvents({required String query}) async {
    String api =
        "https://sde-007.api.assignment.theinternetfolks.works/v1/event?search=$query";
    final HttpClientRequest request = await HttpClient().getUrl(Uri.parse(api));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    final HttpClientResponse response = await request.close();
    final String content = await response.transform(utf8.decoder).join();
    final List data = json.decode(content)["content"]['data'];
    return data;
  }
}
