import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/reg_example.dart';
import 'state.dart';
import 'event.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {

  ExampleBloc():super( const EmptyExampleState()){
    on<FetchExample>(_onFetchExample);
    on<AddExample>(_onAddExample);
    on<RemoveExample>(_onRemoveExample);
  }


  void _onFetchExample(FetchExample event, Emitter<ExampleState> emit) async{
    String dataStr = await rootBundle.loadString('assets/data.json');
    List<RegExample> items = json
        .decode(dataStr)
        .map<RegExample>((e) => RegExample.fromJson((e)))
        .toList();
    emit(FullExampleState(data: items));
  }

  void _onAddExample(AddExample event, Emitter<ExampleState> emit) {
    List<RegExample> data = [];
     if(state is FullExampleState){
       data = (state as FullExampleState).data;
     }
    data.insert(0, event.example);
emit(FullExampleState(data: data));
  }

  void _onRemoveExample(RemoveExample event, Emitter<ExampleState> emit) {
    if(state is FullExampleState){
      List<RegExample> data = (state as FullExampleState).data;
      data.removeWhere((element) => element.id==event.id);
      if(data.isNotEmpty){
        emit(FullExampleState(data: data));
      }else{
        emit(const EmptyExampleState());
      }
    }
  }
}
