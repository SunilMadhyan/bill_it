import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'billing/billing_data.dart';
import 'item/item.dart';

class BillingDataSource extends DataGridSource {
  @override
  List<DataGridRow> get rows => _currentBillingData;
  Map<String, Item> availableItems;
  BillingData currentBillingData;
  List<DataGridRow> _currentBillingData = [];
  dynamic newCellValue;
  Function onUpdate;

  TextEditingController editingController = TextEditingController();
  BillingDataSource(
      this.currentBillingData, this.availableItems, this.onUpdate) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    _currentBillingData = currentBillingData.items
        .mapIndexed((index, element) => element.toDataGridRow(
            index, availableItems['${element.itemId}']?.itemName))
        .toList();
    // .map<DataGridRow>(
    //     (e) => e.toDataGridRow(availableItems['${e.itemId}']?.itemName))
    // .toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value ??
        '';

    final int dataRowIndex = _currentBillingData.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    if (column.columnName == 'itemRate') {
      double? newVal = double.tryParse(newCellValue);
      _currentBillingData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(columnName: column.columnName, value: newVal);
      int money = _currentBillingData[dataRowIndex]
          .getCells()[rowColumnIndex.columnIndex - 1]
          .value;
      _currentBillingData[dataRowIndex].getCells()[5] = DataGridCell<double>(
          columnName: 'itemAmount', value: newVal! * money.toDouble());
      currentBillingData.items.elementAt(dataRowIndex).itemRate = newVal;
      onUpdate();
    }

    if (column.columnName == 'itemQuantity') {
      int? newVal = int.tryParse(newCellValue);
      _currentBillingData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: column.columnName, value: newVal);
      double money = _currentBillingData[dataRowIndex]
          .getCells()[rowColumnIndex.columnIndex + 1]
          .value;
      _currentBillingData[dataRowIndex].getCells()[5] = DataGridCell<double>(
          columnName: 'itemAmount', value: newVal!.toDouble() * money);
      currentBillingData.items.elementAt(dataRowIndex).itemQuantity = newVal;
      onUpdate();
    }
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    newCellValue = null;
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    return Container(
      alignment: Alignment.centerRight,
      child: TextBox(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: TextAlign.right,
        keyboardType: TextInputType.number,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            newCellValue = value;
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          submitCell();
        },
      ),
    );
  }

  void updateDataGridSource() {
    notifyListeners();
  }
}
