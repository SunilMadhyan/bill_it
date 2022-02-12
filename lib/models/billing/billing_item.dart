import 'package:json_annotation/json_annotation.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
part 'billing_item.g.dart';

@JsonSerializable(explicitToJson: true)
class BillingItem {
  BillingItem(this.itemId, this.itemQuantity, this.itemRate) {
    itemAmount = (itemQuantity * itemRate);
    srNo = ++length;
  }

  BillingItem.withName(
      this.itemId, this.itemName, this.itemQuantity, this.itemRate) {
    itemAmount = (itemQuantity * itemRate);
    srNo = ++length;
  }

  static int length = 0;

  int itemId;

  String itemName = '';

  int itemQuantity;

  double itemRate;

  late int srNo;

  late double itemAmount;

  factory BillingItem.fromJson(Map<String, dynamic> json) =>
      _$BillingItemFromJson(json);
  Map<String, dynamic> toJson() => _$BillingItemToJson(this);

  DataGridRow toDataGridRow() {
    return DataGridRow(cells: <DataGridCell>[
      DataGridCell<int>(columnName: 'srNo', value: srNo),
      DataGridCell<int>(columnName: 'itemId', value: itemId),
      DataGridCell<String>(columnName: 'itemName', value: itemName),
      DataGridCell<int>(columnName: 'itemQuantity', value: itemQuantity),
      DataGridCell<double>(columnName: 'itemRate', value: itemRate),
      DataGridCell<double>(columnName: 'itemAmount', value: itemAmount),
    ]);
  }
}
