// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageHiveModelAdapter extends TypeAdapter<MessageHiveModel> {
  @override
  final int typeId = 0;

  @override
  MessageHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageHiveModel()
      ..id = fields[0] as String
      ..senderId = fields[1] as String
      ..senderRegNo = fields[2] as String
      ..senderNumber = fields[3] as String
      ..senderName = fields[4] as String
      ..receiverId = fields[5] as String
      ..receiverRegNo = fields[6] as String
      ..receiverNumber = fields[7] as String
      ..receiverName = fields[8] as String
      ..textMasseg = fields[9] as String
      ..datetime = fields[10] as DateTime
      ..massageStatus = fields[11] as String;
  }

  @override
  void write(BinaryWriter writer, MessageHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.senderId)
      ..writeByte(2)
      ..write(obj.senderRegNo)
      ..writeByte(3)
      ..write(obj.senderNumber)
      ..writeByte(4)
      ..write(obj.senderName)
      ..writeByte(5)
      ..write(obj.receiverId)
      ..writeByte(6)
      ..write(obj.receiverRegNo)
      ..writeByte(7)
      ..write(obj.receiverNumber)
      ..writeByte(8)
      ..write(obj.receiverName)
      ..writeByte(9)
      ..write(obj.textMasseg)
      ..writeByte(10)
      ..write(obj.datetime)
      ..writeByte(11)
      ..write(obj.massageStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
