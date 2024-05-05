import 'package:flutter/material.dart';
import 'package:togu_yemekhane/widget/menu_list.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    required this.weekDayIndex,
    required this.tabController,
  });

  final int weekDayIndex;
  final TabController tabController;

  bool _isToday(int index) => index == weekDayIndex;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        MenuList(i: 0, isToday: _isToday(0)),
        MenuList(i: 1, isToday: _isToday(1)),
        MenuList(i: 2, isToday: _isToday(2)),
        MenuList(i: 3, isToday: _isToday(3)),
        MenuList(i: 4, isToday: _isToday(4)),
      ],
    );
  }
}
