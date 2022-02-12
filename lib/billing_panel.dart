// ignore_for_file: prefer_const_constructors

import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' as material;
import './shared/db/db.dart';
import 'models/billing/billing_data.dart';
import 'models/item/item.dart';

class BillingPanel extends StatefulWidget {
  const BillingPanel({Key? key}) : super(key: key);
  @override
  _BillingPanelState createState() => _BillingPanelState();
}

class _BillingPanelState extends State<BillingPanel> {
  BillingData billData = AppDB.getBillingData();
  Map<String, Item> items = AppDB.getAvailableItems();

  List<CurrentBillingData> currentBilling = <CurrentBillingData>[];
  late CurrentBillingDataSource currentBillingDataSource;
  final TextEditingController _partyName =
      TextEditingController(text: 'Sunil Maheshkumar Madhyan');
  final TextEditingController _billNo = TextEditingController(text: '143');
  final nameInputBox = TextEditingController();
  final codeInputBox = TextEditingController();
  final qtyInputBox = TextEditingController();
  final rateInputBox = TextEditingController();
  final amountInputBox = TextEditingController();

  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    qtyInputBox.text = '0.0';
    rateInputBox.text = '0.0';
    currentBilling = getCurrentBillingData();
    currentBillingDataSource =
        CurrentBillingDataSource(currentBillingData: currentBilling);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Bill Generation and Estimate Calculation',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
        // Party Name, Date and Billing No
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                width: 300,
                child: TextBox(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  placeholder: 'Enter Party Name',
                  controller: _partyName,
                  prefix: Text('Name:'),
                  prefixMode: OverlayVisibilityMode.editing,
                )),
            SizedBox(
              width: 285,
              child: DatePicker(
                selected: date,
                startYear: 2020,
                endYear: 2025,
                onChanged: (v) => setState(() => date = v),
              ),
            ),
            SizedBox(
                width: 75,
                child: TextBox(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  placeholder: 'Billing Number',
                  controller: _billNo,
                )),
          ],
        ),
        // Item details input box Item Code, Name, Qrt, Rate, Amount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                width: 75,
                child: AutoSuggestBox(
                  controller: codeInputBox,
                  items: items.keys.toList(),
                  clearButtonEnabled: false,
                  placeholder: 'Code',
                  onSelected: (text) {
                    nameInputBox.text =
                        items[text]?.toString() ?? 'Not available';
                  },
                )),
            // SizedBox(
            //     width: 300,
            //     child: TextBox(
            //       style: TextStyle(fontSize: 16, color: Colors.black),
            //       placeholder: 'Enter Item Name',
            //       prefix: Text('Item:'),
            //       prefixMode: OverlayVisibilityMode.editing,
            //     )),
            SizedBox(
                width: 300,
                child: AutoSuggestBox(
                  controller: nameInputBox,
                  items: items.values.map((e) => e.toString()).toList(),
                  clearButtonEnabled: false,
                  placeholder: 'Enter Item Name',
                  onSelected: (text) {
                    codeInputBox.text = text.split(' ')[0];
                  },
                )),
            SizedBox(
                width: 100,
                child: TextBox(
                    controller: qtyInputBox,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    placeholder: 'Quantity',
                    prefix: Text('Qty:'),
                    prefixMode: OverlayVisibilityMode.editing,
                    onChanged: (e) => {
                          amountInputBox.text =
                              '${((double.tryParse(qtyInputBox.text) ?? 0) * (double.tryParse(rateInputBox.text) ?? 0))}'
                        })),
            SizedBox(
                width: 100,
                child: TextBox(
                    controller: rateInputBox,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    placeholder: 'Rate',
                    prefix: Text('Rs.'),
                    prefixMode: OverlayVisibilityMode.editing,
                    onChanged: (e) => {
                          amountInputBox.text =
                              '${((double.tryParse(qtyInputBox.text) ?? 0) * (double.tryParse(rateInputBox.text) ?? 0))}'
                        })),
            SizedBox(
                width: 100,
                child: TextBox(
                  controller: amountInputBox,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  placeholder:
                      '${((double.tryParse(qtyInputBox.text) ?? 0) * (double.tryParse(rateInputBox.text) ?? 0))}',
                  readOnly: true,
                  prefix: Text('Rs.'),
                )),
            SizedBox(
              width: 35,
              child: IconButton(
                icon: Icon(FluentIcons.add),
                onPressed: () {
                  print('pressed icon button');
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .40,
              width: MediaQuery.of(context).size.width * .65,
              padding: EdgeInsets.only(left: 20.0),
              child: SfDataGrid(
                rowHeight: 35,
                allowSwiping: true,
                isScrollbarAlwaysShown: true,
                source: currentBillingDataSource,
                columnWidthMode: ColumnWidthMode.fill,
                allowEditing: true,
                selectionMode: SelectionMode.single,
                navigationMode: GridNavigationMode.cell,
                editingGestureType: EditingGestureType.tap,
                columns: <GridColumn>[
                  GridColumn(
                      allowEditing: false,
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                      columnName: 'srNo',
                      minimumWidth: 75.0,
                      label: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Sr. No',
                          ))),
                  GridColumn(
                      columnName: 'itemCode',
                      allowEditing: false,
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                      label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('Item Code'))),
                  GridColumn(
                      columnName: 'itemName',
                      allowEditing: false,
                      maximumWidth: 600.0,
                      label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text(
                            'Item Name',
                            overflow: TextOverflow.ellipsis,
                          ))),
                  GridColumn(
                      columnName: 'itemQuantity',
                      allowEditing: true,
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                      label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('Quantity'))),
                  GridColumn(
                      columnName: 'itemRate',
                      allowEditing: true,
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                      label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('Rate'))),
                  GridColumn(
                      columnName: 'itemAmount',
                      columnWidthMode: ColumnWidthMode.fitByColumnName,
                      allowEditing: false,
                      label: Container(
                          padding: EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: Text('Amount'))),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            SizedBox(
                width: 200,
                child: TextBox(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  placeholder: 'Discount',
                  header: 'Discount',
                )),
            SizedBox(
                width: 200,
                child: TextBox(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    header: "Total Amount",
                    placeholder: 'Auto Calculated',
                    readOnly: true)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            SizedBox(
                width: 200,
                child: TextBox(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  header: 'Packing Charges',
                  placeholder: 'Packing Charges',
                )),
            SizedBox(
                width: 200,
                child: TextBox(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    header: "After Discount",
                    placeholder: 'Auto Calculated',
                    readOnly: true)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            SizedBox(
                width: 500,
                child: TextBox(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  header: 'Notes',
                  placeholder: 'Enter billing notes here...',
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              material.ElevatedButton(
                child: Text(
                  'New',
                ),
                style: material.ButtonStyle(
                  elevation: material.MaterialStateProperty.all(10),
                  foregroundColor:
                      material.MaterialStateProperty.all(Colors.black),
                  backgroundColor: material.MaterialStateProperty.all(
                      Color.fromARGB(255, 202, 240, 193)),
                  textStyle: material.MaterialStateProperty.all(
                      TextStyle(fontSize: 18)),
                  minimumSize:
                      material.MaterialStateProperty.all(Size(100, 40)),
                ),
                onPressed: () {},
              ),
              material.ElevatedButton(
                child: Text(
                  'Clear',
                ),
                style: material.ButtonStyle(
                  elevation: material.MaterialStateProperty.all(10),
                  foregroundColor:
                      material.MaterialStateProperty.all(Colors.black),
                  backgroundColor: material.MaterialStateProperty.all(
                      Color.fromARGB(255, 177, 202, 204)),
                  textStyle: material.MaterialStateProperty.all(
                      TextStyle(fontSize: 18)),
                  minimumSize:
                      material.MaterialStateProperty.all(Size(100, 40)),
                ),
                onPressed: () {},
              ),
              material.ElevatedButton(
                child: Text(
                  'Save',
                ),
                style: material.ButtonStyle(
                  elevation: material.MaterialStateProperty.all(10),
                  foregroundColor:
                      material.MaterialStateProperty.all(Colors.white),
                  backgroundColor: material.MaterialStateProperty.all(
                      Color.fromARGB(255, 48, 168, 177)),
                  textStyle: material.MaterialStateProperty.all(
                      TextStyle(fontSize: 18)),
                  minimumSize:
                      material.MaterialStateProperty.all(Size(100, 40)),
                ),
                onPressed: () {},
              ),
              material.ElevatedButton(
                child: Text(
                  'Print',
                ),
                style: material.ButtonStyle(
                  elevation: material.MaterialStateProperty.all(10),
                  textStyle: material.MaterialStateProperty.all(
                      TextStyle(fontSize: 18)),
                  minimumSize:
                      material.MaterialStateProperty.all(Size(100, 40)),
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      ],
    );
  }

  List<CurrentBillingData> getCurrentBillingData() {
    return [
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
      CurrentBillingData(10001, 'James', 20, 75),
    ];
  }
}

class CurrentBillingData {
  /// Creates the employee class with required details.
  CurrentBillingData(
      this.itemId, this.itemName, this.itemQuantity, this.itemRate) {
    itemAmount = (itemQuantity * itemRate);
    srNo = ++length;
  }

  static int length = 0;

  late int srNo;

  late double itemAmount;

  ///
  int itemId;

  ///
  String itemName;

  ///
  int itemQuantity;

  ///
  double itemRate;

  DataGridRow getDataGridRow() {
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

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class CurrentBillingDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  CurrentBillingDataSource(
      {required List<CurrentBillingData> currentBillingData}) {
    _currentBillingData =
        currentBillingData.map<DataGridRow>((e) => e.getDataGridRow()).toList();
  }

  List<DataGridRow> _currentBillingData = [];

  @override
  List<DataGridRow> get rows => _currentBillingData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

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

    if (column.columnName == 'itemRate' ||
        column.columnName == 'itemQuantity') {
      _currentBillingData[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(
              columnName: column.columnName,
              value: double.tryParse(newCellValue));

      double money = _currentBillingData[dataRowIndex]
          .getCells()[column.columnName == 'itemRate'
              ? rowColumnIndex.columnIndex - 1
              : rowColumnIndex.columnIndex + 1]
          .value;

      _currentBillingData[dataRowIndex].getCells()[5] = DataGridCell<double>(
          columnName: 'itemAmount', value: double.parse(newCellValue) * money);
    }
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhereOrNull((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            ?.value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType =
        column.columnName == 'id' || column.columnName == 'salary';

    return Container(
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextBox(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          // In Mobile Platform.
          // Call [CellSubmit] callback to fire the canSubmitCell and
          // onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }
}
