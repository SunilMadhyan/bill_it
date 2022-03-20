import 'package:json_annotation/json_annotation.dart';

import 'billing_item.dart';

part 'billing_data.g.dart';

@JsonSerializable(explicitToJson: true)
class BillingData {
  BillingData(
      {this.billNo = 0,
      this.billDate,
      this.partyName = '',
      this.partyGSTNo = '',
      this.discountApplied = 0,
      this.packingCharge = 0,
      this.totalNetAmount = 0,
      this.totalAmount = 0,
      this.billNotes = '',
      this.items = const []});

  final int billNo;

  dynamic billDate;

  String partyName;

  String partyGSTNo;

  double discountApplied;

  double totalAmount;

  double totalNetAmount;

  double packingCharge;

  String billNotes;

  List<BillingItem> items;

  factory BillingData.fromJson(Map<String, dynamic> json) =>
      _$BillingDataFromJson(json);
  Map<String, dynamic> toJson() => _$BillingDataToJson(this);
}
