import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:regexpo/src/models/link_regex/link_regex.dart';
import 'package:regexpo/src/models/record/record.dart';

import '../link_regex_repository.dart';
import '../recode_repository.dart';

class MemoryLinkRepository extends LinkRegexRepository{
  List<LinkRegex>? _cache;

  @override
  Future<List<LinkRegex>> queryLinkRegexByRecordId({required int recordId}) async{
    if(_cache==null){
      String dataStr = await rootBundle.loadString('assets/data.json');
      List<dynamic> data = json.decode(dataStr).toList();
      List<LinkRegex> result  = [];
      for (int i = 0; i < data.length; i++) {
        int id = i+1;

        await Future.delayed(const Duration(milliseconds: 1));
        List<dynamic> recommend = data[i]['recommend'];
        for (int j = 0; j < recommend.length; j++) {
          await Future.delayed(const Duration(milliseconds: 1));
          result.add(LinkRegex.i(
            id: i*1000+j,
              recordId: id,
              regex: recommend[j]
          ));
        }
      }
      _cache= result;
    }
    return _cache!.where((element) => element.recordId==recordId).toList();
  }

  @override
  Future<int> deleteById(int id) async{
      return 1;
  }

  @override
  Future<int> insert(LinkRegex record) async{
    return 1;
  }

  @override
  Future<int> update(LinkRegex record) async{
    return 1;
  }

}