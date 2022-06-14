import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../app/res/gap.dart';
import '../bloc/bloc_exp.dart';
import 'foot_bar.dart';
import 'nav_bar.dart';
import 'nav_content.dart';
import '../../content/views/main_content.dart';
import 'tab_bar.dart';
import 'top_bar.dart';

class AppNavigation extends StatelessWidget {
  const AppNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavItemList navItemList = BlocProvider.of<NavCubit>(context).state;
    return Scaffold(
        body: Column(children: [
          const TopBar(),
          Gap.dividerH,
          Expanded(
            child: Row(
              children: [
                const NavBar(left: true,),
                Gap.dividerV,
                const NavContent(left: true,),
                Expanded(child: _buildContent()),
                const NavContent(left: false,),
                Gap.dividerV,
                const NavBar(left: false),
              ],
            ),
          ),
          Gap.dividerH,
          const FootBar()
        ]));
  }

  Widget _buildContent() {
    return Column(
      children: const [
        MultiTabBar(),
        Gap.dividerH,
        Expanded(child: MainContent()),
      ],
    );
  }
}