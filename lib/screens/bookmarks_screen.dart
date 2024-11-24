import 'package:daily_verse/data/amv_books.dart';
import 'package:daily_verse/data/niv_books.dart';
import 'package:daily_verse/helpers/object_box_helper.dart';
import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/models/bookmark.dart';
import 'package:daily_verse/models/collection.dart';
import 'package:daily_verse/models/verse.dart';
import 'package:daily_verse/objectbox.g.dart';
import 'package:daily_verse/screens/bible_screen.dart';
import 'package:daily_verse/utils/app_utils.dart';
import 'package:daily_verse/utils/render_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key, required this.coll});
  final Collection coll;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  Stream<List<Bookmark>> getCollBookmarks() {
    final builder = BoxLoader.bookmarksBox.query(Bookmark_.collection.equals(widget.coll.id)).order(Bookmark_.createdAt, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  Stream<List<Verse>> getVerseFromBookmark(Bookmark bookmark) {
    BookTranslationType currentBookTransType = ref.read(currentBookTransProvider);
    bool isBookTransTypeAmv = currentBookTransType == BookTranslationType.amv;
    final verseBox = isBookTransTypeAmv ? BoxLoader.amvVerseBox : BoxLoader.nivVerseBox;

    final builder = verseBox.query(Verse_.bnu.equals(bookmark.bookNum).and(Verse_.ch.equals(bookmark.chapterNum).and(Verse_.v.equals(bookmark.verseNum))));
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    //
  }

  @override
  Widget build(BuildContext context) {
    BookTranslationType currentBookTransType = ref.watch(currentBookTransProvider);
    bool isBookTransTypeAmv = currentBookTransType == BookTranslationType.amv;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verses'),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: StreamBuilder(
          stream: getCollBookmarks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              if (snapshot.data != null) {
                List<Bookmark> bookmarksList = snapshot.data!;

                if (bookmarksList.isEmpty) {
                  return Center(
                    child: SizedBox(
                      width: 0.6.sw,
                      child: Text(
                        'You don\'t have any verses added to the collection.',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: bookmarksList.length,
                  itemBuilder: (context, index) {
                    final bookmark = bookmarksList[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: index == bookmarksList.length - 1 ? 90.h : 0),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${isBookTransTypeAmv ? amvBooksNumToName[bookmark.bookNum] : nivBooksNumToName[bookmark.bookNum]} ${bookmark.chapterNum} : ${bookmark.verseNum}',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            SizedBox(height: 5.h),
                            StreamBuilder<List<Verse>>(
                              stream: getVerseFromBookmark(bookmark),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                }

                                if (snapshot.hasData) {
                                  debugPrint(snapshot.data.toString());
                                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  Verse verse = snapshot.data![0];
                                  return Text(
                                    renderVerseText(verse),
                                    style: TextStyle(fontSize: 14.sp),
                                  );
                                }

                                return const SizedBox.shrink();
                              },
                            ),
                            SizedBox(height: 5.h),
                          ],
                        ),
                        subtitle: Text(
                          getFormattedDateStr(bookmark.createdAt),
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios, size: 15.w),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('Nothing to show here!'));
              }
            } else {
              return const Center(child: Text('Nothing to show here!'));
            }
          },
        ),
      ),
    );
  }
}
