import 'package:flutter/material.dart';

import '../constant/app_constant.dart';
import 'gop_menu.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final Map<String, dynamic> _appList = {
    'Gop Menu': const GopMenu(),
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
      body: ListView.separated(
        itemCount: _appList.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppConstants.horizontalPaddingNormal),
            title: Text(_appList.keys.elementAt(index)),
            trailing: Icon(_icNavigate),
            onTap: () => goToPage(context, index),
          );
        },
      ),
    );
  }
}
