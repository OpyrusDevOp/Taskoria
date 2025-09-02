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
