import 'package:daily_verse/screens/bible_screen.dart';
import 'package:daily_verse/screens/collection_screen.dart';
import 'package:daily_verse/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

final selectedBnbIndexProvider = StateProvider<int>((ref) {
  return 0;
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

  @override
  void dispose() {
    super.dispose();
  }

  _init() {
    //
  }

  final List<Widget> _bnbScreens = const [
    Center(child: Text("Home Screen")),
    BibleScreen(),
    CollectionScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    int selectedBnbIndex = ref.watch(selectedBnbIndexProvider);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedBnbIndex,
        onTap: (value) => ref.read(selectedBnbIndexProvider.notifier).state = value,
        selectedItemColor: Theme.of(context).primaryColor,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bible',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Colls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
      body: _bnbScreens[selectedBnbIndex],
    );
  }
}
