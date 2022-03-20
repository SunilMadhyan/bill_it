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
      BillingDataSource(billData, items, performCalculation);

  final partyNameInputBox = TextEditingController();
  final gstNoInputBox = TextEditingController();
  final nameInputBox = TextEditingController();
  final codeInputBox = TextEditingController();
  final qtyInputBox = TextEditingController();
  final rateInputBox = TextEditingController();
  final discountInputBox = TextEditingController(text: '0');
  final discountRsInputBox = TextEditingController(text: '0');
  final packageChargeInputBox = TextEditingController(text: '0');
  final amountInputBox = TextEditingController();
  final totalAmountInputBox = TextEditingController();
  final totalNetAmountInputBox = TextEditingController();
  final billingNotesInputBox = TextEditingController();
  final autoSuggestBox = TextEditingController();

  bool isReachedCenter = false;
  DateTime date = DateTime.now();

  void calculateTotalNetAmount([String val = '']) {
    if (val.isEmpty ||
        double.tryParse(val) == null ||
        double.tryParse(val)! < 0) {
      val = '0';
    }
    discountRsInputBox.text =
        ((billData.totalAmount) * double.tryParse(val)! / 100).toString();
    billData.totalNetAmount =
        (billData.totalAmount) - (double.tryParse(discountRsInputBox.text)!);
    addPackingCharge();
  }

  void calculateTotalNetAmountWhenRsDiscount([String val = '']) {
    if (val.isEmpty ||
        double.tryParse(val) == null ||
        double.tryParse(val)! < 0) {
      val = '0';
    }
    discountInputBox.text =
        (double.tryParse(val)! * 100 / billData.totalAmount).toString();
    billData.totalNetAmount = (billData.totalAmount) - double.tryParse(val)!;
    addPackingCharge();
  }

  void addPackingCharge([String val = '']) {
    if (val.isEmpty ||
        double.tryParse(val) == null ||
        double.tryParse(val)! < 0) {
      val = '0';
    }
    totalNetAmountInputBox.text =
        (billData.totalNetAmount + double.parse(val)).toString();
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
    if (billData.items.isEmpty) billData.items = <BillingItem>[];
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

  clearPartyDetails() {
    partyNameInputBox.text = '';
    gstNoInputBox.text = '';
  }

  clearDiscountDetails() {
    discountInputBox.text = '0';
    packageChargeInputBox.text = '0';
    billingNotesInputBox.text = '';
  }

  clearBillingPanel() {
    clearInputBoxes();
    billingDataSource.currentBillingData.items = [];
    billingDataSource.buildDataGridRows();
    billingDataSource.updateDataGridSource();
    performCalculation();
    clearPartyDetails();
    clearDiscountDetails();
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Bill Generation and Estimate Calculation',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              width: 60,
              child: Text(
                "Invoice# 4965846516",
                softWrap: true,
                maxLines: 2,
                //overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        // Party Name, Date and Billing No
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(100, 10, 10, 10),
                width: 300,
                child: TextBox(
                  placeholder: 'Party Name',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  placeholderStyle:
                      const TextStyle(fontSize: 16, color: Colors.black),
                  controller: partyNameInputBox,
                  prefix: Text('Name:'),
                  prefixMode: OverlayVisibilityMode.editing,
                )),
            SizedBox(
              width: 150,
              child: DatePicker(
                selected: date,
                startYear: date.year - 2,
                endYear: date.year + 2,
                onChanged: (v) => setState(() => date = v),
                contentPadding: EdgeInsets.all(0),
                showYear: false,
              ),
            ),
            SizedBox(
                width: 200,
                child: TextBox(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  placeholderStyle:
                      const TextStyle(fontSize: 16, color: Colors.black),
                  placeholder: 'GST Number',
                  prefix: Text('GST: '),
                  prefixMode: OverlayVisibilityMode.editing,
                  controller: gstNoInputBox,
                )),
          ],
        ),

        // Item details input box Item Code, Name, Qty, Rate, Amount
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: 175,
                padding: const EdgeInsets.fromLTRB(100, 10, 10, 10),
                child: AutoSuggestBox(
                  controller: codeInputBox,
                  items: items.keys.toList(),
                  clearButtonEnabled: false,
                  placeholderStyle:
                      const TextStyle(fontSize: 16, color: Colors.black),
                  placeholder: 'Code',
                  onSelected: (text) {
                    nameInputBox.text =
                        items[text]?.toString() ?? 'Not available';
                  },
                )),
            Container(
                width: 300,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: AutoSuggestBox(
                  controller: nameInputBox,
                  items: items.values.map((e) => e.toString()).toList(),
                  clearButtonEnabled: false,
                  placeholder: 'Enter Item Name',
                  placeholderStyle:
                      const TextStyle(fontSize: 16, color: Colors.black),
                  onChanged: (text, reason) {
                    codeInputBox.text = text.split(' ')[0];
                  },
                  onSelected: (text) {
                    codeInputBox.text = text.split(' ')[0];
                  },
                )),
            Container(
                width: 100,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextBox(
                    controller: qtyInputBox,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    placeholderStyle:
                        const TextStyle(fontSize: 16, color: Colors.black),
                    placeholder: 'Quantity',
                    prefix: Text('Qty:'),
                    prefixMode: OverlayVisibilityMode.editing,
                    onChanged: (e) => {
                          amountInputBox.text =
                              '${((double.tryParse(qtyInputBox.text) ?? 0) * (double.tryParse(rateInputBox.text) ?? 0))}'
                        })),
            Container(
                width: 100,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextBox(
                    controller: rateInputBox,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    placeholderStyle:
                        const TextStyle(fontSize: 16, color: Colors.black),
                    placeholder: 'Rate',
                    prefix: Text('Rs.'),
                    prefixMode: OverlayVisibilityMode.editing,
                    onChanged: (e) => {
                          amountInputBox.text =
                              '${((double.tryParse(qtyInputBox.text) ?? 0) * (double.tryParse(rateInputBox.text) ?? 0))}'
                        })),
            Container(
                width: 120,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextBox(
                  controller: amountInputBox,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  placeholderStyle:
                      const TextStyle(fontSize: 16, color: Colors.black),
                  placeholder:
                      '${((double.tryParse(qtyInputBox.text) ?? 0) * (double.tryParse(rateInputBox.text) ?? 0))}',
                  readOnly: true,
                  prefix: Text('Rs.'),
                )),
            Container(
              width: 55,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              // /color: Colors.successPrimaryColor,
              child: IconButton(
                  icon: Icon(FluentIcons.add_to,
                      size: 24, color: Colors.white, semanticLabel: 'Add'),
                  onPressed: addItemToBill,
                  style: ButtonStyle(
                    backgroundColor: ButtonState.all(Colors.green),
                  )),
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
                swipeMaxOffset: 300,
                isScrollbarAlwaysShown: true,
                source: billingDataSource,
                columnWidthMode: ColumnWidthMode.fill,
                allowEditing: true,
                selectionMode: SelectionMode.single,
                navigationMode: GridNavigationMode.cell,
                editingGestureType: EditingGestureType.tap,
                startSwipeActionsBuilder:
                    (BuildContext context, DataGridRow row, int rowIndex) {
                  return GestureDetector(
                      onTap: () {
                        billingDataSource.currentBillingData.items
                            .removeAt(rowIndex);
                        billingDataSource.buildDataGridRows();
                        billingDataSource.updateDataGridSource();
                        performCalculation();
                      },
                      child: Container(
                          color: Colors.red,
                          padding: EdgeInsets.only(left: 30.0),
                          alignment: Alignment.centerLeft,
                          child: Text('Delete',
                              style: TextStyle(color: Colors.white))));
                },
                // onSwipeUpdate: (details) {
                //   isReachedCenter =
                //       (details.swipeOffset >= 300 / 1.5) ? true : false;
                //   return true;
                // },
                // onSwipeEnd: (details) async {
                //   if (isReachedCenter &&
                //       billingDataSource.currentBillingData.items.isNotEmpty) {
                //     billingDataSource.currentBillingData.items
                //         .removeAt(details.rowIndex);
                //     billingDataSource.buildDataGridRows();
                //     billingDataSource.updateDataGridSource();
                //     isReachedCenter = false;
                //   }
                // },
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
        // Discount Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 200,
                        child: TextBox(
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          header: 'Discount',
                          placeholder: 'Discount Percentage',
                          outsidePrefix: Text(' % '),
                          onChanged: calculateTotalNetAmount,
                          controller: discountInputBox,
                        )),
                    SizedBox(
                        width: 200,
                        child: TextBox(
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          header: '',
                          placeholder: 'Discount Amount',
                          outsidePrefix: Text(' Rs. '),
                          onChanged: calculateTotalNetAmountWhenRsDiscount,
                          controller: discountRsInputBox,
                        )),
                  ],
                )
              ],
            ),
            Column(
              children: [
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
          ],
        ),
        // Packing Charge Row
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
                  onChanged: addPackingCharge,
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
        // Billing Notes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
                width: 500,
                child: TextBox(
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  header: 'Notes',
                  placeholder: 'Enter billing notes here...',
                  controller: billingNotesInputBox,
                ))
          ],
        ),
        // Elevaded Buttons -  New, Clear, Save, Print
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // material.ElevatedButton(
              //   child: Text(
              //     'New',
              //   ),
              //   style: material.ButtonStyle(
              //     elevation: material.MaterialStateProperty.all(10),
              //     foregroundColor:
              //         material.MaterialStateProperty.all(Colors.black),
              //     backgroundColor: material.MaterialStateProperty.all(
              //         Color.fromARGB(255, 202, 240, 193)),
              //     textStyle: material.MaterialStateProperty.all(
              //         TextStyle(fontSize: 18)),
              //     minimumSize:
              //         material.MaterialStateProperty.all(Size(100, 40)),
              //   ),
              //   onPressed: () {},
              // ),
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
                onPressed: clearBillingPanel,
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
              ),
              material.ElevatedButton(
                child: Text(
                  'Bill It',
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
