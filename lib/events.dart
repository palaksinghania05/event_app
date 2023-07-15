import 'dart:convert';
import 'dart:io';

import 'package:event_app/details.dart';
import 'package:event_app/search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Events extends StatefulWidget {
  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    getEvents();
    return Scaffold(
        body: Container(
            margin: EdgeInsets.fromLTRB(31, 48, 31, 0),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "Events",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          showSearch(context: context, delegate: Search());
                        },
                        child: Icon(Icons.search)),
                    Icon(Icons.more_vert)
                  ],
                )
              ]),
              SizedBox(
                height: 24,
              ),
              Expanded(child: FutureBuilder(builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                else {
                  return ListView.builder(
                      itemCount: _events.length,
                      itemBuilder: (BuildContext context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetail(_events[index]["id"].toString()))),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    _events[index]["banner_image"],
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
                                        DateFormat.MMMEd().format(
                                            DateTime.parse(
                                                _events[index]["date_time"])),
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
                                        DateFormat.jm().format(DateTime.parse(
                                            _events[index]["date_time"])),
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
                                    _events[index]["title"],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 11,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 15,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        _events[index]["venue_name"],
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.brightness_1,
                                        color: Colors.grey,
                                        size: 5,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        _events[index]["venue_city"] +
                                            " , " +
                                            _events[index]["venue_country"],
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ]),
                          ),
                        );
                      });
                }
              })),
              //       child: Column(
              //         children: [
              //
              //         ],
              //       ),
              //     )
              //   ],
              // ),
              // ),
            ])));
  }

  List _events = [];
  Future<void> getEvents() async {
    const api =
        "https://sde-007.api.assignment.theinternetfolks.works/v1/event";
    final HttpClientRequest request = await HttpClient().getUrl(Uri.parse(api));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    final HttpClientResponse response = await request.close();
    final String content = await response.transform(utf8.decoder).join();
    final List data = json.decode(content)["content"]['data'];

    setState(() {
      _events = data;
    });
  }
}
