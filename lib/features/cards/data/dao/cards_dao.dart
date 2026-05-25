import 'package:basa_app_project/core/database/external_database/external_database.dart';
import 'package:drift/drift.dart';

part 'cards_dao.g.dart';

@DriftAccessor()
class CardsDao extends DatabaseAccessor<ExternalDatabase> with _$CardsDaoMixin {
  CardsDao(super.attachedDatabase);
}
