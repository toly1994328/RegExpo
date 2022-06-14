import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/nav_bean.dart';

class NavCubit extends Cubit<NavItemList> {
  NavCubit({required NavItemList navItemList}) : super(navItemList);

  void swap(NavBean bean, NavType type) {
    if (bean.type == type) return;
    List<NavBean> tabs = state.tabs.where((element) => element.type == type&&element.id!=bean.id).toList();
    List<NavBean> otherTabs = state.tabs.where((element) => element.type != type&&element.id!=bean.id).toList();
    tabs.add(bean.copyWith(type: type));

    emit(NavItemList(tabs: [
      ...otherTabs,...tabs
    ]));
  }
}
