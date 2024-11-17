import 'dart:convert';

import 'package:daily_verse/constants/app_strings.dart';
import 'package:daily_verse/helpers/query_helper.dart';
import 'package:daily_verse/helpers/shared_prefs_helper.dart';
import 'package:daily_verse/main.dart';
import 'package:daily_verse/models/bookmark.dart';
import 'package:daily_verse/models/collection.dart';
import 'package:daily_verse/models/verse.dart';
import 'package:daily_verse/objectbox.g.dart';
import 'package:daily_verse/screens/collection_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<List<dynamic>> parseJsonFromAssets(String assetsPath) async {
  debugPrint('--- Parse json from: $assetsPath');
  return rootBundle.loadString(assetsPath).then((jsonStr) => jsonDecode(jsonStr));
}

List<Verse> getVersesFromListMap(List<dynamic> versesMapList) {
  return versesMapList.map((verseMap) => Verse.fromMap(verseMap)).toList();
}

//*--------------------------------------NIV-----------------------------------
Future<bool> loadNivVersesDataFromAssetJson(dynamic dataMap) async {
  final token = dataMap['token'];
  List<dynamic> tNiv = dataMap['tNiv'];
  BackgroundIsolateBinaryMessenger.ensureInitialized(token);
  final nivObjectbox = await NivObjectBox.create();
  final nivVBox = nivObjectbox.store.box<Verse>();
  if (!nivVBox.isEmpty()) {
    return true;
  }
  nivVBox.removeAll();
  List<dynamic> versesMapList = tNiv;
  List<Verse> versesList = getVersesFromListMap(versesMapList);
  List<int> bookVerseIds = nivVBox.putMany(versesList);
  debugPrint('bookVerseIds: ${bookVerseIds}');
  return true;
}
//*--------------------------------------NIV-----------------------------------
//*--------------------------------------AMV-----------------------------------

Future<bool> loadAmvVersesDataFromAssetJson(dynamic dataMap) async {
  final token = dataMap['token'];
  final tAmv = dataMap['tAmv'];
  BackgroundIsolateBinaryMessenger.ensureInitialized(token);
  final amvObjectbox = await AmvObjectBox.create();
  final amvBox = amvObjectbox.store.box<Verse>();
  if (!amvBox.isEmpty()) {
    return true;
  }
  amvBox.removeAll();
  List<dynamic> versesMapList = tAmv;
  List<Verse> versesList = getVersesFromListMap(versesMapList);
  List<int> bookVerseIds = amvBox.putMany(versesList);
  debugPrint('bookVerseIds: ${bookVerseIds}');
  return true;
}
//*--------------------------------------AMV-----------------------------------

class NivObjectBox {
  late final Store store;
  NivObjectBox._create(this.store);
  static Future<NivObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    String dbPath = p.join(docsDir.path, "niv-translation");
    Store store;
    if (Store.isOpen(dbPath)) {
      store = Store.attach(getObjectBoxModel(), dbPath);
    } else {
      store = await openStore(directory: dbPath);
    }
    return NivObjectBox._create(store);
  }
}

class AmvObjectBox {
  late final Store store;
  AmvObjectBox._create(this.store);
  static Future<AmvObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    String dbPath = p.join(docsDir.path, "amv-translation");
    Store store;
    if (Store.isOpen(dbPath)) {
      store = Store.attach(getObjectBoxModel(), dbPath);
    } else {
      store = await openStore(directory: dbPath);
    }
    return AmvObjectBox._create(store);
  }
}

class BoxLoader {
  BoxLoader._();

  static final nivVerseBox = nivObjectBox.store.box<Verse>();
  static final amvVerseBox = amvObjectBox.store.box<Verse>();
  static final collectionsBox = nivObjectBox.store.box<Collection>();
  static final bookmarksBox = nivObjectBox.store.box<Bookmark>();

  //*--------------------------------------NIV-----------------------------------
  static Future<bool> _loadNivVersesFromAssetJson() async {
    if (!nivVerseBox.isEmpty()) return true;
    nivVerseBox.removeAll();
    List<dynamic> tNiv = await parseJsonFromAssets(kTNivAssetPath);
    List<Map<String, dynamic>> versesMapList = tNiv as List<Map<String, dynamic>>;
    List<Verse> versesList = getVersesFromListMap(versesMapList);
    List<int> bookVerseIds = nivVerseBox.putMany(versesList);
    debugPrint('bookVerseIds: ${bookVerseIds}');
    return true;
  }

  //*--------------------------------------AMV-----------------------------------
  static Future<bool> _loadAmVVersesFromAssetJson() async {
    if (!amvVerseBox.isEmpty()) return true;
    amvVerseBox.removeAll();
    List<dynamic> tAmv = await parseJsonFromAssets(kTAmvAssetPath);
    List<Map<String, dynamic>> versesMapList = tAmv as List<Map<String, dynamic>>;
    List<Verse> versesList = getVersesFromListMap(versesMapList);
    List<int> bookVerseIds = amvVerseBox.putMany(versesList);
    debugPrint('bookVerseIds: ${bookVerseIds}');
    return true;
  }

  //*-------------------------------------collections------------------------------
  static int addCollection(Collection newCollection) {
    return collectionsBox.put(newCollection);
  }

  static void loadCollections(WidgetRef ref) {
    List<Collection> loadedCollections = BoxQueryHelper.getCollections();
    ref.read(collectionsListProvider.notifier).state = [...loadedCollections];
  }

  //
  static Future<bool> loadData(WidgetRef ref) async {
    //*---------------------------------------------Niv verses loading start
    bool isNivVersesLoaded;
    List<dynamic> tNiv;
    final loadNivVersesToken = RootIsolateToken.instance;
    if (BoxLoader.nivVerseBox.isEmpty()) {
      tNiv = await parseJsonFromAssets(kTNivAssetPath);
      isNivVersesLoaded = await compute(loadNivVersesDataFromAssetJson, {"token": loadNivVersesToken, "tNiv": tNiv});
    } else {
      isNivVersesLoaded = await BoxLoader._loadNivVersesFromAssetJson();
    }

    //*---------------------------------------------Amv verses loading start
    bool isAmvVersesLoaded;
    List<dynamic> tAmv;
    final loadAmvVersesToken = RootIsolateToken.instance;
    if (BoxLoader.amvVerseBox.isEmpty()) {
      tAmv = await parseJsonFromAssets(kTAmvAssetPath);
      isAmvVersesLoaded = await compute(loadAmvVersesDataFromAssetJson, {"token": loadAmvVersesToken, "tAmv": tAmv});
    } else {
      isAmvVersesLoaded = await BoxLoader._loadAmVVersesFromAssetJson();
    }

    loadCollections(ref);

    if (isNivVersesLoaded && isAmvVersesLoaded) {
      bool isSaved = await SharedPrefsHelper.setIsTranslationsLoaded(true);
      if (isSaved) {
        return true;
      }
    }

    return false;
  }
}
