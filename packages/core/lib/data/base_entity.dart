//TODO(goxiaoy):cannot extend BaseEntity due to dart compiler
abstract class BaseStringEntity {
  String get id;

  set id(String id);

  Map<String, dynamic> toJson();

  @override
  String toString() {
    return '${runtimeType.toString()}/$id';
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is BaseStringEntity) {
      return other.id == id;
    }
    return false;
  }
}

abstract class BaseEntity<T> {
  T get id;

  set id(T id);

  Map<String, dynamic> toJson();

  @override
  String toString() {
    return '${runtimeType.toString()}/$id';
  }
}

//
// abstract class BaseStringEntity extends BaseEntity<String?>{
//
// }
