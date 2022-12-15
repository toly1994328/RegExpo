import 'dart:io';

import 'package:app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/repositories/impl/db/local_db.dart';
import 'package:regexpo/src/repositories/parser/regex_parser.dart';
import 'package:regexpo/src/views/desk_ui/home/home_page.dart';
import 'package:regexpo/src/views/phone_ui/home/phone_home_page.dart';


class SplashPage extends StatefulWidget {
  final int minCostMs;
  const SplashPage({super.key, this.minCostMs = 600});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  int _timeRecoder = 0;

  @override
  void initState() {
    super.initState();
    _timeRecoder = DateTime.now().millisecondsSinceEpoch;
    _initApp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppConfigBloc,AppConfig>(
      listener: _listenInit,
      child: Scaffold(
        backgroundColor: AppThemeData.light.scaffoldBackgroundColor,
        body: Center(
          child:Column(
            children: [
              const Spacer(),
              Wrap(
                spacing: 0,
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Image.asset('assets/images/regexpo_logo.png',width: 80,height: 80,),
                  Text.rich(
                    TextSpan(
                      children:[
                        TextSpan(
                            text: "Reg",
                          style: TextStyle(color: kRenderColors[0],fontSize: 20,fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                            text: "Ex",
                            style: TextStyle(color: kRenderColors[1],fontSize: 20,fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                            text: "po",
                            style: TextStyle(color: kRenderColors[2],fontSize: 20,fontWeight: FontWeight.bold)
                        ),
                      ]
                    )
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  RecordBloc get recoder => context.read<RecordBloc>();

  void _listenInit(BuildContext context, AppConfig state) async{
    int now = DateTime.now().millisecondsSinceEpoch;
    int cost = now - _timeRecoder;
    int delay = widget.minCostMs - cost;
    recoder.loadRecord();
    if(delay>0){
     await Future.delayed(Duration(milliseconds: delay));
    }
    if (state.inited) {
      Widget home = const PlatformUIAdapter(
        mobile: PhoneHomePage(),
        desk: DeskHomePage(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => home),
      );
    }
  }

  void _initApp() async {
    await LocalDb.instance.initDb();
    context.read<AppConfigBloc>().initApp();
  }
}

class PlatformUIAdapter extends StatelessWidget {
  final Widget desk;
  final Widget mobile;

  const PlatformUIAdapter({
    super.key,
    required this.desk,
    required this.mobile,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {
      return mobile;
    }
    return desk;
  }
}
