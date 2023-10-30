import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:mercan_app/constant/app_constant.dart';

import '../data/shared_manager.dart';
import '../widget/yemekhane_widget.dart';

class GopMenu extends StatefulWidget {
  const GopMenu({super.key});

  @override
  State<GopMenu> createState() => _GopMenuState();
}

class _GopMenuState extends State<GopMenu> {
  SharedManager? _sharedManager;
  List<List<String>>? _data = List.empty(growable: true);

  Future<List<List<String>>> _init() async {
    // Her build edildiğinde listeyi temizle
    _data = List.empty(growable: true);

    // SharedManager Initialize
    _sharedManager = SharedManager();
    await _sharedManager!.init();

    // Kayıtlı veri var mı diye bak
    bool hasKey = _checkSaveData(SharedKeysGOP.dateGop);

    if (hasKey) {
      // Kayıtlı veriyi getir
      debugPrint('Kullanıcının kayıtlı verisi var ve kayıtlı veriyi getiriyorum.');
      return _getSavedData();
    } else {
      // İnternetten veri getir
      debugPrint('Kullanıcının kayıtlı verisi yok ve internetten veri çekiyorum.');
      await _getWebData();
      await _saveData();
    }

    return [
      ['N/A']
    ];
  }

  bool _checkSaveData(SharedKeysGOP key) {
    bool hasKey = _sharedManager!.hasKey(key);
    if (hasKey) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<List<String>>> _getSavedData() async {
    bool isOnline = await _hasNetwork();
    if (isOnline) {
      debugPrint('İnternet olduğu için günleri kontrol edip ona göre veriyi getiriyorum.');
      String weekDataOnline = await _getWeekDataOnline();
      String weekDataSaved = _getWeekDataSaved();
      if (weekDataOnline == weekDataSaved) {
        for (var i = 0; i < 5; i++) {
          _data!.add(_sharedManager!.getStringItems(SharedKeysGOP.values.elementAt(i)) ?? ['N/A']);
        }
      } else {
        _getWebData();
      }
    } else {
      debugPrint('İnternet olmadığı için en son kaydedilen veriyi getiriyorum.');
      for (var i = 0; i < 5; i++) {
        _data!.add(_sharedManager!.getStringItems(SharedKeysGOP.values.elementAt(i)) ?? ['N/A']);
      }
    }
    return _data!;
  }

  Future<void> _saveData() async {
    _sharedManager!.saveStringItem(SharedKeysGOP.dateGop, await _getWeekDataOnline());
    for (var i = 0; i < 5; i++) {
      _sharedManager!.saveStringItems(SharedKeysGOP.values.elementAt(i), _data!.elementAt(i));
    }
  }

  Future<void> _getWebData() async {
    final url = Uri.parse('https://sosyaltesisler.gop.edu.tr/yemekhane_menu.aspx');
    final response = await http.get(url);
    final body = response.body;
    final document = parser.parse(body);
    var data = document.getElementsByClassName('style19').toList();
    List<List<String>> returnData = [];

    for (var i = 5; i < data.length; i++) {
      // Her satırı al ve boşlukları temizle
      List<String> lines = data.elementAt(i).text.split('\n');
      lines = lines.map((line) => line.trim()).toList();

      // Boş satırları kaldır
      lines.removeWhere((line) => line.isEmpty);

      // Son iki satırı birleştir
      final lastElement = lines.removeLast();
      final secondLastElement = lines.removeLast();
      lines.add('$secondLastElement $lastElement');

      // Temizlenmiş metni gönderilecek veriye ekle
      returnData.add(lines);
    }

    _data = returnData;
  }

  Future<String> _getWeekDataOnline() async {
    final url = Uri.parse('https://sosyaltesisler.gop.edu.tr/yemekhane_menu.aspx');
    final response = await http.get(url);
    final body = response.body;
    final document = parser.parse(body);
    var data = document.getElementById('ContentPlaceHolder1_haftaBasi');
    return data!.text.toString();
  }

  String _getWeekDataSaved() {
    String weekData = _sharedManager!.getStringItem(SharedKeysGOP.dateGop) ?? 'N/A';
    return weekData;
  }

  Future<bool> _hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppConstants.titles['gop_menu']!)),
      body: FutureBuilder(
        future: _init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return YemekhaneWidget(data: _data!);
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
