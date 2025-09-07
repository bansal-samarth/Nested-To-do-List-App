import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_item.dart';

class LocalStorageService {
  static const String _topicsKey = 'topics';

  Future<void> saveTopics(List<TodoItem> topics) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> topicsJson =
        topics.map((topic) => jsonEncode(topic.toJson())).toList();
    await prefs.setStringList(_topicsKey, topicsJson);
  }

  Future<List<TodoItem>> loadTopics() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? topicsJson = prefs.getStringList(_topicsKey);
    if (topicsJson == null) {
      return [];
    }
    return topicsJson
        .map((topicJson) => TodoItem.fromJson(jsonDecode(topicJson)))
        .toList();
  }
}