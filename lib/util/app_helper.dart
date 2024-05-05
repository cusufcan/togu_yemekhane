import 'package:flutter/material.dart';

String getDayName(int index) {
  switch (index) {
    case 0:
      return 'Pazartesi';
    case 1:
      return 'Salı';
    case 2:
      return 'Çarşamba';
    case 3:
      return 'Perşembe';
    case 4:
      return 'Cuma';
    case 5:
      return 'Cumartesi';
    case 6:
      return 'Pazar';
    default:
      return 'N/A';
  }
}

int getWeekDayIndex(DateTime date) {
  return date.weekday < 6 ? date.weekday - 1 : -1;
}

IconData getIconData(int index) {
  switch (index) {
    case 0:
      return Icons.soup_kitchen_outlined;
    case 1:
      return Icons.restaurant_outlined;
    case 2:
      return Icons.restaurant_outlined;
    case 3:
      return Icons.cake_outlined;
    case 4:
      return Icons.add_circle_outlined;
    default:
      return Icons.error_outline;
  }
}
