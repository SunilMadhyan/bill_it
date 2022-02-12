// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillingData _$BillingDataFromJson(Map<String, dynamic> json) => BillingData(
      json['billNo'] as int,
      json['billDate'],
      json['partyName'] as String,
      (json['discountApplied'] as num).toDouble(),
      (json['packingCharge'] as num).toDouble(),
      (json['totalNetAmount'] as num).toDouble(),
      (json['totalAmount'] as num).toDouble(),
      json['billNotes'] as String,
      (json['items'] as List<dynamic>)
          .map((e) => BillingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BillingDataToJson(BillingData instance) =>
    <String, dynamic>{
      'billNo': instance.billNo,
      'billDate': instance.billDate,
      'partyName': instance.partyName,
      'discountApplied': instance.discountApplied,
      'totalAmount': instance.totalAmount,
      'totalNetAmount': instance.totalNetAmount,
      'packingCharge': instance.packingCharge,
      'billNotes': instance.billNotes,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
