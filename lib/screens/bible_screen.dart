import 'package:daily_verse/constants/app_nums.dart';
import 'package:daily_verse/data/amv_books.dart';
import 'package:daily_verse/data/books_data.dart';
import 'package:daily_verse/data/niv_books.dart';
import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/helpers/shared_prefs_helper.dart';
import 'package:daily_verse/models/app_data.dart';
import 'package:daily_verse/models/verse.dart';
import 'package:daily_verse/providers/current_verse_list_provider.dart';
import 'package:daily_verse/utils/render_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nb_utils/nb_utils.dart';

final bookNumProvider = StateProvider<int>((ref) {
  return defaultCurrentBookNum;
});

final chapterNumProvider = StateProvider<int>((ref) {
  return defaultCurrentChapterNum;
});

final verseNumProvider = StateProvider<int>((ref) {
  return defaultCurrentVerseNum;
});

final selectedVerseProvider = StateProvider<List<Verse>>((ref) {
  return [];
});

final currentBookTransProvider = StateProvider<BookTranslationType>((ref) {
  return BookTranslationType.niv;
});

class BibleScreen extends ConsumerStatefulWidget {
  const BibleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BibleScreenState();
}

class _BibleScreenState extends ConsumerState<BibleScreen> {
  late ScrollController _scrollController;
  late FlutterListViewController _booksListViewController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _booksListViewController = FlutterListViewController();
    afterBuildCreated(() {
      _init();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _booksListViewController.dispose();
    super.dispose();
  }

  _init() {
    AppData appData = SharedPrefsHelper.getAppData();
    ref.read(bookNumProvider.notifier).state = appData.currentBookNum;
    ref.read(chapterNumProvider.notifier).state = appData.currentChapterNum;
    ref.read(verseNumProvider.notifier).state = appData.currentVerseNum;

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

  int getChaptersCountFromBook(int bookNum) {
    return booksData[bookNum - 1]["c"];
  }

  int getVerseCountFromBookNumAndChapNum(int bookNum, int chapterNum) {
    return booksData[bookNum - 1]["chs"][chapterNum];
  }

  _updateVerseList(int currentBookNum, int currentChapterNum, BookTranslationType currentBookTransType) {
    ref.read(currentVerseListStateNotifierProvider.notifier).setVerseList(
          ref,
          currentBookNum,
          currentChapterNum,
          currentBookTransType,
        );
    AppData appData = SharedPrefsHelper.getAppData();
    SharedPrefsHelper.setAppData(appData.copyWith(currentBookNum: currentBookNum, currentChapterNum: currentChapterNum));
  }

  _handlePrevBtn() {
    int currentChapterNum = ref.read(chapterNumProvider);
    int currentBookNum = ref.read(bookNumProvider);
    BookTranslationType currentBookTransType = ref.read(currentBookTransProvider);

    if (currentChapterNum > 1) {
      int newChapterNum = currentChapterNum - 1;
      ref.read(chapterNumProvider.notifier).state = newChapterNum;
      _updateVerseList(currentBookNum, newChapterNum, currentBookTransType);
    } else {
      //move to the prev book starting from chapter 1
      if (currentBookNum > 1) {
        int newBookNum = currentBookNum - 1;
        int bookChapterTotalCount = getChaptersCountFromBook(newBookNum);
        int newChapterNum = bookChapterTotalCount;
        ref.read(chapterNumProvider.notifier).state = newChapterNum;
        ref.read(bookNumProvider.notifier).state = newBookNum;
        _updateVerseList(newBookNum, newChapterNum, currentBookTransType);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('First Chapter of the Bible Reached!')));
      }
    }
    _scrollToTop();
  }

  _handleNextBtn() {
    int currentChapterNum = ref.read(chapterNumProvider);
    int currentBookNum = ref.read(bookNumProvider);
    BookTranslationType currentBookTransType = ref.read(currentBookTransProvider);
    int bookChapterTotalCount = getChaptersCountFromBook(currentBookNum);

    if (currentChapterNum < bookChapterTotalCount) {
      int newChapterNum = currentChapterNum + 1;
      ref.read(chapterNumProvider.notifier).state = newChapterNum;
      _updateVerseList(currentBookNum, newChapterNum, currentBookTransType);
    } else {
      //move to the next book starting from chapter 1
      if (currentBookNum < booksData.length) {
        int newBookNum = currentBookNum + 1;
        int newChapterNum = 1;
        ref.read(chapterNumProvider.notifier).state = newChapterNum;
        ref.read(bookNumProvider.notifier).state = newBookNum;
        _updateVerseList(newBookNum, newChapterNum, currentBookTransType);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Last Chapter of the Bible Reached!')));
      }
    }
    _scrollToTop();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0, // scroll position to scroll to (top of the list)
      duration: const Duration(milliseconds: 200), // Duration of the animation
      curve: Curves.easeInOut, // Animation curve
    );
  }

  _handleOnBookTap() {
    BookTranslationType bookTranslationType = ref.read(currentBookTransProvider);

    showBarModalBottomSheet(
      context: context,
      builder: (context) {
        List<String> nivBookNames = nivBooksNameToNum.keys.toList();
        List<String> amvBookNames = amvBooksNameToNum.keys.toList();

        List<String> activeBookNames = bookTranslationType == BookTranslationType.niv ? [...nivBookNames] : [...amvBookNames];
        _booksListViewController.sliverController.jumpToIndex(42);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: FlutterListView(
            controller: _booksListViewController,
            delegate: FlutterListViewDelegate(
              (BuildContext context, int index) => Container(
                color: Colors.white,
                child: ListTile(
                  onTap: () {
                    //
                  },
                  title: Text(
                    activeBookNames[index],
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
              childCount: activeBookNames.length,
            ),
          ),
        );
        //!
        // return Container(
        //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        //   child: ListView.builder(
        //     itemCount: activeBookNames.length,
        //     itemBuilder: (context, index) {
        //       return ListTile(
        //         onTap: () {
        //           //
        //         },
        //         title: Text(
        //           activeBookNames[index],
        //           style: TextStyle(fontSize: 16.sp),
        //         ),
        //       );
        //     },
        //   ),
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Verse> verseList = ref.watch(currentVerseListStateNotifierProvider);
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
                          controller: _scrollController,
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
                                          color: Theme.of(context).secondaryHeaderColor,
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
                      onPressed: _handlePrevBtn,
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleOnBookTap,
                    child: Container(
                      width: 150.w,
                      decoration: const BoxDecoration(),
                      child: Center(
                        child: Text(
                          verseList.isNotEmpty ? verseList[0].bna : '',
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: IconButton(
                      onPressed: _handleNextBtn,
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
