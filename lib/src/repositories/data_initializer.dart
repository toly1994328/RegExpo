import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/record/record.dart';
import '../models/link_regex/link_regex.dart';
import 'recode_repository.dart';
import 'link_regex_repository.dart';
import 'impl/db_recode_repository.dart';
import 'impl/db_link_regex_repository.dart';

class DataInitializer {
  static final RecoderRepository _recordRepository = const DbRecoderRepository();
  static final LinkRegexRepository _linkRegexRepository = const DbLinkRegexRepository();

  static Future<void> initializeDataIfNeeded() async {
    try {
      // 检查数据库是否有数据
      List<Record> existingRecords = await _recordRepository.search(page: 1, pageSize: 1);
      
      if (existingRecords.isEmpty) {
        // 数据库为空，插入初始数据
        await _insertInitialData();
      }
    } catch (e) {
      print('数据初始化失败: $e');
    }
  }

  static Future<void> _insertInitialData() async {
    try {
      // 读取 assets/data.json 文件
      String jsonString = await rootBundle.loadString('assets/data.json');
      List<dynamic> jsonData = json.decode(jsonString);

      // 将 JSON 数据转换为 Record 对象并插入数据库（倒序插入）
      for (var item in jsonData.reversed) {
        Record record = Record.i(
          title: item['title'] ?? '',
          content: item['content'] ?? '',
        );
        int recordId = await _recordRepository.insert(record);
        
        // 插入关联正则表达式
        List<dynamic> recommend = item['recommend'] ?? [];
        for (String regex in recommend) {
          LinkRegex linkRegex = LinkRegex.i(
            regex: regex,
            recordId: recordId,
          );
          await _linkRegexRepository.insert(linkRegex);
        }
      }
      
      print('初始数据插入成功，共插入 ${jsonData.length} 条记录');
    } catch (e) {
      print('插入初始数据失败: $e');
    }
  }
}