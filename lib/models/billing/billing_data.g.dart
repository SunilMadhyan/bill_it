// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillingData _$BillingDataFromJson(Map<String, dynamic> json) => BillingData(
      billNo: json['billNo'] as int? ?? 0,
      billDate: json['billDate'],
      partyName: json['partyName'] as String? ?? '',
      partyGSTNo: json['partyGSTNo'] as String? ?? '',
      discountApplied: (json['discountApplied'] as num?)?.toDouble() ?? 0,
      packingCharge: (json['packingCharge'] as num?)?.toDouble() ?? 0,
      totalNetAmount: (json['totalNetAmount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      billNotes: json['billNotes'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => BillingItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BillingDataToJson(BillingData instance) =>
    <String, dynamic>{
      'billNo': instance.billNo,
      'billDate': instance.billDate,
      'partyName': instance.partyName,
      'partyGSTNo': instance.partyGSTNo,
      'discountApplied': instance.discountApplied,
      'totalAmount': instance.totalAmount,
      'totalNetAmount': instance.totalNetAmount,
      'packingCharge': instance.packingCharge,
      'billNotes': instance.billNotes,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
