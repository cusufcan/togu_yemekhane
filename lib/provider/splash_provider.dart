import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:togu_yemekhane/data/shared_manager.dart';
import 'package:togu_yemekhane/model/data.dart';
import 'package:togu_yemekhane/model/menu.dart';

class SplashNotifier extends StateNotifier<Data> {
  SplashNotifier() : super(Data(dailyMeals: [], week: 'week'));

  late final SharedManager _manager = SharedManager();

  Future<void> fetchData() async {
    // veriyi temizle
    state.dailyMeals.clear();

    // sharedmanager baslat
    await _manager.init();

    debugPrint(_manager.hasKey(SharedKeys.date).toString());

    // internet var mi kontrol et
    bool isOnline = await _hasNetwork();
    if (isOnline) {
      // internetten hafta verisini getir
      await _getWeekDataOnline();

      // kayit var mi kontrol et
      if (_manager.hasKey(SharedKeys.date)) {
        // son kayitli hafta verisini getir
        String localWeek = _manager.getStringItem(SharedKeys.date)!;

        // kayitli veri ile internet verisi esit mi kontrol et
        if (localWeek == state.week) {
          // son kayitli veriyi getir
          await _getSavedData();
        } else {
          // internetten veri getir
          await _getWebData();
        }
      } else {
        // internetten veri getir
        await _getWebData();
      }
    } else {
      debugPrint('No internet connection');
      // yoksa son kayitli veriyi varsa getir
      if (_manager.hasKey(SharedKeys.date)) {
        state.week = _manager.getStringItem(SharedKeys.date)!;
        for (var i = 0; i < 5; i++) {
          state.dailyMeals.add(
            Menu(
              menuList: _manager.getStringItems(SharedKeys.values[i])!,
            ),
          );
        }
      }
    }
  }

  Future<void> _getWebData() async {
    debugPrint('getWebData');
    final url =
        Uri.parse('https://sosyaltesisler.gop.edu.tr/yemekhane_menu.aspx');
    try {
      final response = await http.get(url).timeout(
            const Duration(seconds: 15),
          );
      final document = parser.parse(response.body);
      var data = document.getElementsByClassName('style19').toList();
      _filterData(data);
    } on TimeoutException catch (_) {
      if (_manager.hasKey(SharedKeys.date)) _getSavedData();
    }
  }

  void _filterData(List data) async {
    for (var i = 5; i < data.length; i++) {
      // Her satırı al ve boşlukları temizle
      List<String> lines = data.elementAt(i).text.split('\n');
      lines = lines.map((line) => line.trim()).toList();

      // Boş satırları kaldır
      lines.removeWhere((line) => line.isEmpty);

      // Son iki satırı birleştir
      if (lines.length > 1) {
        final lastElement = lines.removeLast();
        final secondLastElement = lines.removeLast();
        lines.add('$secondLastElement $lastElement');
      }

      state.dailyMeals.add(Menu(menuList: lines));
    }

    // veriyi kaydet
    await _saveData();

    final db = FirebaseFirestore.instance;
    await db.collection('menus').doc(state.week).set(
      {
        '0 pzt': state.dailyMeals[0].menuList,
        '1 sal': state.dailyMeals[1].menuList,
        '2 crs': state.dailyMeals[2].menuList,
        '3 prs': state.dailyMeals[3].menuList,
        '4 cum': state.dailyMeals[4].menuList,
      },
    );
  }

  Future<void> _getWeekDataOnline() async {
    debugPrint('getWeekDataOnline');
    final url =
        Uri.parse('https://sosyaltesisler.gop.edu.tr/yemekhane_menu.aspx');
    final response = await http.get(url);
    final body = response.body;
    final document = parser.parse(body);
    var data = document.getElementById('ContentPlaceHolder1_haftaBasi');
    state.week = data!.text.toString();
  }

  Future<bool> _hasNetwork() async {
    debugPrint('hasNetwork');
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> _saveData() async {
    debugPrint('saveData');
    for (var i = 0; i < state.dailyMeals.length; i++) {
      await _manager.saveStringItems(
        SharedKeys.values[i],
        state.dailyMeals[i].menuList,
      );
    }
    await _manager.saveStringItem(SharedKeys.date, state.week);
  }

  Future<void> _getSavedData() async {
    debugPrint('getSavedData');
    for (var i = 0; i < 5; i++) {
      state.dailyMeals.add(
        Menu(
          menuList: _manager.getStringItems(SharedKeys.values[i])!,
        ),
      );
    }
  }
}

final splashProvider = StateNotifierProvider<SplashNotifier, Data>((ref) {
  return SplashNotifier();
});
