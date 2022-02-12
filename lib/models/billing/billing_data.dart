import 'package:json_annotation/json_annotation.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'billing_item.dart';

part 'billing_data.g.dart';

@JsonSerializable(explicitToJson: true)
class BillingData {
  final int billNo;

  dynamic billDate;

  String partyName;

  double discountApplied;

  double totalAmount;

  double totalNetAmount;

  double packingCharge;

  String billNotes;

  List<BillingItem> items;

  BillingData(
      this.billNo,
      this.billDate,
      this.partyName,
      this.discountApplied,
      this.packingCharge,
      this.totalNetAmount,
      this.totalAmount,
      this.billNotes,
      this.items);

  factory BillingData.fromJson(Map<String, dynamic> json) =>
      _$BillingDataFromJson(json);
  Map<String, dynamic> toJson() => _$BillingDataToJson(this);

  // ToDo extract generating rows outside BillingData Model
  List<DataGridRow> getDataGridRow() {
    return items.map((item) => (item.toDataGridRow())).toList();
  }
}
