import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/screens/bible_screen.dart';
import 'package:daily_verse/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BookTranslationType currentBookTranslationType = ref.watch(currentBookTransProvider);
    int currentBookNum = ref.watch(bookNumProvider);
    int currentChapterNum = ref.watch(chapterNumProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              child: Text('Profile', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600)),
            ),
            ListTile(
              onTap: () {
                BookTranslationType? newBookTransType;
                if (currentBookTranslationType == BookTranslationType.niv) {
                  ref.read(currentBookTransProvider.notifier).state = BookTranslationType.amv;
                  newBookTransType = BookTranslationType.amv;
                } else if (currentBookTranslationType == BookTranslationType.amv) {
                  ref.read(currentBookTransProvider.notifier).state = BookTranslationType.niv;
                  newBookTransType = BookTranslationType.niv;
                }

                if (newBookTransType != null) {
                  updateVerseList(ref, currentBookNum, currentChapterNum, newBookTransType);
                }
              },
              title: Text(
                'Change Translation',
                style: TextStyle(fontSize: 16.sp),
              ),
              trailing: Text(
                currentBookTranslationType.name?.toUpperCase() ?? '',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
