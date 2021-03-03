import 'base_entity.dart';

extension BaseEntityCompareExtension on BaseStringEntity {
  bool idEqual(BaseStringEntity other) {
    if (runtimeType == other.runtimeType) {
      return other.id == id;
    }
    return false;
  }
}
