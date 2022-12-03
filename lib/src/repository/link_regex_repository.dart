import '../models/link_regex/link_regex.dart';

abstract class LinkRegexRepository {
  /// 查询关联正则
  Future<List<LinkRegex>> queryLinkRegexByRecordId({
   required int recordId,
  });

  /// 插入关联正则
  Future<int> insert(LinkRegex record);

  /// 根据 [id] 删除关联正则
  Future<int> deleteById(int id);

  /// 修改关联正则
  Future<int> update(LinkRegex record);
}
