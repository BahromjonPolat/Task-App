import 'package:flutter/material.dart';

class Task {
  int? _id;
  String? _title;
  String? _subTitle;
  String? _imageUrl;
  String? _priority;

  Task(this._title, this._subTitle, this._priority, this._imageUrl);

  Task.fromJson(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _subTitle = map['subtitle'];
    _priority = map['priority'];
    _imageUrl = map['imageUrl'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};

    map['title'] = _title;
    map['subtitle'] = _subTitle;
    map['priority'] = _priority;
    map['imageUrl'] = _imageUrl;

    return map;
  }

  String get priority => _priority!;

  String get imageUrl => _imageUrl!;

  String get subTitle => _subTitle!;

  String get title => _title!;

  int get id => _id!;
}
