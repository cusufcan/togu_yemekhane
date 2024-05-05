import 'package:togu_yemekhane/model/menu.dart';

class Data {
  final List<Menu> dailyMeals;
  String week;

  Data({required this.dailyMeals, required this.week});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      dailyMeals: List<Menu>.from(json['dailyMeals']),
      week: json['week'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyMeals': dailyMeals,
      'week': week,
    };
  }
}
