// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      json['itemId'] as int,
      json['itemName'] as String,
      json['itemQuantity'] as int,
      (json['itemRate'] as num).toDouble(),
    )
      ..itemAmount = (json['itemAmount'] as num).toDouble()
      ..available = json['available'] as bool
      ..availableQty = json['availableQty'] as int;

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemQuantity': instance.itemQuantity,
      'itemRate': instance.itemRate,
      'itemAmount': instance.itemAmount,
      'available': instance.available,
      'availableQty': instance.availableQty,
    };
