abstract class BaseStringEntity extends BaseEntity<String> {
  @override
  String toString() {
    return '${runtimeType.toString()}/$id';
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
