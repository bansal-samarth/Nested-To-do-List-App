import 'package:uuid/uuid.dart';

class TodoItem {
  String id;
  String title;
  bool isDone;
  List<TodoItem> children;

  TodoItem({
    required this.title,
    this.isDone = false,
    List<TodoItem>? children,
    String? id,
  })  : this.children = children ?? [],
        this.id = id ?? Uuid().v4();

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    var childrenFromJson = json['children'] as List<dynamic>?;
    List<TodoItem> childrenList = childrenFromJson != null
        ? childrenFromJson.map((child) => TodoItem.fromJson(child)).toList()
        : [];

    return TodoItem(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'],
      children: childrenList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }
}