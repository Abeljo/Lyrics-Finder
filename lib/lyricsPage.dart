import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class lyricsPage extends StatefulWidget {
  const lyricsPage({Key? key}) : super(key: key);

  @override
  State<lyricsPage> createState() => _lyricsPageState();
}

class _lyricsPageState extends State<lyricsPage> {
  final _artName = TextEditingController();
  final _songName = TextEditingController();
  String key = 'YOUR_API-KEY-HERE';
  String MusicLyrics = '';
  String artistName = '';
  String songName = '';
  String date = '';
  String imgURL = '';
  findLyrics() async {
    var url =
        Uri.parse('https://genius.p.rapidapi.com/search?q=${_songName.text}');
    var response = await http.get(url, headers: {
      'x-rapidapi-key': key,
      'x-rapidapi-host': 'genius.p.rapidapi.com'
    });
    var jsonData = jsonDecode(response.body);
    var lUrl = Uri.parse(
        'https://api.lyrics.ovh/v1/${_artName.text}/${_songName.text}');
    var lResponse = await http.get(lUrl);
    var lData = jsonDecode(lResponse.body);

    setState(() {
      MusicLyrics = lData['lyrics'];
      artistName = jsonData['response']['hits'][0]['result']['artist_names'];
      songName = jsonData['response']['hits'][0]['result']['title'];
      date =
          jsonData['response']['hits'][0]['result']['release_date_for_display'];
      imgURL = jsonData['response']['hits'][0]['result']
          ['header_image_thumbnail_url'];
    });

    print(lData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lyrics Searching app'),
      ),
      body: _artName.text.isEmpty && _songName.text.isEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 320,
                    width: double.infinity,
                    child: Image.network(
                      'https://media3.giphy.com/media/YgsGYbakNrZg3sVmop/giphy.gif?cid=ecf05e47br8hyny4uktmqem9l4pvpf6hfpr6bxiqtiu3c1nm&rid=giphy.gif&ct=g',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: TextField(
                      controller: _songName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter the song name',
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 2, left: 20, right: 20, bottom: 10),
                    child: TextField(
                      controller: _artName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter the Artist name',
                      ),
                    ),
                  ),
                  Center(
                    child: ElevatedButton.icon(
                        onPressed: () {
                          findLyrics();
                        },
                        
                        icon: const Icon(Icons.search),
                        label: const Text("Find Lyrics")),
                  )
                ],
              ),
            )
          : Column(
              children: [
                Container(
                    height: 180,
                    color: Colors.grey.withOpacity(0.3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.network(
                          imgURL,
                          height: 180,
                          width: 180,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Artist Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              Text(artistName),
                              const Text(
                                'Song Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              Text(songName),
                              const Text(
                                'Released Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              Text(date),
                            ],
                          ),
                        )
                      ],
                    )),
                ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _artName..clear();
                        _songName.clear();
                      });
                    },
                    icon: Icon(Icons.clear_all),
                    label: Text('Clear Result')),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                    child: SingleChildScrollView(
                      child: Text(MusicLyrics),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
