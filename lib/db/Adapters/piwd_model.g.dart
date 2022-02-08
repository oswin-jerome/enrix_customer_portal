// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'piwd_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PiwdAdapter extends TypeAdapter<Piwd> {
  @override
  final int typeId = 0;

  @override
  Piwd read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Piwd(
      type: fields[0] as String,
      data: (fields[1] as Map).cast<dynamic, dynamic>(),
      label: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Piwd obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.label);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PiwdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
