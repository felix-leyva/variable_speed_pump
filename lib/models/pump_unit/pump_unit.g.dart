// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pump_unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PumpUnitAdapter extends TypeAdapter<PumpUnit> {
  @override
  final int typeId = 4;

  @override
  PumpUnit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PumpUnit(
      motor: fields[0] as Motor,
      pumpCurve: fields[1] as PumpCurve,
    )
      ..name = fields[2] as String
      ..key = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, PumpUnit obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.motor)
      ..writeByte(1)
      ..write(obj.pumpCurve)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PumpUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
