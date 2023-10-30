import 'package:flutter/material.dart';

import '../constant/app_constant.dart';
import '../widget/subtitle_text.dart';
import '../widget/title_text.dart';
import 'gop_menu.dart';
import 'hastane_menu.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final Map<String, dynamic> _appList = {
    'Gop Menu': const GopMenu(),
    'Hastane Menu': const HastaneMenu(),
  };

  final _icNavigate = Icons.navigate_next_outlined;

  void goToPage(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => _appList.values.elementAt(index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.title),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: _appList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => goToPage(context, index),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleText(AppConstants.titles.values.elementAt(index + 1)),
                        Icon(_icNavigate),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SubtitleText(AppConstants.descriptions.values.elementAt(index)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
