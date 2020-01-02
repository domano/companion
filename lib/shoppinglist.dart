import 'package:companion/shoppingitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';

class ShoppingList extends StatefulWidget {
  @override
  createState() => new ShoppingListState();
}

class ShoppingListState extends State<ShoppingList> {
  Box box;
  final TextEditingController _controller = new TextEditingController();

  void _addShoppingItem(dynamic task) {
    // Only add the task if the user actually entered something
    if (task.length > 0) {
      if (box.values.any((e) => e.text == task)) {
        var item = box.get(task) as ShoppingItem;
        item.checked = false;
        item.save();
        setState(() {});
      } else {
        var item = new ShoppingItem(task, false);
        box.put(item.text, item);
        setState(() {});
      }
    }
    _controller.clear();
  }


  Widget _buildShoppingList() {
    var list = box.values.toList();
    list.sort(_compareItems);
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < list.length) {
          return _buildShoppingItem(list[index], index);
        }
      },
    );
  }

  Widget _buildShoppingItem(ShoppingItem item, int index) {
    return new CheckboxListTile(
      title: _buildShoppingText(item),
      value: item.checked,
      onChanged: (b) => _checkShoppingItem(item),
    );
  }

  Widget _buildShoppingText(ShoppingItem ShoppingItem) {
    if (ShoppingItem.checked) {
      return new Text(ShoppingItem.text,
          style: new TextStyle(
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ));
    }
    return new Text(ShoppingItem.text);
  }

  void _checkShoppingItem(ShoppingItem item) {
    setState(() {
      item.checked = !item.checked;
      item.save();
    });
  }

  int _compareItems(a, b) {
    if (a.checked == false && b.checked == true) {
      return -1;
    }
    if (a.checked == true && b.checked == false) {
      return 1;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    box = Hive.box("shoppingList");
    return new Scaffold(
      appBar: new AppBar(title: new Text('Shopping List')),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            buildTextField(),
            new Expanded(child: _buildShoppingList())
          ]),
    );
  }

  Widget buildTextField() =>
      new TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            controller: _controller,
            onSubmitted: _addShoppingItem,
            autofocus: false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16.0),
              hintText: "Neuen Eintrag hinzufügen",
            )),
        suggestionsCallback: (pattern) =>
            box.values.where((e) => e.text.contains(pattern)).toList(),
        itemBuilder: (context, item) =>
        new ListTile(title: new Text(item.text)),
        hideOnEmpty: true,
        hideOnLoading: true,
        hideSuggestionsOnKeyboardHide: true,
        onSuggestionSelected: (e) => _addShoppingItem(e.text),);
}