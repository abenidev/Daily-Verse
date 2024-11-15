import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/models/verse.dart';
import 'package:daily_verse/providers/current_verse_list_provider.dart';
import 'package:flutter/gestures.dart';
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
          // 19, 119,
          initBookNum, initChapterNum,
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
      return '  ${verse.v[0]}';
    } else {
      return '  ${verse.v[0]} - ${verse.v[verse.v.length - 1]}';
    }
  }

  String renderVerseText(Verse verse) {
    return verse.t.replaceAll(RegExp(r'\*\w+'), '');
    // return verse.t;
  }

  @override
  Widget build(BuildContext context) {
    List<Verse> verseList = ref.watch(currentVerseListStateNotifierProvider);
    int currentBookNum = ref.watch(bookNumProvider);
    int currentChapterNum = ref.watch(chapterNumProvider);
    BookTranslationType currentBookTransType = ref.watch(currentBookTransProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(verseList.isNotEmpty ? '${verseList[0].bna} ${verseList[0].ch}' : ''),
        actions: [
          IconButton(
            onPressed: () {
              if (currentBookTransType == BookTranslationType.niv) {
                ref.read(currentBookTransProvider.notifier).state = BookTranslationType.amv;
              } else if (currentBookTransType == BookTranslationType.amv) {
                ref.read(currentBookTransProvider.notifier).state = BookTranslationType.niv;
              }
              ref.read(currentVerseListStateNotifierProvider.notifier).setVerseList(
                    ref,
                    currentBookNum,
                    currentChapterNum,
                    currentBookTransType,
                  );
            },
            icon: const Icon(Icons.change_circle),
          ),
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
          //!home_widget----------------------
          IconButton(
            onPressed: () async {
              // await HomeWidget.saveWidgetData('appWidgetText', "New App Widget Text");
              // await HomeWidget.updateWidget(
              //   qualifiedAndroidName: "dev.abeni.daily_verse.HomeScreenWidget",
              //   androidName: "HomeScreenWidget",
              // );
            },
            icon: const Icon(Icons.restart_alt),
          ),
          //!home_widget----------------------
        ],
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
                                text: ' ${renderVerseNum(verse)}. ${renderVerseText(verse)}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  background: Paint()..color = Theme.of(context).secondaryHeaderColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() => highlightedVerses.remove(verse));
                                  },
                              )
                            : verse.v.contains(0) || verse.hnu != null
                                ? TextSpan(
                                    text: renderHeadingText(verse),
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : TextSpan(
                                    text: ' ${renderVerseNum(verse)}. ${renderVerseText(verse)}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      height: 1.6,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        debugPrint('verse: ${verse}');
                                        setState(() => highlightedVerses.add(verse));
                                      },
                                  );
                      },
                    ).toList(),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
