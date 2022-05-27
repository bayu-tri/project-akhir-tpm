import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_quran/views/mySimplePlayer.dart';

class SurahDetail extends StatelessWidget {
  const SurahDetail({Key? key, required this.surahId, required this.surahName})
      : super(key: key);
  final String surahId;
  final String surahName;

  Future<List<dynamic>> _fetchSurah() async {
    var result = await http
        .get(Uri.parse("https://quranapi.idn.sch.id/surah/" + surahId));
    return json.decode(result.body)['ayahs'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(surahName)),
        body: Container(
            child: FutureBuilder<List<dynamic>>(
                future: _fetchSurah(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.hasData);
                  if (snapshot.hasData) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {},
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 0),
                                      child: _buildChip(index + 1),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Container(
                                        // color: Colors.amber,
                                        child: Text(
                                          snapshot.data[index]['ayahText'],
                                          style: TextStyle(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 12, 0, 12),
                                      child: Text(
                                          snapshot.data[index]['readText'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 24),
                                      child: Text(
                                          snapshot.data[index]['indoText'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600])),
                                    ),
                                    MySimplePlayer(
                                        asset: snapshot.data[index]['audio'])
                                  ],
                                ),
                              ),
                            ));
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
                fontSize: 16,
                color: Colors.green,
              ),
            ))),
    backgroundColor: Colors.green[50],
    padding: EdgeInsets.all(8),
  );
}
