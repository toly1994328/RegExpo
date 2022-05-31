import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../navigation/bloc/bloc_exp.dart';
import '../../navigation/bloc/nav_cubic.dart';


class BlocWrapper extends StatefulWidget {
  final Widget child;

  const BlocWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<BlocWrapper> createState() => _BlocWrapperState();
}

class _BlocWrapperState extends State<BlocWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SelectionCubit>(
          create: (context) => SelectionCubit(),
        ),
        BlocProvider<TabCubit>(
          create: (context) => TabCubit(),
        ),
        BlocProvider<NavCubit>(
          create: (context) => NavCubit(),
        ),
      ],
      child: widget.child,
    );
  }
}
