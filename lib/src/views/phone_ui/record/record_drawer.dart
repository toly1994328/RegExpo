import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:regexpo/src/views/desk_ui/record/record_panel.dart';
class RecordDrawer extends StatelessWidget {
  const RecordDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light
      ),
      child: Drawer(
        width: MediaQuery.of(context).size.width*0.7,
        child:Column(
          children: const [
            _UnitDrawerHeader(),
            Expanded(child: RecordPanel()),
          ],
        ),
      ),
    );
  }
}


class _UnitDrawerHeader extends StatelessWidget {
  final Color color;

  const _UnitDrawerHeader({super.key, this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: const EdgeInsets.only(top: 10, left: 15),
      margin: EdgeInsets.zero,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/draw_bg3.webp'),
            fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(blurRadius: 1, color: Colors.blue)]),
                padding: const EdgeInsets.all(2),
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/icon_head.webp'),
                ),
              ),
              const Text(
                'RegExpo',
                style: TextStyle(fontSize: 24, color: Colors.white, shadows: [
                  Shadow(
                      color: Colors.black, offset: Offset(1, 1), blurRadius: 3)
                ]),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              '基于 Flutter 框架实现的， 全平台正则表达式交互学习应用。',
              style: TextStyle(fontSize: 15, color: Colors.white, shadows: [
                Shadow(color: color, offset: const Offset(.5, .5), blurRadius: 1)
              ]),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: const <Widget>[
              Spacer(flex: 5),
              Text(
                '——Powered By 张风捷特烈',
                style: TextStyle(fontSize: 15, color: Colors.white, shadows: [
                  Shadow(
                      color: Colors.orangeAccent,
                      offset: Offset(.5, .5),
                      blurRadius: 1)
                ]),
              ),
              Spacer(flex: 1),
            ],
          ),
        ],
      ),
    );
  }
}