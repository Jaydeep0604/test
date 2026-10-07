
import 'package:flutter/material.dart'
    show BuildContext, Color, DefaultTabController, FloatingActionButtonLocation, FocusScope, GlobalKey, MediaQuery, PreferredSizeWidget, SafeArea, Scaffold, ScaffoldState, Size, SizedBox, State, StatefulWidget, ThemeData, Widget, GestureDetector, Theme, protected;

import '../resources/colors.dart';

abstract class BaseStatefulWidgetState<
StateMVC extends StatefulWidget> extends State<StateMVC> {

  late ThemeData baseTheme;

  bool shouldHaveSafeArea = true;
  bool resizeToAvoidBottomInset = false;

  final rootScaffoldKey = GlobalKey<ScaffoldState>();

  late Size screenSize;

  bool extendBodyBehindAppBar = false;
  bool isExtendBody = false;

  Color? scaffoldBgColor;

  FloatingActionButtonLocation? floatingActionButtonLocation;

  int length = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    baseTheme = Theme.of(context);
    screenSize = MediaQuery.of(context).size;
  }

  Widget heightBox(double height) {
    return SizedBox(height: height);
  }

  Widget widthBox(double width) {
    return SizedBox(width: width);
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = buildBody(context);

    if (shouldHaveSafeArea) {
      bodyContent = SafeArea(
        bottom: true,
        child: bodyContent,
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: length,
        child: Scaffold(
          key: rootScaffoldKey,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          extendBody: isExtendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          backgroundColor: scaffoldBgColor ?? colorWhite,
          appBar: buildAppBar(context),
          body: bodyContent,
          bottomNavigationBar:
          buildBottomNavigationBar(context),
          floatingActionButton: buildFloating(context),
          floatingActionButtonLocation:
          floatingActionButtonLocation,
        ),
      ),
    );
  }

  @protected
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return null;
  }

  Widget buildBody(BuildContext context) {
    return const SizedBox.shrink();
  }

  Widget? buildBottomNavigationBar(BuildContext context) {
    return null;
  }

  Widget? buildFloating(BuildContext context) {
    return null;
  }
}
