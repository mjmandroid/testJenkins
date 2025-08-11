import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  factory CustomNavigatorObserver() => _getInstance();
  static CustomNavigatorObserver? _instance;
  CustomNavigatorObserver._internal();

  List pageList = <String>[];

  static CustomNavigatorObserver _getInstance() {
    _instance ??= CustomNavigatorObserver._internal();
    return _instance!;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    String? name = route.settings.name;
    if (name == null) return;
    pageList.add(name);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    String? name = route.settings.name;
    if (name == null) return;
    debugPrint("delete==>$name");
    pageList.remove(name);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    String? name = route.settings.name;
    if (name == null) return;
    pageList.remove(name);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    String? newName = newRoute?.settings.name;
    String? oldName = oldRoute?.settings.name;
    if (oldName != null) {
      pageList.remove(oldName);
    }
    if (newName == null) return;
    pageList.add(newName);
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
