class DailyMeal {
  DailyMeal({required this.meals});

  final List<String> meals;

  factory DailyMeal.fromJson(Map<String, dynamic> json) {
    return DailyMeal(
      meals: List<String>.from(json['meals']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meals': meals,
    };
  }

  @override
  String toString() {
    return 'DailyMeal{meals: $meals}';
  }
}
