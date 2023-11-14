import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../util/app_helper.dart';
import 'date_text.dart';

class YemekhaneWidget extends StatefulWidget {
  final List<List<String>>? data;
  final String? weekData;

  const YemekhaneWidget({
    super.key,
    required this.data,
    required this.weekData,
  });

  @override
  State<YemekhaneWidget> createState() => _YemekhaneWidgetState();
}

class _YemekhaneWidgetState extends State<YemekhaneWidget> {
  late AutoScrollController controller;
  int weekDay = 0;

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );
  }

  Future<void> _init() async {
    weekDay = _getWeekDay();
    await controller.scrollToIndex(weekDay != 0 ? weekDay - 1 : 0, preferPosition: AutoScrollPosition.begin);
    controller.highlight(weekDay);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) {
      return const Center(child: Text('N/A'));
    }
    return FutureBuilder(
      future: _init(),
      builder: (context, snapshot) {
        return Column(
          children: [
            const SizedBox(height: 20),
            DateText(widget.weekData.toString()),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                controller: controller,
                physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
                itemCount: widget.data!.length,
                itemBuilder: (context, index) {
                  return AutoScrollTag(
                    index: index,
                    controller: controller,
                    key: ValueKey(index),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          8, index == 0 || index == 4 ? 16 : 8, 8, index == 0 || index == 4 ? 16 : 8),
                      child: Row(
                        children: [
                          RotatedBox(
                            quarterTurns: -1,
                            child: Text(
                              getDayName(index),
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              elevation: 3,
                              color: weekDay != 0 && weekDay - 1 == index
                                  ? const Color.fromARGB(255, 184, 255, 184)
                                  : null,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  topLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(300),
                                  topRight: Radius.circular(300),
                                ),
                              ),
                              child: Column(
                                children: widget.data!
                                    .elementAt(index)
                                    .map(
                                      (e) => ListTile(
                                        title: Text(
                                          e.toString(),
                                          style: TextStyle(
                                            fontWeight: widget.data!
                                                        .elementAt(index)
                                                        .elementAt(widget.data!.elementAt(index).length - 1) ==
                                                    e
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  int _getWeekDay() {
    final DateTime now = DateTime.now();
    final int weekDay = now.weekday;
    return weekDay == 6 || weekDay == 7 ? 0 : weekDay;
  }
}
