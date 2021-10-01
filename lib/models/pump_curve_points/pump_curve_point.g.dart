// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pump_curve_point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PumpCurvePointAdapter extends TypeAdapter<PumpCurvePoint> {
  @override
  final int typeId = 1;

  @override
  PumpCurvePoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PumpCurvePoint()
      ..rpm = fields[0] as double
      ..flow = fields[1] as double
      ..head = fields[2] as double
      ..pumpEndEff = fields[3] as double;
  }

  @override
  void write(BinaryWriter writer, PumpCurvePoint obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.rpm)
      ..writeByte(1)
      ..write(obj.flow)
      ..writeByte(2)
      ..write(obj.head)
      ..writeByte(3)
      ..write(obj.pumpEndEff);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PumpCurvePointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
