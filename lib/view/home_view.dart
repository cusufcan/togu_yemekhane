import 'dart:io';

import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constant/app_constant.dart';
import '../data/shared_manager.dart';
import '../widget/yemekhane_widget.dart';

part 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends _HomeViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.title),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return YemekhaneWidget(
              data: _data,
              weekData: weekData,
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }

  String? get weekData {
    String? reversedData = _weekDataGlobal?.split('.').reversed.join('-');
    if (reversedData != null) {
      DateTime tempDateFirst = DateTime.parse(reversedData);
      DateTime tempDateLast = tempDateFirst.add(const Duration(days: 4));
      return "${DateFormat('dd.MM.yyyy').format(tempDateFirst)} - ${DateFormat('dd.MM.yyyy').format(tempDateLast)}";
    }
    return null;
  }
}
