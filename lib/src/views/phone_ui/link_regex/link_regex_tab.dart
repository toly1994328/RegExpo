import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/res/gap.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/components/custom/dialog/option_bottom_dialog.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/views/desk_ui/link_regex/edit_regex_panel.dart';

import 'delete_link_regex.dart';

class LinkRegexTab extends StatelessWidget implements PreferredSizeWidget {
  const LinkRegexTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: Row(
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
    TextStyle style = const TextStyle(height: 1, fontSize: 12);
    if (state is EmptyLinkRegexState) {
      return GestureDetector(
        onTap: ()=>showAddDialog(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "暂无链接正则 +",
            style: style.copyWith(color: Colors.grey),
          ),
        ),
      );
    }

    Color primaryColor = Theme.of(context).primaryColor;
    final int activeTabId = state.activeRegex?.id ?? -1;
    List<LinkRegex> regexes = [];

    if (state is LoadedLinkRegexState) {
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
  }

  @override
  Size get preferredSize => const Size.fromHeight(26);

  void showOpDialog(BuildContext context, LinkRegex tab) {
    HapticFeedback.mediumImpact();
    showCupertinoModalPopup(
      context: context,
      builder: (context) => PickBottomDialog(
        tasks: [
          AsyncItem(task: () => showAddDialog(context), info: '添加正则'),
          AsyncItem(task: () => showEditeDialog(context), info: '修改正则'),
          AsyncItem(task: () => showDeleteDialog(context, tab), info: '删除正则'),
        ],
      ),
    );
  }

  void showDeleteDialog(BuildContext context, LinkRegex tab) {
    Color color = Theme.of(context).backgroundColor;
    showDialog(
        context: context,
        builder: (_) => Dialog(
              backgroundColor: color,
              child: PhoneDeleteRegex(
                model: tab,
              ),
            ));
  }

  void showAddDialog(BuildContext context) {
    Color color = Theme.of(context).backgroundColor;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
              backgroundColor: color,
              child: const SizedBox(height: 350, child: EditRegexPanel()),
            ));
  }

  void showEditeDialog(BuildContext context) {
    Color color = Theme.of(context).backgroundColor;
    LinkRegexBloc bloc = context.read<LinkRegexBloc>();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Dialog(
          backgroundColor: color,
          child: SizedBox(
              height: 350,
              child: EditRegexPanel(model: bloc.state.activeRegex,)),
        ));
  }
}