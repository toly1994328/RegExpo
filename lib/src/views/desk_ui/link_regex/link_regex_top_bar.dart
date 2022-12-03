import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/app/iconfont/toly_icon.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/models/models.dart';

import 'delete_regex_panel.dart';
import 'edit_regex_panel.dart';


class LinkRegexTopBar extends StatelessWidget {
  const LinkRegexTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).backgroundColor;
    return Container(
      height: 26,
      padding: const EdgeInsets.only(left: 8, right: 4),
      alignment: Alignment.centerLeft,
      color: color,
      child: Row(
        children: [
          const Text(
            '关联正则表达式',
            style: TextStyle(fontSize: 11),
          ),
          const Spacer(),
          Wrap(
            spacing: 4,
            children: [
              GestureDetector(
                onTap: () => showEditeDialog(context),
                child: const Icon(
                  TolyIcon.icon_edit,
                  size: 16,
                  color: Colors.blue,
                ),
              ),
              GestureDetector(
                onTap: () => showDeleteDialog(context),
                child: const Icon(TolyIcon.icon_delete,
                    size: 16, color: Colors.redAccent),
              ),

              GestureDetector(
                  onTap: () => showAddDialog(context),
                  child: const Icon(
                    Icons.add,
                    size: 16,
                    color: Color(0xff7E7E7E),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  void showAddDialog(BuildContext context) {
    Color color = Theme.of(context).backgroundColor;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 5),
              child:  Dialog(
                backgroundColor: color,
                child:const EditRegexPanel(),
              ),
            ));
  }

  void showEditeDialog(BuildContext context) {
    Color color = Theme.of(context).backgroundColor;

    LinkRegexBloc bloc = context.read<LinkRegexBloc>();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 5),
          child:  Dialog(
            backgroundColor: color,
            child: EditRegexPanel(model: bloc.state.activeRegex,),
          ),
        ));
  }

  void showDeleteDialog(BuildContext context) {
    Color color = Theme.of(context).backgroundColor;

    LinkRegexBloc bloc = context.read<LinkRegexBloc>();
    LinkRegex? record = bloc.state.activeRegex;
    if(record == null) return;
    showDialog(
        context: context,
        builder: (_) => Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 4),
          child:  Dialog(
            backgroundColor: color,
            child: DeleteRegexPanel(model: record,),
          ),
        ));
  }

  void refresh(BuildContext context) {
    // RecordBloc bloc = context.read<RecordBloc>();
    // bloc.loadRecord(operation: LoadType.refresh);
  }

  Future<void> _onRefresh(BuildContext context) async{
    // RecordBloc bloc = context.read<RecordBloc>();
    // bloc.loadRecord(operation: LoadType.refresh);
  }
}
