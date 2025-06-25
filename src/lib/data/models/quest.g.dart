// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurrencePatternAdapter extends TypeAdapter<RecurrencePattern> {
  @override
  final int typeId = 5;

  @override
  RecurrencePattern read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurrencePattern(
      type: fields[0] as RecurrenceType,
      interval: fields[1] as int?,
      startDay: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RecurrencePattern obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.interval)
      ..writeByte(2)
      ..write(obj.startDay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrencePatternAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StreakDataAdapter extends TypeAdapter<StreakData> {
  @override
  final int typeId = 6;

  @override
  StreakData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StreakData(
      current: fields[0] as int,
      best: fields[1] as int,
      lastCompleted: fields[2] as DateTime?,
      nextDue: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, StreakData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.current)
      ..writeByte(1)
      ..write(obj.best)
      ..writeByte(2)
      ..write(obj.lastCompleted)
      ..writeByte(3)
      ..write(obj.nextDue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 7;

  @override
  Quest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quest(
      id: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as QuestType,
      baseXP: fields[4] as int,
      difficulty: fields[5] as QuestDifficulty,
      status: fields[6] as QuestStatus,
      priority: fields[7] as Priority,
      category: fields[8] as String,
      createdAt: fields[9] as DateTime?,
      dueDate: fields[10] as DateTime?,
      completedAt: fields[11] as DateTime?,
      recurrencePattern: fields[12] as RecurrencePattern?,
      streak: fields[13] as StreakData?,
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
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
      ..write(obj.difficulty)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.priority)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.dueDate)
      ..writeByte(11)
      ..write(obj.completedAt)
      ..writeByte(12)
      ..write(obj.recurrencePattern)
      ..writeByte(13)
      ..write(obj.streak);
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

class QuestTypeAdapter extends TypeAdapter<QuestType> {
  @override
  final int typeId = 0;

  @override
  QuestType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestType.main;
      case 1:
        return QuestType.side;
      case 2:
        return QuestType.recurrent;
      case 3:
        return QuestType.challenge;
      case 4:
        return QuestType.urgent;
      case 5:
        return QuestType.event;
      default:
        return QuestType.main;
    }
  }

  @override
  void write(BinaryWriter writer, QuestType obj) {
    switch (obj) {
      case QuestType.main:
        writer.writeByte(0);
        break;
      case QuestType.side:
        writer.writeByte(1);
        break;
      case QuestType.recurrent:
        writer.writeByte(2);
        break;
      case QuestType.challenge:
        writer.writeByte(3);
        break;
      case QuestType.urgent:
        writer.writeByte(4);
        break;
      case QuestType.event:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestStatusAdapter extends TypeAdapter<QuestStatus> {
  @override
  final int typeId = 1;

  @override
  QuestStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestStatus.pending;
      case 1:
        return QuestStatus.due;
      case 2:
        return QuestStatus.overdue;
      case 3:
        return QuestStatus.completed;
      case 4:
        return QuestStatus.missed;
      default:
        return QuestStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, QuestStatus obj) {
    switch (obj) {
      case QuestStatus.pending:
        writer.writeByte(0);
        break;
      case QuestStatus.due:
        writer.writeByte(1);
        break;
      case QuestStatus.overdue:
        writer.writeByte(2);
        break;
      case QuestStatus.completed:
        writer.writeByte(3);
        break;
      case QuestStatus.missed:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestDifficultyAdapter extends TypeAdapter<QuestDifficulty> {
  @override
  final int typeId = 2;

  @override
  QuestDifficulty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestDifficulty.easy;
      case 1:
        return QuestDifficulty.medium;
      case 2:
        return QuestDifficulty.hard;
      default:
        return QuestDifficulty.easy;
    }
  }

  @override
  void write(BinaryWriter writer, QuestDifficulty obj) {
    switch (obj) {
      case QuestDifficulty.easy:
        writer.writeByte(0);
        break;
      case QuestDifficulty.medium:
        writer.writeByte(1);
        break;
      case QuestDifficulty.hard:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestDifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PriorityAdapter extends TypeAdapter<Priority> {
  @override
  final int typeId = 3;

  @override
  Priority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Priority.low;
      case 1:
        return Priority.medium;
      case 2:
        return Priority.high;
      default:
        return Priority.low;
    }
  }

  @override
  void write(BinaryWriter writer, Priority obj) {
    switch (obj) {
      case Priority.low:
        writer.writeByte(0);
        break;
      case Priority.medium:
        writer.writeByte(1);
        break;
      case Priority.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurrenceTypeAdapter extends TypeAdapter<RecurrenceType> {
  @override
  final int typeId = 4;

  @override
  RecurrenceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurrenceType.daily;
      case 1:
        return RecurrenceType.interval;
      case 2:
        return RecurrenceType.weekly;
      default:
        return RecurrenceType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, RecurrenceType obj) {
    switch (obj) {
      case RecurrenceType.daily:
        writer.writeByte(0);
        break;
      case RecurrenceType.interval:
        writer.writeByte(1);
        break;
      case RecurrenceType.weekly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
