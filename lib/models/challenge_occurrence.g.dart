// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_occurrence.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChallengeOccurrenceAdapter extends TypeAdapter<ChallengeOccurrence> {
  @override
  final int typeId = 7;

  @override
  ChallengeOccurrence read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChallengeOccurrence(
      id: fields[0] as String,
      challengeId: fields[1] as String,
      reward: fields[2] as int,
      dateInstance: fields[3] as DateTime,
      completedAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChallengeOccurrence obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.challengeId)
      ..writeByte(2)
      ..write(obj.reward)
      ..writeByte(3)
      ..write(obj.dateInstance)
      ..writeByte(4)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChallengeOccurrenceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
