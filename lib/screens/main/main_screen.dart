import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../base/base_stateful_widget_state.dart';
import '../../resources/colors.dart';
import '../home/home_screen.dart';
import '../watchlist/watchlist_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.index = 0});
  final int index;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends BaseStatefulWidgetState<MainScreen> with WidgetsBindingObserver {
  @override
  bool get extendBodyBehindAppBar => false;

  @override
  bool get shouldHaveSafeArea => true;

  @override
  bool get resizeToAvoidBottomInset => true;

  @override
  bool get isExtendBody => false;

  int currentIndex = 0;

  final GlobalKey<HomescreenState> _homeKey = GlobalKey();
  final GlobalKey<WatchlistScreenState> _watchlistKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentIndex = widget.index;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 1) {
      _watchlistKey.currentState?.refreshWatchlist();
    } else if (index == 0) {
      _homeKey.currentState?.syncWatchlist();
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: colorWhite,
      ),
      child: IndexedStack(
        index: currentIndex,
        children: [
          Homescreen(key: _homeKey),
          WatchlistScreen(key: _watchlistKey),
        ],
      ),
    );
  }

  @override
  Widget? buildBottomNavigationBar(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    if (isKeyboardOpen) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(color: colorBorder, height: 1, thickness: 1),
        BottomNavigationBar(
          elevation: 0,
          backgroundColor: colorWhite,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_outline),
              activeIcon: Icon(Icons.star),
              label: "Watchlist",
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: colorPrimary,
          unselectedItemColor: colorGrey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          onTap: _onItemTapped,
        ),
      ],
    );
  }
}
