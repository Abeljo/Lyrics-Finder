import 'dart:convert';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class mainHome extends StatefulWidget {
  const mainHome({Key? key}) : super(key: key);

  @override
  State<mainHome> createState() => _mainHomeState();
}

class _mainHomeState extends State<mainHome> {
  String api_key = '1df9cde0b4msh32e5649b22d64dcp106545jsn981053cf8bcb';
  String key = 'a498a7aa96msh88f9efb0833c935p1dd7f8jsne64f7b887e8e';

  final TextEditingController _controller = TextEditingController();

  String artistName = '';
  String songName = '';
  //String lyrics = '';
  String date = '';
  String imgURL = '';
  String lyricsData = '';

  Future getLyrics() async {
    var url =
        Uri.parse('https://genius.p.rapidapi.com/search?q=${_controller.text}');
    var response = await http.get(url, headers: {
      'x-rapidapi-key': key,
      'x-rapidapi-host': 'genius.p.rapidapi.com'
    });
    var jsonData = jsonDecode(response.body);

    var lUrl = Uri.parse('https://api.lyrics.ovh/v1/eminem/stan');
    var lResponse = await http.get(lUrl);
    var lData = jsonDecode(lResponse.body);

    setState(() {
      artistName = jsonData['response']['hits'][0]['result']['artist_names'];
      songName = jsonData['response']['hits'][0]['result']['title'];
      date =
          jsonData['response']['hits'][0]['result']['release_date_for_display'];
      imgURL = jsonData['response']['hits'][0]['result']
          ['header_image_thumbnail_url'];
      lyricsData = lData['lyrics'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                getLyrics();
              },
              child: const Text('Get Lyrics'),
            ),
          ),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
          Text(artistName),
          Text(songName),
          imgURL.isEmpty ? const Text('Waiting ...') : Image.network(imgURL),
          Text(date),
          Text(lyricsData),
        ],
      ),
    );
  }
}
