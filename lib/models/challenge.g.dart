// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChallengeAdapter extends TypeAdapter<Challenge> {
  @override
  final int typeId = 6;

  @override
  Challenge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Challenge(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      baseReward: fields[3] as int,
      frequency: fields[4] as QuestFrequency,
      startingDay: fields[5] as DateTime,
      createdAt: fields[6] as DateTime,
      completedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Challenge obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.baseReward)
      ..writeByte(4)
      ..write(obj.frequency)
      ..writeByte(5)
      ..write(obj.startingDay)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
