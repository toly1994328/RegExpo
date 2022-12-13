import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/res/keys.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:regexpo/src/repositories/impl/db/local_db.dart';

class AppConfigBloc extends Cubit<AppConfig> {
  SharedPreferences? _sp;

  Future<SharedPreferences> get sp async {
    _sp ??= await SharedPreferences.getInstance();
    return _sp!;
  }

  AppConfigBloc() : super(const AppConfig());

  void initApp() async{
   // 读取数据
   int mode = (await sp).getInt(SpKey.appThemeModel)??0;
   await LocalDb.instance.initDb();
   emit(state.copyWith(appThemeMode: mode,inited: true));
  }

  void switchThemeMode() async {
    int newMode = state.appThemeMode == 0 ? 1 : 0;
    emit(state.copyWith(appThemeMode: newMode));
    // 存储数据
    (await sp).setInt(SpKey.appThemeModel, newMode);
  }
}
