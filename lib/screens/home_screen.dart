import 'package:daily_verse/models/verse.dart';
import 'package:daily_verse/providers/current_verse_list_provider.dart';
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
    ref.read(currentVerseListStateNotifierProvider.notifier).setVerseList(ref, 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    List<Verse> verseList = ref.watch(currentVerseListStateNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          decoration: const BoxDecoration(),
          // height: 0.7.sh,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView.builder(
              // controller: widget.scrollController,
              itemCount: verseList.length,
              itemBuilder: (context, index) {
                // if (index == 0) {
                //   return Column(
                //     children: [
                //       SizedBox(height: 5.h),
                //       Text(
                //         '${currentBook!.name} ${currentChapter}',
                //         style: TextStyle(fontSize: 26.sp),
                //       ),
                //       SizedBox(height: 15.h),
                //     ],
                //   );
                // }

                final verse = verseList[index];
                String cleanedVerseText = verse.t;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: GestureDetector(
                    onTap: () {
                      // widget.onVerseTap(verse);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${verse.v}.',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        Expanded(
                          child: Text(
                            cleanedVerseText,
                            style: TextStyle(fontSize: 17.sp, height: 1.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
