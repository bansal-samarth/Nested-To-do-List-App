import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../services/local_storage_service.dart';

class TodoProvider with ChangeNotifier {
  final LocalStorageService _localStorageService = LocalStorageService();
  List<TodoItem> _topics = [];

  List<TodoItem> get topics => _topics;

  TodoProvider() {
    loadTopics();
  }

  Future<void> loadTopics() async {
    _topics = await _localStorageService.loadTopics();
    notifyListeners();
  }

  void addTopic(String title) {
    _topics.add(TodoItem(title: title));
    _saveAndNotify();
  }

  void addTodoItem(TodoItem parent, String title) {
    parent.children.add(TodoItem(title: title));
    // When adding a new item, the parent must be marked as incomplete.
    if (parent.isDone) {
      parent.isDone = false;
      // Cascade the 'incomplete' status upwards.
      _updateParentStatus(_topics, parent);
    }
    _saveAndNotify();
  }

  // This method is now simpler and only used for direct toggles if needed.
  void toggleTodoItem(TodoItem item) {
    item.isDone = !item.isDone;
    _updateParentStatus(_topics, item);
    _saveAndNotify();
  }

  // The main method for user interaction. It handles child and parent updates.
  void toggleItemAndChildren(TodoItem item) {
    item.isDone = !item.isDone;

    if (item.children.isNotEmpty) {
      _toggleAllChildren(item, item.isDone);
    }
    
    // After any toggle, check and update the parent's status.
    _updateParentStatus(_topics, item);
    
    _saveAndNotify();
  }

  void _toggleAllChildren(TodoItem parent, bool isDone) {
    for (var child in parent.children) {
      if (child.isDone != isDone) {
        child.isDone = isDone;
      }
      if (child.children.isNotEmpty) {
        _toggleAllChildren(child, isDone);
      }
    }
  }

  // --- NEW: LOGIC TO UPDATE PARENT COMPLETION STATUS ---
  void _updateParentStatus(List<TodoItem> list, TodoItem childItem) {
    final parent = _findParent(list, childItem);
    if (parent == null) return; // No parent found, stop recursion.

    // Check if all children of the parent are now done.
    final allChildrenDone = parent.children.every((child) => child.isDone);

    // Update the parent's status only if it has changed.
    if (parent.isDone != allChildrenDone) {
      parent.isDone = allChildrenDone;
      // Recursively call to update the grandparent.
      _updateParentStatus(_topics, parent);
    }
  }
  
  // Helper to find the parent of a given item in the tree.
  TodoItem? _findParent(List<TodoItem> list, TodoItem target) {
    for (var item in list) {
      if (item.children.any((child) => child.id == target.id)) {
        return item;
      }
      final parent = _findParent(item.children, target);
      if (parent != null) {
        return parent;
      }
    }
    return null;
  }
  // --- END OF NEW LOGIC ---

  void removeTodoItem(TodoItem parent, TodoItem itemToRemove) {
    parent.children.removeWhere((item) => item.id == itemToRemove.id);
    // After removing an item, the parent's status might change.
    _updateParentStatus(_topics, parent); 
    _saveAndNotify();
  }

  void removeTopic(TodoItem topicToRemove) {
    _topics.removeWhere((topic) => topic.id == topicToRemove.id);
    _saveAndNotify();
  }

  void _saveAndNotify() {
    _localStorageService.saveTopics(_topics);
    notifyListeners();
  }
}