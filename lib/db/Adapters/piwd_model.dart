import 'package:hive/hive.dart';

part 'piwd_model.g.dart';

@HiveType(typeId: 0)
class Piwd {
  @HiveField(0)
  final String? type;

  @HiveField(1)
  final Map? data;

  @HiveField(2)
  final String? label;
  Piwd({this.type, this.data, this.label});
}
