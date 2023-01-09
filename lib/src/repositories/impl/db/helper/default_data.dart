// import 'dart:convert';
//
// import 'package:flutter/services.dart';
// import 'package:regexpo/src/models/link_regex/link_regex.dart';
// import 'package:regexpo/src/repositories/impl/db_link_regex_repository.dart';
// import 'package:regexpo/src/repositories/link_regex_repository.dart';
//
// import '../../db_recode_repository.dart';
// import '../../../../models/record/record.dart';
//
// class DefaultData {
//   static Future<void> insertDefaultRecoder() async {
//     DbRecoderRepository repository = const DbRecoderRepository();
//     LinkRegexRepository linkRegexRepository = const DbLinkRegexRepository();
//     String dataStr = await rootBundle.loadString('assets/data.json');
//     List<dynamic> data = json.decode(dataStr).reversed.toList();
//     for (int i = 0; i < data.length; i++) {
//       await Future.delayed(const Duration(milliseconds: 1));
//       int id =i+1;
//       repository.insert(Record.i(id:id,title: data[i]['title'], content: data[i]['content']));
//       List<dynamic> recommend = data[i]['recommend'];
//       for (int i = 0; i < recommend.length; i++) {
//         await Future.delayed(const Duration(milliseconds: 1));
//         linkRegexRepository.insert(LinkRegex.i(
//           recordId: id,
//           regex: recommend[i]
//         ));
//       }
//     }
//   }
//
//   static Future<void> insertLoadMoreRecoder() async {
//     DbRecoderRepository repository = const DbRecoderRepository();
//     int count = 200;
//     List<Record> records = [];
//     for (int i = 0; i < count; i++) {
//       await Future.delayed(const Duration(milliseconds: 2));
//       records.add(Record.i(
//           title: '测试小子 ${count - i}',
//           content: "我这是第 ${count - i} 个数据，是为了测试加载更多功能，而创建的临时数据。请大家多多指教~"));
//     }
//
//     for (int i = 0; i < records.length; i++) {
//       int a = await repository.insert(records[i]);
//     }
//   }
// }
