// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillingItem _$BillingItemFromJson(Map<String, dynamic> json) => BillingItem(
      json['itemId'] as int,
      json['itemQuantity'] as int,
      (json['itemRate'] as num).toDouble(),
    )
      ..itemName = json['itemName'] as String
      ..itemAmount = (json['itemAmount'] as num).toDouble();

Map<String, dynamic> _$BillingItemToJson(BillingItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemQuantity': instance.itemQuantity,
      'itemRate': instance.itemRate,
      'itemAmount': instance.itemAmount,
    };
