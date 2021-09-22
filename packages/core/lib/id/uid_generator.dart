import 'package:artech_core/id/generator.dart';
import 'package:uuid/uuid.dart';

const uid = Uuid();

class UIdGenerator extends IdGenerator {
  @override
  Future<String> generate() async {
    return uid.v4();
  }
}
