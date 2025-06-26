// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_completion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestCompletionAdapter extends TypeAdapter<QuestCompletion> {
  @override
  final int typeId = 8;

  @override
  QuestCompletion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestCompletion(
      id: fields[0] as String,
      questId: fields[1] as String,
      completedAt: fields[2] as DateTime,
      xpEarned: fields[3] as int,
      isDaily: fields[4] as bool,
      streakCount: fields[5] as int?,
      wasOverdue: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, QuestCompletion obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questId)
      ..writeByte(2)
      ..write(obj.completedAt)
      ..writeByte(3)
      ..write(obj.xpEarned)
      ..writeByte(4)
      ..write(obj.isDaily)
      ..writeByte(5)
      ..write(obj.streakCount)
      ..writeByte(6)
      ..write(obj.wasOverdue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestCompletionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
