import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';

class BlocWrapper extends StatelessWidget {
  final Widget child;

  const BlocWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppConfigBloc>(create: (_) => AppConfigBloc()),
        BlocProvider<RecordBloc>(create: (_) => RecordBloc()),
        BlocProvider<LinkRegexBloc>(create: (_) => LinkRegexBloc()),
        BlocProvider<MatchBloc>(create: (_) => MatchBloc()),
      ],
      child: child,
    );
  }
}
