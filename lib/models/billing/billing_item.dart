import 'package:json_annotation/json_annotation.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
part 'billing_item.g.dart';

@JsonSerializable(explicitToJson: true)
class BillingItem {
  BillingItem(this.itemId, this.itemQuantity, this.itemRate) {
    itemAmount = (itemQuantity * itemRate);
  }

  BillingItem.withName(
      this.itemId, this.itemName, this.itemQuantity, this.itemRate) {
    itemAmount = (itemQuantity * itemRate);
  }

  static int length = 0;

  int itemId;

  String itemName = '';

  int itemQuantity;

  double itemRate;

  late double itemAmount;

  factory BillingItem.fromJson(Map<String, dynamic> json) =>
      _$BillingItemFromJson(json);
  Map<String, dynamic> toJson() => _$BillingItemToJson(this);

  DataGridRow toDataGridRow(String? name) {

    return DataGridRow(cells: <DataGridCell>[
      const DataGridCell<int>(columnName: 'srNo', value: 101),
      DataGridCell<int>(columnName: 'itemId', value: itemId),
      DataGridCell<String>(
          columnName: 'itemName', value: itemName.isEmpty ? name : itemName),
      DataGridCell<int>(columnName: 'itemQuantity', value: itemQuantity),
      DataGridCell<double>(columnName: 'itemRate', value: itemRate),
      DataGridCell<double>(columnName: 'itemAmount', value: itemAmount),
    ]);
    
  }
}
