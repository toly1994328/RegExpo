import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/tab_bean.dart';

class TabCubit extends Cubit<TabList> {
  TabCubit() : super(TabList.test);

  int _createIndex = 0;

  void addUntitled() {
    state.tabs.add(TabBean(
      name: 'untitled$_createIndex.dart',
      flag: true,
      content: 'untitled$_createIndex.dart',
    ));
    _createIndex ++;
    emit(TabList(tabs: state.tabs));
  }

  void deleteAt(int index) {
    state.tabs.removeAt(index);
    emit(TabList(tabs: state.tabs));
  }
}
