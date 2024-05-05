import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:togu_yemekhane/provider/splash_provider.dart';
import 'package:togu_yemekhane/widget/menu_item.dart';

class MenuList extends ConsumerWidget {
  const MenuList({
    super.key,
    required this.i,
    required this.isToday,
  });

  final int i;
  final bool isToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: List.generate(
        ref.watch(splashProvider).dailyMeals[i].menuList.length,
        (index) => MenuItem(
          i: i,
          index: index,
          isToday: isToday,
        ),
      ),
    );
  }
}
