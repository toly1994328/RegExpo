import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/nav_bean.dart';

class NavCubit extends Cubit<NavItemList> {
  NavCubit() : super(NavItemList.defaultNav);
}
