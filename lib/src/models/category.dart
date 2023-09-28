import 'package:json_annotation/json_annotation.dart';

/// Something that's being tracked, e.g. Hours Slept, Cups of water, etc.
@JsonSerializable()
class CategoryModel {
  String name;

  @JsonKey(includeFromJson: false)
  String? id;

  CategoryModel(this.name);

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  operator ==(Object other) => other is CategoryModel && other.id == id;
  @override
  int get hashCode => id.hashCode;
  @override
  String toString() {
    return '<Category id=$id>';
  }
}

CategoryModel _$CategoryFromJson(Map<String, dynamic> json) {
  return CategoryModel(
    json['name'] as String,
  );
}

Map<String, dynamic> _$CategoryToJson(CategoryModel instance) => <String, dynamic>{
      'name': instance.name,
    };

