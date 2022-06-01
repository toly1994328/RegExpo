import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/reg_example.dart';
import 'state.dart';
import 'event.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {

  ExampleBloc():super( const EmptyExampleState()){
    on<FetchExample>(_onFetchExample);
  }


  void _onFetchExample(FetchExample event, Emitter<ExampleState> emit) async{
    String dataStr = await rootBundle.loadString('assets/data.json');
    List<RegExample> items = json
        .decode(dataStr)
        .map<RegExample>((e) => RegExample.fromJson((e)))
        .toList();
    emit(FullExampleState(data: items));
  }
}
