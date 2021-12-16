import 'package:flutter/material.dart';

class NoteFields {
  static final List<String> values = [
    id,
    number,
    title,
    text,
    date
  ];

  static final String id = '_id';
  static final String number = 'number';
  static final String title = 'title';
  static final String text = 'text';
  static final String date = 'date';
}

class NoteModel {
  const NoteModel({
    this.id,
    required this.number,
    required this.title,
    required this.text,
    required this.creationDate,
  });

  final int? id;
  final int? number;
  final String? title;
  final String? text;
  final DateTime creationDate;

  NoteModel copy({
    int? id,
    int? number,
    String? title,
    String? text,
    DateTime? creationDate,
  }) =>
      NoteModel(
        id: id ?? this.id,
        number: number ?? this.number,
        title: title ?? this.title,
        text: text ?? this.text,
        creationDate: creationDate ?? this.creationDate,
      );

  static NoteModel fromMap(Map<String, Object?> map) => NoteModel(
        id: map[NoteFields.id] as int?,
        number: map[NoteFields.number] as int?,
        title: map[NoteFields.title] as String?,
        text: map[NoteFields.text] as String?,
        creationDate: DateTime.parse(map[NoteFields.date] as String),
      );

  //function to convert our item into map
  Map<String, Object?> toMap() => {
      NoteFields.id: id,
      NoteFields.title: title,
      NoteFields.number: number,
      NoteFields.text: text,
      NoteFields.date: creationDate.toIso8601String(),
  };
}
