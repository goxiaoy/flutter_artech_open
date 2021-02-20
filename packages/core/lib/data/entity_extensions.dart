import 'base_entity.dart';

extension BaseEntityCompareExtension on BaseStringEntity {
  bool idEqual(BaseStringEntity other) {
    return other.id == id;
  }
}
