import 'package:flutter/material.dart';
import 'package:tarea_flutter/hero_dialog_route.dart';
import 'package:tarea_flutter/app_todo_Popup_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: '// TODO:'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class ToDoItem {
  String text;
  int order;
  bool checked;

  ToDoItem(this.text, {required this.order, this.checked: false});
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDoItem> items = [
    ToDoItem('A', order: 0),
    ToDoItem('B', order: 1),
    ToDoItem('C', order: 2),
  ];

  updateList() {
    setState(() {
      List<ToDoItem> checkeds =
          this.items.where((element) => element.checked).toList();
      checkeds.sort((a, b) => a.order - b.order);

      List<ToDoItem> uncheckeds =
          this.items.where((element) => !element.checked).toList();
      uncheckeds.sort((a, b) => a.order - b.order);

      this.items.clear();
      this.items.addAll([...uncheckeds, ...checkeds]);
    });
  }

  final textCtrl = TextEditingController();

  openPopupCard(void Function(String) onSave) {
    Navigator.of(context).push(HeroDialogRoute(
      builder: (context) {
        return AddTodoPopupCard(
          textCtrl: textCtrl,
          onSave: (text) {
            onSave(text);
            updateList();
            textCtrl.text = '';
            Navigator.of(context).pop();
          },
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        toolbarHeight: 180,
      ),
      body: ListView(
        children: [
          ...this.items.map((e) => ListTile(
              leading: Checkbox(
                checkColor: Colors.transparent,
                activeColor: Colors.grey.shade400,
                onChanged: (e) {},
                value: e.checked,
              ),
              title: Opacity(
                opacity: e.checked ? 0.5 : 1,
                child: Text(
                  e.text,
                  style: TextStyle(
                    color: e.checked ? Colors.grey.shade500 : Colors.black,
                    decoration: e.checked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (t) {
                  switch (t) {
                    case 'editar':
                      this.textCtrl.text = e.text;
                      openPopupCard((text) {
                        this
                            .items
                            .firstWhere((element) => element.order == e.order)
                            .text = text;
                      });
                      break;
                    case 'borrar':
                      this
                          .items
                          .removeWhere((element) => element.order == e.order);
                      updateList();
                      break;
                  }
                },
                icon: Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(color: Color(0x99FFFFFF), width: 2),
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'editar',
                      height: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.edit, color: Colors.white),
                          Text(
                            'Editar',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuDivider(
                      height: 8,
                    ),
                    PopupMenuItem<String>(
                      value: 'borrar',
                      height: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          Text(
                            'Borrar',
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                  ];
                },
                color: Colors.grey.shade700,
              ),
              onTap: () {
                e.checked = !e.checked;
                updateList();
              })),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 14.0),
        child: GestureDetector(
          onTap: () => openPopupCard((text) => items.add(ToDoItem(text,
              order: items
                      .reduce((value, element) =>
                          element.order > value.order ? element : value)
                      .order +
                  1))),
          child: Hero(
            tag: 'add-todo-hero',
            child: Material(
              color: Colors.grey.shade800,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: const BorderSide(
                    width: 3,
                    color: Color(0x99FFFFFF),
                  )),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
