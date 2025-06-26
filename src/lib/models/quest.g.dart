// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 5;

  @override
  Quest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quest(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      type: fields[3] as QuestType,
      baseXP: fields[4] as int,
      dueDateTime: fields[5] as DateTime?,
      status: fields[6] as QuestStatus,
      createdAt: fields[7] as DateTime,
      completedAt: fields[8] as DateTime?,
      importance: fields[9] as int,
      isRecurrent: fields[10] as bool,
      xpEarned: fields[11] as int,
      xpLost: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
    writer
      ..writeByte(13)
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
      ..write(obj.dueDateTime)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.completedAt)
      ..writeByte(9)
      ..write(obj.importance)
      ..writeByte(10)
      ..write(obj.isRecurrent)
      ..writeByte(11)
      ..write(obj.xpEarned)
      ..writeByte(12)
      ..write(obj.xpLost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
