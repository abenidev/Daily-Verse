import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/models/verse.dart';
import 'package:daily_verse/providers/current_verse_list_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      _init();
    });
  }

  _init() {
    ref.read(currentVerseListStateNotifierProvider.notifier).setVerseList(
          ref,
          19, 119,
          // 1, 1,
          BookTranslationType.niv,
        );
  }

  List<Verse> highlightedVerses = [];

  String renderVerseText(Verse verse) {
    if (verse.hnu == null) {
      return verse.t;
    }
    String finalText = verse.t;
    for (int i = 0; i < verse.hnu!.floor(); i++) {
      finalText = '${finalText}\n';
    }
    return finalText;
  }

  @override
  Widget build(BuildContext context) {
    List<Verse> verseList = ref.watch(currentVerseListStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        // title: Text(verseList.isNotEmpty ? verseList[0].bna : ''),
        //!home_widget----------------------
        actions: [
          IconButton(
            onPressed: () async {
              //
              // await HomeWidget.saveWidgetData('appWidgetText', "New App Widget Text");
              // await HomeWidget.updateWidget(
              //   qualifiedAndroidName: "dev.abeni.daily_verse.HomeScreenWidget",
              //   androidName: "HomeScreenWidget",
              // );
            },
            icon: const Icon(Icons.restart_alt),
          ),
        ],
        //!home_widget----------------------
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: const BoxDecoration(),
                child: Text.rich(
                  TextSpan(
                    children: verseList.map(
                      (verse) {
                        return highlightedVerses.contains(verse)
                            ? TextSpan(
                                text: '${verse.v}. ${verse.t}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  background: Paint()..color = Theme.of(context).secondaryHeaderColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() => highlightedVerses.add(verse));
                                  },
                              )
                            : verse.v.contains(0)
                                ? TextSpan(
                                    text: renderVerseText(verse),
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : TextSpan(
                                    text: '${verse.v}. ${verse.t}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        setState(() => highlightedVerses.add(verse));
                                      },
                                  );
                      },
                    ).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(verseList.isNotEmpty ? verseList[0].bna : ''),
    //     //!home_widget----------------------
    //     // actions: [
    //     // IconButton(
    //     //   onPressed: () async {
    //     //     //
    //     //     await HomeWidget.saveWidgetData('appWidgetText', "New App Widget Text");
    //     //     await HomeWidget.updateWidget(
    //     //       qualifiedAndroidName: "dev.abeni.daily_verse.HomeScreenWidget",
    //     //       androidName: "HomeScreenWidget",
    //     //     );
    //     //   },
    //     //   icon: const Icon(Icons.restart_alt),
    //     // ),
    //     // ],
    //     //!home_widget----------------------
    //   ),
    //   body: SafeArea(
    //     child: Container(
    //       padding: EdgeInsets.only(left: 20.w, right: 20.w),
    //       decoration: const BoxDecoration(),
    //       child: NotificationListener<OverscrollIndicatorNotification>(
    //         onNotification: (overscroll) {
    //           overscroll.disallowIndicator();
    //           return true;
    //         },
    //         child: ListView.builder(
    //           itemCount: verseList.length,
    //           itemBuilder: (context, index) {
    //             final verse = verseList[index];
    //             String cleanedVerseText = verse.t;

    //             return GestureDetector(
    //               onTap: () {},
    //               child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     '${verse.v}.',
    //                     style: TextStyle(fontSize: 12.sp),
    //                   ),
    //                   Expanded(
    //                     child: Text(
    //                       cleanedVerseText,
    //                       style: TextStyle(fontSize: 17.sp, height: 1.8),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             );

    //             //
    //           },
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    //
  }
}
