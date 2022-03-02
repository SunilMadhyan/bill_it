import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable(explicitToJson: true)
class Item {
  Item(this.itemId, this.itemName, this.itemQuantity, this.itemRate) {
    itemAmount = (itemQuantity * itemRate);
  }
  int itemId;

  String itemName;

  int itemQuantity;

  double itemRate;

  late double itemAmount;

  bool available = true;
  int availableQty = 99999;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);

  @override
  String toString() {
    return '$itemId - $itemName, Qty: $itemQuantity, Rate: $itemRate';
  }
}
