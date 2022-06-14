import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/directory/models/reg_example.dart';

import '../model/tab_bean.dart';

class TabCubit extends Cubit<TabList> {
  TabCubit() : super(TabList.test);

  void deleteById(int id) {
    state.tabs.removeWhere((e)=>e.id==id);
    emit(TabList(tabs: state.tabs));
  }

  void addExample(RegExample example) {
    Iterable<TabBean> tabs = state.tabs.where((e)=>e.id==example.id);

    // 已经存在
    if(tabs.isNotEmpty){
      state.tabs.remove(tabs.first);
    }
    state.tabs.insert(0,TabBean(
      id: example.id,
      name: example.title,
    ));
    emit(TabList(tabs: state.tabs));
  }
}
