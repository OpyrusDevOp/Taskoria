// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserRankAdapter extends TypeAdapter<UserRank> {
  @override
  final int typeId = 1;

  @override
  UserRank read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserRank.newcomer;
      case 1:
        return UserRank.adventurer;
      case 2:
        return UserRank.explorer;
      case 3:
        return UserRank.questSeeker;
      case 4:
        return UserRank.trailblazer;
      case 5:
        return UserRank.pathfinder;
      case 6:
        return UserRank.taskSlayer;
      case 7:
        return UserRank.heroicAchiever;
      case 8:
        return UserRank.legendaryHunter;
      case 9:
        return UserRank.mastermind;
      case 10:
        return UserRank.questLegend;
      case 11:
        return UserRank.ultimateTasker;
      case 12:
        return UserRank.taskMaster;
      default:
        return UserRank.newcomer;
    }
  }

  @override
  void write(BinaryWriter writer, UserRank obj) {
    switch (obj) {
      case UserRank.newcomer:
        writer.writeByte(0);
        break;
      case UserRank.adventurer:
        writer.writeByte(1);
        break;
      case UserRank.explorer:
        writer.writeByte(2);
        break;
      case UserRank.questSeeker:
        writer.writeByte(3);
        break;
      case UserRank.trailblazer:
        writer.writeByte(4);
        break;
      case UserRank.pathfinder:
        writer.writeByte(5);
        break;
      case UserRank.taskSlayer:
        writer.writeByte(6);
        break;
      case UserRank.heroicAchiever:
        writer.writeByte(7);
        break;
      case UserRank.legendaryHunter:
        writer.writeByte(8);
        break;
      case UserRank.mastermind:
        writer.writeByte(9);
        break;
      case UserRank.questLegend:
        writer.writeByte(10);
        break;
      case UserRank.ultimateTasker:
        writer.writeByte(11);
        break;
      case UserRank.taskMaster:
        writer.writeByte(12);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRankAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestTypeAdapter extends TypeAdapter<QuestType> {
  @override
  final int typeId = 3;

  @override
  QuestType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestType.main;
      case 1:
        return QuestType.side;
      case 2:
        return QuestType.event;
      case 3:
        return QuestType.urgent;
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
      case QuestType.event:
        writer.writeByte(2);
        break;
      case QuestType.urgent:
        writer.writeByte(3);
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
  final int typeId = 4;

  @override
  QuestStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestStatus.pending;
      case 1:
        return QuestStatus.completed;
      case 2:
        return QuestStatus.failed;
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
      case QuestStatus.completed:
        writer.writeByte(1);
        break;
      case QuestStatus.failed:
        writer.writeByte(2);
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
