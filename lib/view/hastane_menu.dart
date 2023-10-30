import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:mercan_app/constant/app_constant.dart';

import '../data/shared_manager.dart';
import '../widget/hastane_widget.dart';

class HastaneMenu extends StatefulWidget {
  const HastaneMenu({super.key});

  @override
  State<HastaneMenu> createState() => _HastaneMenuState();
}

class _HastaneMenuState extends State<HastaneMenu> with TickerProviderStateMixin {
  SharedManager? _sharedManager;
  List<List<List<String>>>? _data = List.empty(growable: true);

  Future<List<List<List<String>>>> _init() async {
    // Her build edildiğinde listeyi temizle
    _data = List.empty(growable: true);
    _data!.add(List.empty(growable: true));
    _data!.add(List.empty(growable: true));

    // SharedManager Initialize
    _sharedManager = SharedManager();
    await _sharedManager!.init();

    if (!_sharedManager!.hasKeyGlobal(SharedKeysGlobal.build5Last)) {
      await _sharedManager!.clearAll();
      _sharedManager!.saveStringItemGlobal(SharedKeysGlobal.build5Last, "true");
    }

    // Kayıtlı veri var mı diye bak
    bool hasKey = _checkSaveData(SharedKeysGOP.dateHospital);

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

    await _getWebData();

    return [
      [
        ['N/A']
      ]
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

  Future<List<List<List<String>>>> _getSavedData() async {
    bool isOnline = await _hasNetwork();
    if (isOnline) {
      debugPrint('İnternet olduğu için günleri kontrol edip ona göre veriyi getiriyorum.');
      String weekDataOnline = await _getWeekDataOnline();
      String weekDataSaved = _getWeekDataSaved();
      if (weekDataOnline == weekDataSaved) {
        for (var i = 6; i < 13; i++) {
          _data!.elementAt(0).add(_sharedManager!.getStringItems(SharedKeysGOP.values.elementAt(i)) ?? ['N/A']);
        }
        for (var i = 13; i < 20; i++) {
          _data!.elementAt(1).add(_sharedManager!.getStringItems(SharedKeysGOP.values.elementAt(i)) ?? ['N/A']);
        }
      } else {
        _getWebData();
      }
    } else {
      debugPrint('İnternet olmadığı için en son kaydedilen veriyi getiriyorum.');
      for (var i = 6; i < 13; i++) {
        _data!.elementAt(0).add(_sharedManager!.getStringItems(SharedKeysGOP.values.elementAt(i)) ?? ['N/A']);
      }
      for (var i = 13; i < 20; i++) {
        _data!.elementAt(1).add(_sharedManager!.getStringItems(SharedKeysGOP.values.elementAt(i)) ?? ['N/A']);
      }
    }
    return _data!;
  }

  Future<void> _saveData() async {
    if (_data != null) {
      _sharedManager!.saveStringItem(SharedKeysGOP.dateHospital, await _getWeekDataOnline());
      int a = 6;
      for (var i = 0; i < 7; i++) {
        _sharedManager!.saveStringItems(SharedKeysGOP.values.elementAt(a), _data!.elementAt(0).elementAt(i));
        a++;
      }
      for (var i = 0; i < 7; i++) {
        _sharedManager!.saveStringItems(SharedKeysGOP.values.elementAt(a), _data!.elementAt(1).elementAt(i));
        a++;
      }
    } else {
      debugPrint('Data NULL');
    }
  }

  Future<void> _getWebData() async {
    final url = Uri.parse('https://hastane.gop.edu.tr/YemekListesi.aspx');
    final response = await http.get(url);
    final body = response.body;
    final document = parser.parse(body);
    List<String> data = document.getElementsByTagName('li').map((e) => e.text).toList();

    List<List<List<String>>> returnData = [[], []];

    // Öğle yemeği menüsünü bir diziye ata
    for (var i = 6; i < 41; i += 5) {
      List<String> subList = data.sublist(i, i + 5);
      returnData.elementAt(0).add(subList);
    }

    // Akşam yemeği menüsünü bir diziye ata
    for (var i = 41; i < 76; i += 5) {
      List<String> subList = data.sublist(i, i + 5);
      returnData.elementAt(1).add(subList);
    }

    _data = returnData;
  }

  Future<String> _getWeekDataOnline() async {
    final url = Uri.parse('https://hastane.gop.edu.tr/YemekListesi.aspx');
    final response = await http.get(url);
    final body = response.body;
    final document = parser.parse(body);
    var data = document.getElementsByClassName('w-100').toList();

    return data.elementAt(0).text.split('-').elementAt(0).trim();
  }

  String _getWeekDataSaved() {
    String weekData = _sharedManager!.getStringItem(SharedKeysGOP.dateHospital) ?? 'N/A';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppConstants.titles['hastane_menu']!),
          bottom: TabBar(
            splashFactory: NoSplash.splashFactory,
            splashBorderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            indicator: const BoxDecoration(
              color: Colors.transparent,
            ),
            tabs: [
              Tab(text: AppConstants.titles['ogle']),
              Tab(text: AppConstants.titles['aksam']),
            ],
          ),
        ),
        body: FutureBuilder(
          future: _init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TabBarView(
                children: [
                  Container(key: const PageStorageKey(0), child: HastaneWidget(data: _data!.elementAt(0))),
                  Container(key: const PageStorageKey(1), child: HastaneWidget(data: _data!.elementAt(1))),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          },
        ),
      ),
    );
  }
}
