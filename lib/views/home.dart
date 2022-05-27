import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_quran/views/login_page.dart';
import 'package:mobile_quran/views/surahDetail.dart';

class Home extends StatelessWidget {
  final String username;
  const Home({Key? key, required this.username}) : super(key: key);
  final String apiUrl = "https://quranapi.idn.sch.id/surah";

  Future<List<dynamic>> _fecthListSurah() async {
    var result = await http.get(Uri.parse(apiUrl));
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Mobile Al-Qur'an"),
        actions: [
          Container(
          padding: EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return LoginPage();
                    }),
                    (route) => false,
                  );
            },
            child: Icon(
      Icons.logout,
      color: Colors.white,
      size: 36.0,
    ),
          ),
        ),
        ],),
        body: Container(
            child: FutureBuilder<List<dynamic>>(
                future: _fecthListSurah(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SurahDetail(
                                            surahId: snapshot.data[index]
                                                    ['number']
                                                .toString(),
                                            surahName: snapshot.data[index]
                                                ['name'],
                                          )));
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16),
                                                child: _buildChip(index + 1),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4),
                                                    child: Text(
                                                      snapshot.data[index]
                                                          ['name'],
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  _buildDetail(
                                                      snapshot.data[index]
                                                          ['typeId'],
                                                      snapshot.data[index]
                                                          ['numberOfAyahs'])
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            snapshot.data[index]['asma'],
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Colors.green),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: 10,
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })));
  }
}

Widget _buildDetail(String location, int numberOfAyahs) {
  if (location == 'mekah') {
    return Text(
      'Mekah' + ' • ' + numberOfAyahs.toString() + ' Ayat',
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
  } else {
    return Text(
      'Madinah' + ' • ' + numberOfAyahs.toString() + ' Ayat',
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
  }
}

Widget _buildChip(int number) {
  return Chip(
    label: Container(
        width: 32,
        child: Align(
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.green,
              ),
            ))),
    backgroundColor: Colors.green[50],
    padding: EdgeInsets.all(12),
  );
}
