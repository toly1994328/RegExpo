import '../models/record/record.dart';

abstract class RecoderRepository {
  /// 查询记录
  Future<List<Record>> search({
    int page = 1,
    int pageSize = 25,
    String? arg,
  });

  /// 插入记录
  Future<int> insert(Record record);

  /// 根据 [id] 删除记录
  Future<int> deleteById(int id);

  /// 修改记录
  Future<int> update(Record record);
}
