import 'package:daily_verse/helpers/object_box_helper.dart';
import 'package:daily_verse/models/collection.dart';
import 'package:daily_verse/screens/bookmarks_screen.dart';
import 'package:daily_verse/utils/app_utils.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  late FocusNode _newCollFieldFocusNode;

  @override
  void initState() {
    super.initState();
    _collNameEditingController = TextEditingController();
    _newCollFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _collNameEditingController.dispose();
    _newCollFieldFocusNode.dispose();
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
          _newCollFieldFocusNode.requestFocus();
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: const BoxDecoration(),
                child: Column(
                  children: [
                    TextFormField(
                      focusNode: _newCollFieldFocusNode,
                      controller: _collNameEditingController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Theme.of(context).hoverColor,
                      ),
                    ),
                    SizedBox(height: 5.h),
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
                Navigator.push(context, CupertinoPageRoute(builder: (context) => BookmarksScreen(coll: collection)));
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
