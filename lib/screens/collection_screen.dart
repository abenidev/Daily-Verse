import 'package:daily_verse/helpers/object_box_helper.dart';
import 'package:daily_verse/models/collection.dart';
import 'package:daily_verse/utils/app_utils.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final collectionsListProvider = StateProvider<List<Collection>>((ref) {
  return [];
});

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  late TextEditingController _collNameEditingController;

  @override
  void initState() {
    super.initState();
    _collNameEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _collNameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Collection> collectionsList = ref.watch(collectionsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Collections',
          style: TextStyle(fontSize: 16.sp),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBarModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: const BoxDecoration(),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _collNameEditingController,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        DateTime now = DateTime.now();
                        String colName = _collNameEditingController.text.trim();
                        Collection newCol = Collection(createdAt: now, updatedAt: now, name: colName);
                        BoxLoader.addCollection(newCol);
                        BoxLoader.loadCollections(ref);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Create Collection',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add, size: 22.w),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: ListView.builder(
          itemCount: collectionsList.length,
          itemBuilder: (context, index) {
            Collection collection = collectionsList[index];

            return ListTile(
              onTap: () {
                //
              },
              leading: CircleAvatar(
                radius: 10.w,
                backgroundColor: fromHexString(collection.color),
              ),
              title: Text(
                collection.name.capitalize,
                style: TextStyle(fontSize: 16.sp),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 18.w),
            );
          },
        ),
      ),
    );
  }
}
