import 'package:togu_yemekhane/model/day.dart';

class Data {
  Data({required this.dailyMeals});

  final List<DailyMeal> dailyMeals;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      dailyMeals: List<DailyMeal>.from(
          json['dailyMeals'].map((x) => DailyMeal.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dailyMeals': dailyMeals.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Data{dailyMeals: $dailyMeals}';
  }
}
