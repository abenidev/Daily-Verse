import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/models/verse.dart';
import 'package:daily_verse/providers/current_verse_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:styled_text_advance/styled_text_advance.dart';

final bookNumProvider = StateProvider<int>((ref) {
  return 1;
});

final chapterNumProvider = StateProvider<int>((ref) {
  return 1;
});

final verseNumProvider = StateProvider<int>((ref) {
  return 1;
});

final currentBookTransProvider = StateProvider<BookTranslationType>((ref) {
  return BookTranslationType.niv;
});

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
    int initBookNum = ref.read(bookNumProvider);
    int initChapterNum = ref.read(chapterNumProvider);
    BookTranslationType currentBookTransType = ref.read(currentBookTransProvider);

    ref.read(currentVerseListStateNotifierProvider.notifier).setVerseList(
          ref,
          19, 119,
          // initBookNum, initChapterNum,
          currentBookTransType,
        );
  }

  List<Verse> highlightedVerses = [];

  String renderHeadingText(Verse verse) {
    if (verse.hnu == null) {
      return verse.t;
    }

    String finalText = '';
    if (verse.v.contains(0) && verse.v.length > 1) {
      finalText = '\n${verse.t}';
    } else if (!verse.v.contains(0) && verse.v.isNotEmpty) {
      finalText = '\n${verse.t}';
    } else {
      finalText = verse.t;
    }

    for (int i = 0; (i < verse.hnu!.floor() && i < 2); i++) {
      finalText = '${finalText}\n';
    }
    return finalText;
  }

  String renderVerseNum(Verse verse) {
    if (verse.v.length == 1) {
      return '${verse.v[0]}';
    } else {
      return '${verse.v[0]} - ${verse.v[verse.v.length - 1]}';
    }
  }

  String renderVerseText(Verse verse) {
    return verse.t.replaceAll(RegExp(r'\*\w+'), '');
  }

  @override
  Widget build(BuildContext context) {
    List<Verse> verseList = ref.watch(currentVerseListStateNotifierProvider);
    int currentBookNum = ref.watch(bookNumProvider);
    int currentChapterNum = ref.watch(chapterNumProvider);
    BookTranslationType currentBookTransType = ref.watch(currentBookTransProvider);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(verseList.isNotEmpty ? verseList[0].bna : ''),
      //   actions: [
      //     //!home_widget----------------------
      //     IconButton(
      //       onPressed: () async {
      //         // await HomeWidget.saveWidgetData('appWidgetText', "New App Widget Text");
      //         // await HomeWidget.updateWidget(
      //         //   qualifiedAndroidName: "dev.abeni.daily_verse.HomeScreenWidget",
      //         //   androidName: "HomeScreenWidget",
      //         // );
      //       },
      //       icon: const Icon(Icons.restart_alt),
      //     ),
      //     //!home_widget----------------------
      //   ],
      // ),
      floatingActionButton: Container(
        decoration: BoxDecoration(color: Theme.of(context).canvasColor),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                if (currentChapterNum > 1) {
                  ref.read(chapterNumProvider.notifier).state = currentChapterNum - 1;
                  ref.read(currentVerseListStateNotifierProvider.notifier).setVerseList(
                        ref,
                        currentBookNum,
                        currentChapterNum,
                        currentBookTransType,
                      );
                }
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            IconButton(
              onPressed: () {
                ref.read(chapterNumProvider.notifier).state = currentChapterNum + 1;
                ref.read(currentVerseListStateNotifierProvider.notifier).setVerseList(
                      ref,
                      currentBookNum,
                      currentChapterNum,
                      currentBookTransType,
                    );
              },
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: Container(
            decoration: const BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: verseList.length,
                    itemBuilder: (context, index) {
                      Verse verse = verseList[index];

                      if (verse.hnu != null) {
                        if (verse.hnu == 1) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
                            child: Text(
                              renderVerseText(verse),
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 32.sp),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: Text(
                              renderVerseText(verse),
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
                            ),
                          );
                        }
                      }

                      return Padding(
                        padding: EdgeInsets.only(bottom: index == verseList.length - 1 ? 50.h : 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //!
                            // Text(
                            //   '${renderVerseNum(verse)}.',
                            //   style: TextStyle(
                            //     fontSize: 16.sp,
                            //     fontWeight: FontWeight.w600,
                            //     height: 1.8,
                            //   ),
                            // ),
                            // Expanded(
                            //   child: Text(
                            //     renderVerseText(verse),
                            //     style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, height: 1.8),
                            //   ),
                            // )

                            //!
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: StyledTextAdvance.selectable(
                                  text: "   <b>${renderVerseNum(verse)}</b>. ${renderVerseText(verse)}",
                                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, height: 1.8),
                                  tags: {
                                    'b': StyledTextAdvanceTag(
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        height: 1.8,
                                      ),
                                    ),
                                  },
                                ),
                                // child: Text(
                                //   "   ${renderVerseNum(verse)}. ${renderVerseText(verse)}",
                                //   style: TextStyle(
                                //     fontSize: 16.sp,
                                //     fontWeight: FontWeight.w400,
                                //     height: 1.8,
                                //   ),
                                // ),
                              ),
                            ),

                            //!styledText
                            // StyledTextAdvance.selectable(
                            //   text: "<s>${renderVerseNum(verse)}</s>",
                            //   tags: {
                            //     's': StyledTextAdvanceTag(
                            //       style: TextStyle(fontSize: 12.sp),
                            //     ),
                            //   },
                            // ),
                            // Expanded(
                            //   child: StyledTextAdvance.selectable(
                            //     text: renderVerseText(verse),
                            //     style: TextStyle(fontSize: 16.sp),
                            //     tags: {
                            //       'b': StyledTextAdvanceTag(
                            //         style: const TextStyle(fontWeight: FontWeight.bold),
                            //       ),
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
