// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:html/parser.dart' as parser;
// import 'package:http/http.dart' as http;

class ImagesView extends StatefulWidget {
  final String query;
  const ImagesView({super.key, required this.query});

  @override
  State<ImagesView> createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  Future<List<String>> _init() async {
    List<String> imageUrls = List.empty(growable: true);

    // * YANDEX SEARCH WEB SCRAPPING (Kullanıcıyı bazen robot sanıyor.)
    // String query = widget.query;
    // final Uri url = Uri.parse('https://yandex.com/images/search?text=$query');
    // final response = await http.get(url);
    // final body = response.body;
    // final document = parser.parse(body);
    // final data = document.getElementsByTagName('img').toList();
    // if (data.length > 1) {
    //   for (var i = 1; i < 5; i++) {
    //     imageUrls.add(data.elementAt(i).attributes['src']!);
    //   }
    // } else {
    //   return ['//yandex.com/images/search?text=error'];
    // }

    // * PEXELS API (Türkçe dil sorunu var.)
    // const String apiKey = '4XqblWeuSSCCt2L7O8GkPvBZgZb659aW7gcL16vBjOeWYFtFqQlRIX0T';
    // String query = widget.query;
    // final url = Uri.parse('https://api.pexels.com/v1/search?query=$query Yemeği&per_page=3&locale=tr-TR');
    // final response = await http.get(url, headers: {'Authorization': apiKey});
    // final body = jsonDecode(response.body);
    // final List photos = body['photos'];

    // for (var photo in photos) {
    //   imageUrls.add(photo['src']['medium']);
    // }
    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
              itemBuilder: (context, index) {
                return Image.network(snapshot.data!.elementAt(index));
              },
            );
          }
        },
      ),
    );
  }
}
