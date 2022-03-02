// ignore_for_file: prefer_const_constructors

import 'package:bill_it/models/billing/billing_item.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter/material.dart' as material;
import './shared/db/db.dart';
import 'models/billing/billing_data.dart';
import 'models/billing_data_source.dart';
import 'models/item/item.dart';

class BillingPanel extends StatefulWidget {
  const BillingPanel({Key? key}) : super(key: key);
  @override
  _BillingPanelState createState() => _BillingPanelState();
}

class _BillingPanelState extends State<BillingPanel> {
  BillingData billData = AppDB.getBillingData();
  Map<String, Item> items = AppDB.getAvailableItems();
  late BillingDataSource billingDataSource =
      BillingDataSource(billData.items, items, performCalculation);

  final partyNameInputBox = TextEditingController();
  final billNoInputBox = TextEditingController();
  final nameInputBox = TextEditingController();
  final codeInputBox = TextEditingController();
  final qtyInputBox = TextEditingController();
  final rateInputBox = TextEditingController();
  final discountInputBox = TextEditingController(text: '0');
  final packageChargeInputBox = TextEditingController(text: '0');
  final amountInputBox = TextEditingController();
  final totalAmountInputBox = TextEditingController();
  final totalNetAmountInputBox = TextEditingController();

  DateTime date = DateTime.now();

  void calculateTotalNetAmount([String val = '']) {
    billData.totalNetAmount = (billData.totalAmount) -
        ((billData.totalAmount) *
            double.tryParse(discountInputBox.text)! /
            100) +
        double.tryParse(packageChargeInputBox.text)!;
    totalNetAmountInputBox.text = billData.totalNetAmount.toString();
  }

  void calculateTotalAmount() {
    billData.totalAmount = billData.items.fold<double>(
        0,
        (previousValue, item) =>
            item.itemRate * item.itemQuantity + previousValue);
    totalAmountInputBox.text = billData.totalAmount.toString();
  }

  void performCalculation() {
    calculateTotalAmount();
    calculateTotalNetAmount();
  }

  void addItemToBill() {
    if (codeInputBox.text.isEmpty) return;
    if (qtyInputBox.text.isEmpty) return;
    if (rateInputBox.text.isEmpty) return;
    BillingItem newItem = BillingItem(int.parse(codeInputBox.text),
        int.parse(qtyInputBox.text), double.parse(rateInputBox.text));
    billData.items.insert(billData.items.length, newItem);

    billingDataSource.buildDataGridRows();
    billingDataSource.updateDataGridSource();

    performCalculation();
    clearInputBoxes();
  }

  clearInputBoxes() {
    codeInputBox.text = '';
    qtyInputBox.text = '';
    rateInputBox.text = '';
    nameInputBox.text = '';
    amountInputBox.text = '';
  }

  @override
  void initState() {
    super.initState();
    performCalculation();
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
                  controller: partyNameInputBox,
                  prefix: Text('Name:'),
                  prefixMode: OverlayVisibilityMode.editing,
                )),
            SizedBox(
              width: 285,
              child: DatePicker(
                selected: date,
                startYear: date.year - 2,
                endYear: date.year + 2,
                onChanged: (v) => setState(() => date = v),
              ),
            ),
            SizedBox(
                width: 75,
                child: TextBox(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  placeholder: 'Billing Number',
                  controller: billNoInputBox,
                )),
          ],
        ),

        // Item details input box Item Code, Name, Qty, Rate, Amount
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
                onPressed: addItemToBill,
              ),
            ),
          ],
        ),

        // Billing Items Grid
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
                source: billingDataSource,
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
          children: [
            SizedBox(
                width: 200,
                child: TextBox(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  placeholder: 'Discount',
                  header: 'Discount',
                  outsidePrefix: Text(' % '),
                  onChanged: calculateTotalNetAmount,
                  controller: discountInputBox,
                )),
            SizedBox(
                width: 200,
                child: TextBox(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    header: "Total Amount",
                    placeholder: 'Auto Calculated',
                    outsidePrefix: Text('Rs. '),
                    controller: totalAmountInputBox,
                    readOnly: true)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                width: 200,
                child: TextBox(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  header: 'Packing Charges',
                  placeholder: 'Packing Charges',
                  outsidePrefix: Text('Rs. '),
                  controller: packageChargeInputBox,
                  onChanged: calculateTotalNetAmount,
                )),
            SizedBox(
                width: 200,
                child: TextBox(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    header: "After Discount + Packaging Charge",
                    placeholder: 'Auto Calculated',
                    outsidePrefix: Text('Rs. '),
                    controller: totalNetAmountInputBox,
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

        // Elevaded Buttons -  New, Clear, Save, Print
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
}
