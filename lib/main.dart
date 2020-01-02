// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:companion/shoppingitem.dart';
import 'package:companion/shoppinglist.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(ShoppingItemAdapter(), 0);
  runApp(new CompanionApp());
}

class CompanionApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CompanionAppState();
  }
}
class CompanionAppState extends State<CompanionApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Shopping List', home:
    FutureBuilder(
      future: Hive.openBox("shoppingList"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError)
            return Text(snapshot.error.toString());
          else
            return ShoppingList();
        }
        // Although opening a Box takes a very short time,
        // we still need to return something before the Future completes.
        else
          return Scaffold();      },
    ));
  }

}

