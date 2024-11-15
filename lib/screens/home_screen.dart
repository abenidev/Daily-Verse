import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/models/verse.dart';
import 'package:daily_verse/providers/current_verse_list_provider.dart';
import 'package:daily_verse/utils/render_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';

final bookNumProvider = StateProvider<int>((ref) {
  return 1;
});

final chapterNumProvider = StateProvider<int>((ref) {
  return 1;
});

final verseNumProvider = StateProvider<int>((ref) {
  return 1;
});

final selectedVerseProvider = StateProvider<List<Verse>>((ref) {
  return [];
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
          initBookNum,
          initChapterNum,
          currentBookTransType,
        );
  }

  @override
  Widget build(BuildContext context) {
    List<Verse> verseList = ref.watch(currentVerseListStateNotifierProvider);
    int currentBookNum = ref.watch(bookNumProvider);
    int currentChapterNum = ref.watch(chapterNumProvider);
    BookTranslationType currentBookTransType = ref.watch(currentBookTransProvider);
    List<Verse> selectedVerses = ref.watch(selectedVerseProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                              padding: EdgeInsets.only(bottom: index == verseList.length - 1 ? 50.h : 5.h),
                              child: GestureDetector(
                                onTap: () {
                                  List<Verse> updatedSelectedVerses = [...selectedVerses];
                                  if (updatedSelectedVerses.contains(verse)) {
                                    updatedSelectedVerses.remove(verse);
                                  } else {
                                    updatedSelectedVerses.add(verse);
                                  }
                                  ref.read(selectedVerseProvider.notifier).state = [...updatedSelectedVerses];
                                },
                                child: Container(
                                  //!-----------for when verse is selected
                                  padding: selectedVerses.contains(verse) ? EdgeInsets.symmetric(horizontal: 2.h) : null,
                                  decoration: selectedVerses.contains(verse)
                                      ? BoxDecoration(
                                          color: Colors.orange[50],
                                          border: Border(
                                            left: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                                            right: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                                          ),
                                        )
                                      : null,
                                  //!-----------
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '   ${renderVerseNum(verse)}. ',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.6,
                                                ),
                                              ),
                                              TextSpan(
                                                text: renderVerseText(verse),
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.6,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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

            //footer
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: const BoxDecoration(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: IconButton(
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
                  ),
                  GestureDetector(
                    onTap: () {
                      //
                    },
                    child: Container(
                      decoration: const BoxDecoration(),
                      child: Text(
                        verseList.isNotEmpty ? verseList[0].bna : '',
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: IconButton(
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
