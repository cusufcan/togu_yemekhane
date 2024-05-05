import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:togu_yemekhane/provider/splash_provider.dart';

class WeekText extends ConsumerWidget {
  const WeekText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime week =
        DateFormat('dd.MM.yyyy').parse(ref.watch(splashProvider).week);
    String weekData =
        '${DateFormat('dd.MM.yyyy').format(week)} - ${DateFormat('dd.MM.yyyy').format(week.add(const Duration(days: 4)))}';
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          weekData,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
