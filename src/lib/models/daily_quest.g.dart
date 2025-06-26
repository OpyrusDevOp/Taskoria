// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_quest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyQuestAdapter extends TypeAdapter<DailyQuest> {
  @override
  final int typeId = 6;

  @override
  DailyQuest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyQuest(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      type: fields[3] as QuestType,
      baseXP: fields[4] as int,
      frequency: fields[5] as QuestFrequency,
      startWeekday: fields[6] as int,
      startDate: fields[7] as DateTime,
      nextOccurrence: fields[8] as DateTime?,
      isActive: fields[9] as bool,
      createdAt: fields[10] as DateTime,
      importance: fields[11] as int,
      lastCompletedAt: fields[12] as DateTime?,
      totalCompletions: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DailyQuest obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.baseXP)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.startWeekday)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.nextOccurrence)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.importance)
      ..writeByte(12)
      ..write(obj.lastCompletedAt)
      ..writeByte(13)
      ..write(obj.totalCompletions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyQuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
