// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vod_content.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VODContentAdapter extends TypeAdapter<VODContent> {
  @override
  final int typeId = 2;

  @override
  VODContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VODContent(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as VODType,
      streamUrl: fields[3] as String,
      posterUrl: fields[4] as String?,
      backdropUrl: fields[5] as String?,
      overview: fields[6] as String?,
      rating: fields[7] as double?,
      year: fields[8] as int?,
      genres: (fields[9] as List?)?.cast<String>(),
      tmdbId: fields[10] as int?,
      isFavorite: fields[11] as bool,
      continueAt: fields[12] as int?,
      lastWatched: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, VODContent obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.streamUrl)
      ..writeByte(4)
      ..write(obj.posterUrl)
      ..writeByte(5)
      ..write(obj.backdropUrl)
      ..writeByte(6)
      ..write(obj.overview)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.year)
      ..writeByte(9)
      ..write(obj.genres)
      ..writeByte(10)
      ..write(obj.tmdbId)
      ..writeByte(11)
      ..write(obj.isFavorite)
      ..writeByte(12)
      ..write(obj.continueAt)
      ..writeByte(13)
      ..write(obj.lastWatched);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VODContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VODTypeAdapter extends TypeAdapter<VODType> {
  @override
  final int typeId = 3;

  @override
  VODType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VODType.movie;
      case 1:
        return VODType.series;
      default:
        return VODType.movie;
    }
  }

  @override
  void write(BinaryWriter writer, VODType obj) {
    switch (obj) {
      case VODType.movie:
        writer.writeByte(0);
        break;
      case VODType.series:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VODTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
