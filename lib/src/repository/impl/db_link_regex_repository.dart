import '../link_regex_repository.dart';
import 'db/dao/link_regex_dao.dart';
import 'db/local_db.dart';
import '../../models/link_regex/link_regex.dart';

class DbLinkRegexRepository implements LinkRegexRepository{
  const DbLinkRegexRepository();

  LinkRegexDao get dao  => LocalDb.instance.linkRegexDao;

  @override
  Future<int> deleteById(int id) => dao.deleteById(id);

  @override
  Future<int> insert(LinkRegex record) => dao.insert(record);

  @override
  Future<List<LinkRegex>> queryLinkRegexByRecordId({required int recordId}) async{
    List<Map<String, Object?>> result = await dao.queryLinkRegexByRecordId(recordId);
    return result.map(LinkRegex.fromJson).toList();
  }

  @override
  Future<int> update(LinkRegex record)  => dao.update(record);
}