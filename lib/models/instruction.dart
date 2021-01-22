// Copyright (c) 2017, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'instruction.g.dart';

@JsonSerializable(nullable: false)
class Stept {
  final String step;

  Stept({this.step});
  factory Stept.fromJson(Map<String, dynamic> json) => _$SteptFromJson(json);
  Map<String, dynamic> toJson() => _$SteptToJson(this);
}
