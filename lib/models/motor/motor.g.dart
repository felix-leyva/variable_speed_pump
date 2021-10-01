// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MotorAdapter extends TypeAdapter<Motor> {
  @override
  final int typeId = 2;

  @override
  Motor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Motor(
      fields[0] as double,
      frequency: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Motor obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.powerkW)
      ..writeByte(1)
      ..write(obj.frequency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MotorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
