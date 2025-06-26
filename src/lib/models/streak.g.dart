// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StreakAdapter extends TypeAdapter<Streak> {
  @override
  final int typeId = 7;

  @override
  Streak read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Streak(
      id: fields[0] as String,
      dailyQuestId: fields[1] as String,
      currentStreak: fields[2] as int,
      bestStreak: fields[3] as int,
      lastCompletedDate: fields[4] as DateTime?,
      streakStartDate: fields[5] as DateTime?,
      isActive: fields[6] as bool,
      totalBreaks: fields[7] as int,
      lastBreakDate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Streak obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dailyQuestId)
      ..writeByte(2)
      ..write(obj.currentStreak)
      ..writeByte(3)
      ..write(obj.bestStreak)
      ..writeByte(4)
      ..write(obj.lastCompletedDate)
      ..writeByte(5)
      ..write(obj.streakStartDate)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.totalBreaks)
      ..writeByte(8)
      ..write(obj.lastBreakDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
