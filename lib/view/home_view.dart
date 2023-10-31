import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mercan_app/widget/update_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../constant/app_constant.dart';
import '../widget/subtitle_text.dart';
import '../widget/title_text.dart';
import 'gop_menu.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final Map<String, dynamic> _appList = {
    'Gop Menu': const GopMenu(),
  };

  final _icNavigate = Icons.navigate_next_outlined;

  void goToPage(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => _appList.values.elementAt(index)));
  }

  Future<void> _init(BuildContext context) async {
    bool hasNetwork = await _hasNetwork();
    if (hasNetwork) {
      var db = FirebaseFirestore.instance;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String buildNumber = packageInfo.buildNumber;
      await db.collection("update").get().then((event) async {
        var networkVersion = event.docs.elementAt(0).data()['version'];
        var currentVersion = buildNumber;
        if (networkVersion != currentVersion) {
          await showDialog(
            context: context,
            builder: (context) => WillPopScope(
              onWillPop: () => Future.value(false),
              child: const UpdateDialog(),
            ),
            barrierDismissible: false,
          );
        }
      });
    }
  }

  Future<bool> _hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.title),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _init(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: _appList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => goToPage(context, index),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TitleText(AppConstants.titles.values.elementAt(index + 1)),
                              Icon(_icNavigate),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SubtitleText(AppConstants.descriptions.values.elementAt(index)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
