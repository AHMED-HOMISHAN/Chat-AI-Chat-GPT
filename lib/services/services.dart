// ignore_for_file: deprecated_member_use

import 'package:chatgpt_course/services/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/constants.dart';

class Services {
  static Future<void> showModalSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(
                    width: 60,
                    child: Image.asset(
                      AssetsManager.userImage,
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        await Share.share(
                            'https://play.google.com/store/apps/details?id=com.chatAI.AH',
                            subject: 'Chat AI');
                      },
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Row(
                            children: const [
                              Icon(Icons.share_outlined),
                              Spacer(),
                              Text(
                                "مشاركة التطبيق",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        await launch(
                            'https://play.google.com/store/apps/details?id=com.online.projects');
                      },
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            " تطبيق مشاريعك ",
                            style: TextStyle(fontSize: 15),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () async {
                        await launch(
                            'https://play.google.com/store/apps/details?id=com.chatAI.AH');
                      },
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Row(
                                children: const [
                                  Icon(Icons.star_half_rounded),
                                  Center(
                                    child: Text(
                                      "   تقييم التطبيق   ",
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                    const Spacer(),
                  ],
                )
              ],
            ),
          );
        });
  }
}
