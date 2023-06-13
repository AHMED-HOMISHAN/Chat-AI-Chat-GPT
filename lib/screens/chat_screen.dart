// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:io';

import 'package:chatgpt_course/constants/constants.dart';
import 'package:chatgpt_course/providers/chats_provider.dart';
import 'package:chatgpt_course/services/services.dart';
import 'package:chatgpt_course/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../constants/api_consts.dart';
import '../providers/models_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  bool isonline = false;
  bool isload = false;

  BannerAd? bannerAd;
  late final RewardedAd rewardedAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-6324222194091400/2212573052",
      listener: BannerAdListener(
        onAdLoaded: ((ad) {
          setState(() {
            isload = true;
          });
        }),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );
    bannerAd!.load();
  }

  Future<void> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isonline = true;
        });
      } else {
        setState(() {
          isonline = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isonline = false;
      });
    }
  }

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    hasNetwork();
    initi();
    _loadRewardedAd();
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: "ca-app-pub-6324222194091400/1175108966",
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdFailedToLoad: (LoadAdError error) {},
          onAdLoaded: (RewardedAd ad) {
            rewardedAd = ad;
            _setFullScrennContentCallback();
          }),
    );
  }

  void _setFullScrennContentCallback() {
    if (RewardedAd == null) return;

    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: ((RewardedAd ad) {}),
      onAdDismissedFullScreenContent: ((RewardedAd ad) {
        ad.dispose();
      }),
      onAdFailedToShowFullScreenContent: ((RewardedAd ad, error) {
        ad.dispose();
      }),
      onAdImpression: (ad) {},
    );
  }

  // void showRewardedAd() {
  //   rewardedAd.show(
  //       onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
  //     num amount = rewardItem.amount;
  //   });
  // }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      hasNetwork();
      if (_listScrollController.position.pixels !=
          _listScrollController.position.maxScrollExtent) {
        setState(() {
          scrollListToEND();
        });
      } else {
        setState(() {});
      }
    });

    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    if (isonline) {
      initi();
      return Scaffold(
        appBar: AppBar(
          elevation: 2,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.botImage),
          ),
          title: const Text("Chat AI"),
          actions: [
            IconButton(
              onPressed: () async {
                await Services.showModalSheet(context: context);
              },
              icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              isload
                  ? SizedBox(
                      height: 50,
                      child: AdWidget(
                        ad: bannerAd!,
                      ))
                  : const SizedBox(),
              Flexible(
                child: ListView.builder(
                    controller: _listScrollController,
                    itemCount:
                        chatProvider.getChatList.length, //chatList.length,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                        msg: chatProvider
                            .getChatList[index].msg, // chatList[index].msg,
                        chatIndex: chatProvider.getChatList[index]
                            .chatIndex, //chatList[index].chatIndex,
                        shouldAnimate:
                            chatProvider.getChatList.length - 1 == index,
                      );
                    }),
              ),
              if (_isTyping) ...[
                const SpinKitThreeBounce(
                  color: Colors.white,
                  size: 18,
                ),
              ],
              const SizedBox(
                height: 15,
              ),
              Material(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value) async {
                            await sendMessageFCT(
                                modelsProvider: modelsProvider,
                                chatProvider: chatProvider);
                          },
                          decoration: const InputDecoration.collapsed(
                              hintText: "Chat AI",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: IconButton(
                              onPressed: () async {
                                await sendMessageFCT(
                                    modelsProvider: modelsProvider,
                                    chatProvider: chatProvider);
                                //  showRewardedAd();
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Color.fromARGB(255, 90, 89, 89),
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            width: 350,
            height: 350,
            child: Center(
                child: Column(
              children: [
                const Spacer(),
                SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset(AssetsManager.openaiLogo)),
                const Spacer(),
                const Text(
                  "تاكد من اتصال لك بالانترنت",
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
              ],
            )),
          ),
        ),
      );
    }
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: TextWidget(
            label: "لا يمكن إرسال أكثر من رسالة في نفس الوقت",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: TextWidget(
            label: "لا يمكن إرسال رسالة فارغة",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;

        scrollListToEND();

        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });

      if (_listScrollController.position.pixels !=
          _listScrollController.position.maxScrollExtent) {
        setState(() {
          scrollListToEND();
        });
      }
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);

      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: TextWidget(
            label: "error $error",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );

      // log("error ");
    } finally {
      setState(() {
        scrollListToEND();

        _isTyping = false;
      });
    }
  }
}
