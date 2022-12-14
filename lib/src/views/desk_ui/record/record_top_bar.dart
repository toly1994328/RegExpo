import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_config/app_config.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:components/components.dart';
import 'package:regexpo/src/models/models.dart';

import 'delete_record_panel.dart';
import 'edit_record_panel.dart';

class RecordTopBar extends StatelessWidget {
  const RecordTopBar({super.key});

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
            '选择记录',
            style: TextStyle(fontSize: 11),
          ),
          const SizedBox(width: 4,),
          RefreshIndicatorIcon(
            wait: Duration(seconds: 1),
            onRefresh: ()=>_onRefresh(context),
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
                child: EditRecordPanel(),
              ),
            ));
  }

  void showEditeDialog(BuildContext context) {
    RecordBloc bloc = context.read<RecordBloc>();
    Color color = Theme.of(context).backgroundColor;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 5),
          child:  Dialog(
            backgroundColor: color,
            child: EditRecordPanel(model: bloc.state.active,),
          ),
        ));
  }

  void showDeleteDialog(BuildContext context) {
    Color color = Theme.of(context).backgroundColor;

    RecordBloc bloc = context.read<RecordBloc>();
    Record? record = bloc.state.active;
    if(record == null) return;
    showDialog(
        context: context,
        builder: (_) => Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 4),
          child:  Dialog(
            backgroundColor: color,
            child: DeleteRecordPanel(model: record,),
          ),
        ));
  }

  void refresh(BuildContext context) {
    RecordBloc bloc = context.read<RecordBloc>();
    bloc.loadRecord(operation: LoadType.refresh);
  }

  Future<void> _onRefresh(BuildContext context) async{
    RecordBloc bloc = context.read<RecordBloc>();
    bloc.loadRecord(operation: LoadType.refresh);
  }
}
