import 'package:app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:components/components.dart';


import 'link_regex_top_bar.dart';
import 'loaded_regex_panel.dart';



class LinkRegexPanel extends StatelessWidget {
  const LinkRegexPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const LinkRegexTopBar(),
        Gap.dividerH,
        Expanded(
          child: BlocBuilder<LinkRegexBloc, LinkRegexState>(
            builder: (_, state) => _buildByState(state),
          ),
        )
      ],
    );
  }

  Widget _buildByState(LinkRegexState state) {
    if (state is LoadingLinkRegexState) {
      return const LoadingPanel();
    }
    if (state is EmptyLinkRegexState) {
      return const EmptyPanel(
        data: "暂无关联正则",
        icon: TolyIcon.icon_empty_panel,
      );
    }
    if (state is ErrorLinkRegexState) {
      return ErrorPanel(
        data: "数据查询异常",
        icon: TolyIcon.zanwushuju,
        error: state.error,
      );
    }
    if (state is LoadedLinkRegexState) {
      return LoadedRegexPanel(
        state: state,
      );
    }
    return const SizedBox();
  }
}
