import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:togu_yemekhane/provider/splash_provider.dart';
import 'package:togu_yemekhane/util/app_helper.dart';
import 'package:togu_yemekhane/widget/menu_widget.dart';
import 'package:togu_yemekhane/widget/week_text.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  int _weekDayIndex = -1;

  @override
  void initState() {
    super.initState();
    _weekDayIndex = getWeekDayIndex(DateTime.now());
    _tabController = TabController(
      length: 5,
      initialIndex: _weekDayIndex == -1 ? 0 : _weekDayIndex,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TOGÜ Yemekhane'),
          leading: Container(
            margin: const EdgeInsets.only(left: 12),
            width: 75,
            height: 75,
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.scaleDown,
            ),
          ),
          centerTitle: true,
          bottom: ref.watch(splashProvider).dailyMeals.isNotEmpty
              ? TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelStyle: Theme.of(context).textTheme.titleMedium,
                  tabs: const [
                    Tab(text: 'Pazartesi'),
                    Tab(text: 'Salı'),
                    Tab(text: 'Çarşamba'),
                    Tab(text: 'Perşembe'),
                    Tab(text: 'Cuma'),
                  ],
                )
              : null,
        ),
        body: ref.watch(splashProvider).dailyMeals.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: MenuWidget(
                        tabController: _tabController,
                        weekDayIndex: _weekDayIndex,
                      ),
                    ),
                    const WeekText(),
                  ],
                ),
              )
            : const Center(child: Text('Veri yok...')),
      ),
    );
  }
}
