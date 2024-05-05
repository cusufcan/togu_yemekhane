import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:togu_yemekhane/provider/splash_provider.dart';
import 'package:togu_yemekhane/util/app_helper.dart';

class MenuItem extends ConsumerWidget {
  const MenuItem({
    super.key,
    required this.i,
    required this.index,
    required this.isToday,
  });

  final int i;
  final int index;
  final bool isToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        side: isToday
            ? BorderSide(
                color: Colors.green[300]!,
                width: 2,
              )
            : BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(getIconData(index)),
        title: Text(
          ref
              .read(splashProvider)
              .dailyMeals[i]
              .menuList
              .elementAt(index)
              .toString(),
        ),
      ),
    );
  }
}
