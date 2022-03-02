import 'dart:convert';
import 'dart:io';

import 'package:bill_it/models/item/item.dart';
import 'package:csv/csv.dart';

import '../../models/billing/billing_data.dart';
import '../../models/billing/billing_item.dart';

BillingItem item1 = BillingItem(10001, 2, 100);
BillingItem item2 = BillingItem(10002, 6, 240);
BillingItem item3 = BillingItem(10004, 2, 95);
BillingItem item4 = BillingItem(10005, 4, 40);
BillingItem item5 = BillingItem(10006, 2, 100);
BillingItem item6 = BillingItem(10007, 3, 350);
BillingItem item7 = BillingItem.withName(10001, '1 kg Nails', 2, 100);
BillingItem item8 =
    BillingItem.withName(10002, 'Asian Paint Blue 650ml', 6, 240);
BillingItem item9 = BillingItem.withName(1001, '1.5 kg Nails', 2, 100);
BillingItem item10 =
    BillingItem.withName(1002, 'Asian Paint Gold 480ml', 6, 240);

BillingData billingData = BillingData(
    001,
    DateTime.now(),
    'Sunil Madhyan',
    10,
    0,
    5000,
    4500,
    'Bill from db',
    [item1, item2, item3, item4, item5, item6, item7, item8, item9, item10]);

Item _item1 = Item(10001, '1 kg Nails', 1, 100);
Item _item2 = Item(10002, 'Asian Paint Red 500g', 1, 240);
Item _item3 = Item(10004, 'Paint Brush', 1, 95);
Item _item4 = Item(10005, '0.5kg Nails', 1, 55);
Item _item5 = Item(10006, '2kg Wire Bundle', 1, 180);
Item _item6 = Item(10007, 'Mid size door lock', 1, 120);
Map<String, Item> availableItems = {};

class AppDB {
  static BillingData getBillingData() {
    return billingData;
  }

  static Map<String, Item> getAvailableItems() {
    return availableItems;
  }

  AppDB();

  doSomeWork() async {
    List<List<dynamic>> temp = await openFile();
    temp.forEach((e) => {
          availableItems.putIfAbsent(e[0].toString(),
              () => Item(e[0], e[1], e[2], double.tryParse(e[3].toString())!))
        });
  }

  openFile() async {
    File f = File('./db.csv');
    print("CSV to List");
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    return fields;
  }
}
