// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pump_curve.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PumpCurveAdapter extends TypeAdapter<PumpCurve> {
  @override
  final int typeId = 3;

  @override
  PumpCurve read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PumpCurve(
      rpm: fields[0] as double,
      points: (fields[1] as List).cast<PumpCurvePoint>(),
    );
  }

  @override
  void write(BinaryWriter writer, PumpCurve obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.rpm)
      ..writeByte(1)
      ..write(obj.points);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PumpCurveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
