import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/custom/dialog/option_bottom_dialog.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/app/res/gap.dart';

class LinkRegexTab extends StatelessWidget implements PreferredSizeWidget{
  const LinkRegexTab({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).backgroundColor;
    return Container(
      height: 26,
      // color: color,
      child:Row(
        children: [
          Expanded(
            child: BlocBuilder<LinkRegexBloc, LinkRegexState>(
              builder: _buildByState,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildByState(BuildContext context, LinkRegexState state) {
    Color primaryColor = Theme.of(context).primaryColor;
    final int activeTabId = state.activeRegex?.id??-1;
    List<LinkRegex> regexes = [];

    if(state is LoadedLinkRegexState){
      regexes = state.regexes;
    }

    return ListView(
        scrollDirection: Axis.horizontal,
        children: regexes.asMap().keys.map((int index) {
          LinkRegex tab = regexes[index];
          bool active = activeTabId == tab.id;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => activeTab(context, tab),
            onLongPress:  () => showOpDialog(context, tab),
            child: Container(
              decoration: BoxDecoration(
                  border: active?Border(
                  bottom: BorderSide(color: primaryColor)
                ):null
              ),
              height: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(tab.regex, style: const TextStyle(height: 1, fontSize: 12)),
                  ),
                  Gap.dividerVI
                ],
              ),
            ),
          );
        }).toList());
  }

  void activeTab(BuildContext context, LinkRegex regex) {
    context.read<LinkRegexBloc>().select(regex.id);
    // RecordBloc bloc = context.read<RecordBloc>();
    // bloc.selectCacheTab(record.id);
  }
  void removeCacheTab(BuildContext context, Record record) {
    // RecordBloc bloc = context.read<RecordBloc>();
    // bloc.removeCacheTab(record.id);
  }

  @override
  Size get preferredSize =>     Size.fromHeight(26);

  void showOpDialog(BuildContext context, LinkRegex tab) {
    HapticFeedback.mediumImpact();
    showCupertinoModalPopup(
        context: context,
        builder: (context) => PickBottomDialog(
          tasks: [
            AsyncItem(task: () {}, info: '修改正则'),
            AsyncItem(task: () {},info: '删除正则'),
          ],
        ));
  }

}