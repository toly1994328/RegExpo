import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_exp.dart';

class SelectionCubit extends Cubit<UserSelection> {
  SelectionCubit() : super(UserSelection());

  void updateRegex(String regex) {
    emit(state.copyWith(regex: regex));
  }

  void updateRecommendIndex(int index) {
    emit(state.copyWith(recommendIndex: index));
  }

  void handleDragNavTab(NavBean bean, NavType targetType) {
    // 页签已在左侧被激活 - 现在要移到右侧
    bool inactiveLeft = bean.id == state.activeLeftNavId &&
        (targetType == NavType.rightTop || targetType == NavType.rightDown);

    if (inactiveLeft) {
      selectNavById(
        left: 0,
        right: bean.id,
      );
    }
    // 页签已在右侧被激活 - 现在要移到左侧
    bool inactiveRight = bean.id == state.activeRightNavId &&
        (targetType == NavType.leftTop || targetType == NavType.leftDown);
    if (inactiveRight) {
      selectNavById(
        left: bean.id,
        right: 0,
      );
    }
  }

  void selectNavById({int? left, int? right}) {
    emit(state.copyWith(
      activeLeftNavId: left,
      activeRightNavId: right,
    ));
  }

  void selectNav(NavBean navBean) {
    if (navBean.isLeft) {
      final int activeNavId = state.activeLeftNavId;
      if (activeNavId == navBean.id && activeNavId != 0) {
        emit(state.copyWith(activeLeftNavId: 0));
      } else {
        emit(state.copyWith(activeLeftNavId: navBean.id));
      }
    }

    if (navBean.isRight) {
      final int activeRightNavId = state.activeRightNavId;
      if (activeRightNavId == navBean.id && activeRightNavId != 0) {
        emit(state.copyWith(activeRightNavId: 0));
      } else {
        emit(state.copyWith(activeRightNavId: navBean.id));
      }
    }
  }

  void selectTab(int id){
    emit(state.copyWith(activeTabId: id,recommendIndex: 0));
  }

  void selectExample(int id){
    emit(state.copyWith(activeExampleId: id,activeTabId: id,recommendIndex: 0));
  }
}