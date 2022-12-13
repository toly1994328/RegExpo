import 'db/local_db.dart';
import '../../models/record/record.dart';

import '../recode_repository.dart';
import 'db/dao/record_dao.dart';

class DbRecoderRepository implements RecoderRepository{

  const DbRecoderRepository();

  RecoderDao get dao  => LocalDb.instance.recoderDao;

  @override
  Future<int> deleteById(int id) {
    return dao.deleteById(id);
  }

  @override
  Future<int> insert(Record record) {
    return dao.insert(record);
  }

  @override
  Future<List<Record>> search({int page = 1, int pageSize = 25, String? arg}) async{
    List<Map<String, Object?>> result = await dao.search(page,pageSize,arg);
    return result.map(Record.fromJson).toList();
  }

  @override
  Future<int> update(Record record) {
    return dao.update(record);
  }

}