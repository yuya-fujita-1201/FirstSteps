// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MilestoneRecordAdapter extends TypeAdapter<MilestoneRecord> {
  @override
  final int typeId = 1;

  @override
  MilestoneRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MilestoneRecord(
      id: fields[0] as String,
      milestoneName: fields[1] as String,
      category: fields[2] as String,
      achievedDate: fields[3] as DateTime,
      photoPath: fields[4] as String?,
      memo: fields[5] as String?,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      ageInMonthsWhenAchieved: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MilestoneRecord obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.milestoneName)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.achievedDate)
      ..writeByte(4)
      ..write(obj.photoPath)
      ..writeByte(5)
      ..write(obj.memo)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.ageInMonthsWhenAchieved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MilestoneRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
