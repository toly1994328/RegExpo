import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/repositories/recode_repository.dart';

import '../repositories/impl/memory_link_repository.dart';
import '../repositories/impl/memory_record_repository.dart';
import '../repositories/link_regex_repository.dart';

class BlocWrapper extends StatelessWidget {
  final Widget child;

  BlocWrapper({super.key, required this.child});


  final RecoderRepository repository = MemoryRecordRepository();
  final LinkRegexRepository linkRegexRepository =  MemoryLinkRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppConfigBloc>(create: (_) => AppConfigBloc()),
        BlocProvider<RecordBloc>(create: (_) => RecordBloc(
          repository: repository
        )),
        BlocProvider<LinkRegexBloc>(create: (_) => LinkRegexBloc(
          repository: linkRegexRepository
        )),
        BlocProvider<MatchBloc>(create: (_) => MatchBloc()),
      ],
      child: child,
    );
  }
}
