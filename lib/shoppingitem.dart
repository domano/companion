import 'package:hive/hive.dart';

part 'shoppingitem.g.dart';

@HiveType()
class ShoppingItem extends HiveObject{
  @HiveField(0)
  String text;

  @HiveField(1)
  bool checked;

  ShoppingItem(this.text, this.checked);
}