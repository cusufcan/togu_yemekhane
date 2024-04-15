part of 'home_view.dart';

abstract class _HomeViewModel extends State<HomeView> {
  SharedManager? _sharedManager;
  String? _weekDataGlobal;
  Data _mealData = Data(dailyMeals: []);

  Future<Data> _init() async {
    // Her build edildiğinde listeyi temizle
    _mealData = Data(dailyMeals: []);

    // SharedManager Initialize
    _sharedManager = SharedManager();
    await _sharedManager!.init();

    // Kayıtlı veri var mı diye bak
    bool hasKey = _checkSaveData(SharedKeysGOP.dateGop);

    if (hasKey) {
      // Kayıtlı veriyi getir
      return await _getSavedData();
    } else {
      // İnternetten veri getir
      await _getWebData();
      await _saveData();
    }

    return Data(
      dailyMeals: [
        DailyMeal(meals: ['N/A']),
      ],
    );
  }

  bool _checkSaveData(SharedKeysGOP key) {
    bool hasKey = _sharedManager!.hasKey(key);
    if (hasKey) {
      return true;
    } else {
      return false;
    }
  }

  Future<Data> _getSavedData() async {
    bool isOnline = await _hasNetwork();
    if (isOnline) {
      String weekDataOnline = await _getWeekDataOnline();
      String weekDataSaved = _getWeekDataSaved();
      _weekDataGlobal = weekDataOnline;
      if (weekDataOnline == weekDataSaved) {
        for (var i = 0; i < 5; i++) {
          _mealData.dailyMeals.add(DailyMeal(meals: []));
          _mealData.dailyMeals[i].meals.addAll(
            _sharedManager!.getStringItems(
                  SharedKeysGOP.values.elementAt(i),
                ) ??
                ['N/A'],
          );
        }
      } else {
        await _getWebData();
      }
    } else {
      String weekDataSaved = _getWeekDataSaved();
      _weekDataGlobal = weekDataSaved;
      for (var i = 0; i < 5; i++) {
        _mealData.dailyMeals[i].meals.addAll(
          _sharedManager!.getStringItems(
                SharedKeysGOP.values.elementAt(i),
              ) ??
              ['N/A'],
        );
      }
    }
    return _mealData;
  }

  Future<void> _saveData() async {
    if (_mealData.dailyMeals.isNotEmpty &&
        _mealData.dailyMeals.every(
          (element) => !element.meals.contains("Menü girilmemiş"),
        )) {
      if (_mealData.dailyMeals.first != DailyMeal(meals: ['N/A'])) {
        String weekDataOnline = await _getWeekDataOnline();
        _sharedManager!.saveStringItem(SharedKeysGOP.dateGop, weekDataOnline);
        _weekDataGlobal = weekDataOnline;
        for (var i = 0; i < 5; i++) {
          _sharedManager!.saveStringItems(
              SharedKeysGOP.values.elementAt(i), _mealData.dailyMeals[i].meals);
        }
      } else {
        debugPrint('Data NULL');
      }
    }
  }

  Future<void> _getWebData() async {
    final url =
        Uri.parse('https://sosyaltesisler.gop.edu.tr/yemekhane_menu.aspx');
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
      if (lines.length > 1) {
        final lastElement = lines.removeLast();
        final secondLastElement = lines.removeLast();
        lines.add('$secondLastElement $lastElement');
      }

      // Temizlenmiş metni gönderilecek veriye ekle
      returnData.add(lines);
    }

    for (var i = 0; i < returnData.length; i++) {
      _mealData.dailyMeals.add(DailyMeal(meals: returnData[i]));
    }

    debugPrint(_mealData.dailyMeals.toString());

    await _saveData();
  }

  Future<String> _getWeekDataOnline() async {
    final url =
        Uri.parse('https://sosyaltesisler.gop.edu.tr/yemekhane_menu.aspx');
    final response = await http.get(url);
    final body = response.body;
    final document = parser.parse(body);
    var data = document.getElementById('ContentPlaceHolder1_haftaBasi');
    return data!.text.toString();
  }

  String _getWeekDataSaved() {
    String weekData =
        _sharedManager!.getStringItem(SharedKeysGOP.dateGop) ?? 'N/A';
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
}
