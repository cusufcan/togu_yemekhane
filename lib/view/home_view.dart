import 'package:flutter/material.dart';

import '../constant/app_constant.dart';
import '../widget/subtitle_text.dart';
import '../widget/title_text.dart';
import 'gop_menu.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final Map<String, dynamic> _appList = {
    'Gop Menu': const GopMenu(),
  };

  final List<String> _descriptionList = [
    "Gaziosmanpaşa Üniversitesi'nin haftalık yemek menüsünü içeren liste. Üniversite öğrencileri ve personeli için sunulan günlük yemek seçenekleri hakkında detayları burada bulabilirsiniz.",
  ];

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
      body: ListView.separated(
        itemCount: _appList.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(20),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => goToPage(context, index),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleText(_appList.keys.elementAt(index)),
                        Icon(_icNavigate),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SubtitleText(_descriptionList.elementAt(index)),
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
