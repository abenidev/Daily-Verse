import 'package:daily_verse/helpers/query_helper.dart';
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
    ref.read(currentVerseListStateNotifierProvider.notifier).setVerseList(
          ref,
          1,
          1,
          BookTranslationType.amv,
        );
  }

  @override
  Widget build(BuildContext context) {
    List<Verse> verseList = ref.watch(currentVerseListStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(verseList[0].bna),
        //!home_widget----------------------
        // actions: [
        // IconButton(
        //   onPressed: () async {
        //     //
        //     await HomeWidget.saveWidgetData('appWidgetText', "New App Widget Text");
        //     await HomeWidget.updateWidget(
        //       qualifiedAndroidName: "dev.abeni.daily_verse.HomeScreenWidget",
        //       androidName: "HomeScreenWidget",
        //     );
        //   },
        //   icon: const Icon(Icons.restart_alt),
        // ),
        // ],
        //!home_widget----------------------
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          decoration: const BoxDecoration(),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView.builder(
              itemCount: verseList.length,
              itemBuilder: (context, index) {
                final verse = verseList[index];
                String cleanedVerseText = verse.t;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: GestureDetector(
                    onTap: () {
                      //
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
