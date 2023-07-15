import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class EventDetail extends StatefulWidget {
  String id;
  EventDetail(this.id);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    getDetails();
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Event Details",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          actions: [
            Icon(
              Icons.bookmark,
              color: Colors.white,
            )
          ],
          backgroundColor: Colors.transparent,
        ),
        body: FutureBuilder(builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.hasError)
            return CircularProgressIndicator();
          else {
            return Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(_detail["banner_image"]))),
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _detail['title'],
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Image(
                                image: NetworkImage(_detail["organiser_icon"]),
                                width: 54,
                                height: 52,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _detail["organiser_name"],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    "Organiser",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: Colors.blue,
                                size: 50,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat.yMMMMd().format(
                                        DateTime.parse(_detail["date_time"])),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    DateFormat.EEEE().format(DateTime.parse(
                                            _detail["date_time"])) +
                                        " , " +
                                        DateFormat.jm().format(DateTime.parse(
                                            _detail["date_time"])),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 50,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _detail["venue_name"],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    _detail["venue_city"] +
                                        " , " +
                                        _detail["venue_country"],
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Text(
                            "About Event",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _detail["description"],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        ]),
                  ),
                ),
                Flexible(
                    child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "BOOK NOW",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ))
              ],
            );
          }
        }));
  }

  Map _detail = {};

  Future<void> getDetails() async {
    String api =
        "https://sde-007.api.assignment.theinternetfolks.works/v1/event/${widget.id}";
    final HttpClientRequest request = await HttpClient().getUrl(Uri.parse(api));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    final HttpClientResponse response = await request.close();
    final String content = await response.transform(utf8.decoder).join();
    final Map data = json.decode(content)["content"]["data"];
    //print(data);
    setState(() {
      _detail = data;
      //   print(_detail);
    });
  }
}
