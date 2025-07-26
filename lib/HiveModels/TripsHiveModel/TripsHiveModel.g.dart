// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TripsHiveModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripsHiveModelAdapter extends TypeAdapter<TripsHiveModel> {
  @override
  final int typeId = 0;

  @override
  TripsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripsHiveModel(
      prompt: fields[0] as String,
      response: fields[1] as String,
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TripsHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.prompt)
      ..writeByte(1)
      ..write(obj.response)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
