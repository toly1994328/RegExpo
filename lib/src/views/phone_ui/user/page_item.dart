import 'package:flutter/material.dart';
import 'package:regexpo/src/app/iconfont/toly_icon.dart';
import 'package:regexpo/src/app/style/behavior/no_scroll_behavior.dart';

/// create by 张风捷特烈 on 2020-03-26
/// contact me by email 1981462002@qq.com
/// 说明:

class MePageItem extends StatelessWidget {
  final Color color;

  const MePageItem({Key? key, this.color = Colors.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildChild(context);
  }

  Widget _buildChild(BuildContext context) {
    Color color =Theme.of(context).dialogBackgroundColor;
    return ScrollConfiguration(
      behavior: NoScrollBehavior(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(height: 10,child: ColoredBox(color:color),),
          const SizedBox(
            height: 10,
          ),
          // Gap.sfl10,


    _buildItem(context, TolyIcon.wb_sunny, '应用设置', ''),
          _buildItem(
              context, TolyIcon.wb_sunny, '数据管理', ''),
          _buildItem(
              context, TolyIcon.wb_sunny, '我的收藏', ''),
          // Gap.sfl10,
          SizedBox(height: 10,child: ColoredBox(color:Theme.of(context).scaffoldBackgroundColor),),

          Stack(
            children: [
              _buildItem(
                context,
                Icons.update,
                '版本信息',
                ''
                // UnitRouter.version_info,
              ),
              // const Positioned(left: 40, top: 10, child: UpdateRedPoint())
            ],
          ),
          _buildItem(context, Icons.info, '关于应用', ''),

          // Gap.sfl10,
          SizedBox(height: 10,child: ColoredBox(color:Theme.of(context).scaffoldBackgroundColor),),
          _buildItem(context, TolyIcon.icon_help, '联系本王', ''),
        ],
      ),
    );
  }

  Widget _buildItem(
          BuildContext context, IconData icon, String title, String linkTo,
          {VoidCallback? onTap}) {
    Color color =Theme.of(context).dialogBackgroundColor;
    return ListTile(
tileColor: color,
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(title, style:  const TextStyle(fontSize: 16)),
      trailing:
          Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
      onTap: () {
        if (linkTo.isNotEmpty) {
          Navigator.of(context).pushNamed(linkTo);
          if (onTap != null) onTap();
        }
      },
    );
  }
}

