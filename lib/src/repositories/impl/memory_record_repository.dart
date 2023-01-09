import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:regexpo/src/models/record/record.dart';

import '../recode_repository.dart';

class MemoryRecordRepository extends RecoderRepository{

  List<Record>? _cache;

  @override
  Future<int> deleteById(int id) async{
    _cache?.removeWhere((e)=>e.id==id);
    return 1;
  }

  @override
  Future<int> insert(Record record)async{
    _cache?.insert(0,record);
    return 1;
  }

  @override
  Future<List<Record>> search({int page = 1, int pageSize = 25, String? arg}) async{
    if(_cache==null){
      String dataStr = await rootBundle.loadString('assets/data.json');
      List<dynamic> data = json.decode(dataStr).toList();
      List<Record> result  = [];
      for (int i = 0; i < data.length; i++) {
        await Future.delayed(const Duration(milliseconds: 1));
        int id =i+1;
        result.add(Record.i(id:id,title: data[i]['title'], content: data[i]['content']));
      }
      _cache = result;
    }
    return List.of(_cache!);
  }

  @override
  Future<int> update(Record record)async {
    int index = _cache!.lastIndexWhere((e) => e.id==record.id);
    _cache![index] = record;
    return 1;
  }

}