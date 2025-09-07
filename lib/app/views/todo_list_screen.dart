import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_item.dart';
import '../providers/todo_provider.dart';
import '../../utils/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TodoListScreen extends StatefulWidget {
  final TodoItem topic;

  TodoListScreen({required this.topic});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final Set<String> _expandedItems = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildTodoList(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildAppBar() {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        final totalLeafNodes = _countLeafNodes(widget.topic);
        final completedLeafNodes = _countCompletedLeafNodes(widget.topic);
        final progress =
            totalLeafNodes > 0 ? completedLeafNodes / totalLeafNodes : 0.0;

        return SliverAppBar(
          expandedHeight: 220,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.surface,
          elevation: 2,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back, color: AppColors.textOnPrimary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          flexibleSpace: Hero(
            tag: 'topic_card_${widget.topic.id}',
            child: FlexibleSpaceBar(
              title: null,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: progress >= 1.0
                        ? AppColors.accentGradient
                        : AppColors.primaryGradient,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  progress >= 1.0
                                      ? Icons.check_circle
                                      : Icons.folder_outlined,
                                  color: AppColors.textOnPrimary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.topic.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                            color: AppColors.textOnPrimary,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                          ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      progress >= 1.0
                                          ? 'All tasks completed! 🎉'
                                          : 'Keep going!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.textOnPrimary
                                                .withOpacity(0.8),
                                            fontSize: 16,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (totalLeafNodes > 0) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.task_alt,
                                    color: AppColors.textOnPrimary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  AnimatedSwitcher(
                                    duration: 300.ms,
                                    transitionBuilder: (child, animation) =>
                                        FadeTransition(
                                            opacity: animation, child: child),
                                    child: Text(
                                      '$completedLeafNodes of $totalLeafNodes completed',
                                      key: ValueKey<String>(
                                          '$completedLeafNodes/$totalLeafNodes'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.textOnPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  const Spacer(),
                                  AnimatedSwitcher(
                                    duration: 300.ms,
                                    transitionBuilder: (child, animation) =>
                                        FadeTransition(
                                            opacity: animation, child: child),
                                    child: Text(
                                      '${(progress * 100).round()}%',
                                      key: ValueKey<int>(
                                          (progress * 100).round()),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppColors.textOnPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: progress, end: progress),
                              duration: 400.ms,
                              builder: (context, value, child) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: value,
                                    minHeight: 8,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            AppColors.textOnPrimary),
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodoList() {
    return Consumer<TodoProvider>(
      builder: (context, todoProvider, child) {
        if (widget.topic.children.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyState(),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
          sliver: SliverList.builder(
            itemCount: widget.topic.children.length,
            itemBuilder: (context, index) {
              final item = widget.topic.children[index];
              return _buildTodoItems(context, todoProvider, widget.topic, item, 0)
                  .animate()
                  .fadeIn(delay: (100 * index).ms, duration: 400.ms)
                  .slideY(begin: 0.2, curve: Curves.easeOutCubic);
            },
          ),
        );
      },
    );
  }

  Widget _buildTodoItems(BuildContext context, TodoProvider provider,
      TodoItem parentItem, TodoItem item, int depth) {
    final isExpanded = _expandedItems.contains(item.id);
    final hasChildren = item.children.isNotEmpty;

    return Column(
      key: ValueKey(item.id),
      children: [
        _buildTodoItem(context, provider, parentItem, item, depth, isExpanded),
        AnimatedSwitcher(
          duration: 300.ms,
          transitionBuilder: (child, animation) {
            return SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1.0,
              child: child,
            );
          },
          child: (isExpanded && hasChildren)
              ? Column(
                  children: [
                    ...item.children.map(
                      (child) => _buildTodoItems(
                          context, provider, item, child, depth + 1),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildTodoItem(BuildContext context, TodoProvider provider,
      TodoItem parent, TodoItem item, int depth, bool isExpanded) {
    final hasChildren = item.children.isNotEmpty;
    final completedLeafNodes = _countCompletedLeafNodes(item);
    final totalLeafNodes = _countLeafNodes(item);
    final childProgress =
        totalLeafNodes > 0 ? completedLeafNodes / totalLeafNodes : 0.0;

    return Container(
      margin: EdgeInsets.only(left: depth * 20.0, bottom: 12),
      decoration: BoxDecoration(
        color:
            item.isDone ? AppColors.success.withOpacity(0.08) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: item.isDone
                ? AppColors.success.withOpacity(0.3)
                : depth > 0
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: item.isDone
                ? AppColors.success.withOpacity(0.05)
                : AppColors.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: hasChildren ? () => _toggleExpanded(item.id) : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  provider.toggleItemAndChildren(item);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                        color: item.isDone
                            ? AppColors.success
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: item.isDone
                                ? AppColors.success
                                : AppColors.textTertiary,
                            width: 2)),
                    child: item.isDone
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                            .animate()
                            .shake(duration: 200.ms, hz: 4)
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          decoration:
                              item.isDone ? TextDecoration.lineThrough : null,
                          color: item.isDone
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                          decorationColor: AppColors.textTertiary,
                          fontWeight: FontWeight.w600),
                    ),
                    if (hasChildren) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (hasChildren)
                            AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(Icons.expand_more,
                                    size: 16, color: AppColors.primary)),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                                '$completedLeafNodes/$totalLeafNodes subtasks',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          if (totalLeafNodes > 0) ...[
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                    value: childProgress,
                                    backgroundColor: AppColors.cardBorder,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            AppColors.primary)),
                              ),
                            )
                          ]
                        ],
                      )
                    ]
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: const Icon(Icons.add_task_outlined,
                          color: AppColors.primary),
                      onPressed: () =>
                          _showAddItemDialog(context, provider, item),
                      tooltip: 'Add Subtask'),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert,
                        color: AppColors.textTertiary),
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteItemDialog(context, provider, parent, item);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            Icon(Icons.delete_outline, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('Delete',
                                style: TextStyle(color: AppColors.error))
                          ]))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _toggleExpanded(String itemId) {
    setState(() {
      if (_expandedItems.contains(itemId)) {
        _expandedItems.remove(itemId);
      } else {
        _expandedItems.add(itemId);
      }
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.checklist_rtl,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ready to be productive? Add your first task and start conquering your goals!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textTertiary,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () =>
          _showAddItemDialog(context, context.read<TodoProvider>(), widget.topic),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      icon: const Icon(Icons.add_rounded, color: AppColors.textOnPrimary, size: 24),
      label: const Text(
        'Add Task',
        style: TextStyle(
          color: AppColors.textOnPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    )
        .animate()
        .slideY(delay: 300.ms, duration: 500.ms, begin: 2, curve: Curves.easeOut)
        .fadeIn();
  }

  int _countLeafNodes(TodoItem item) {
    if (item.children.isEmpty) {
      return 1;
    }
    int count = 0;
    for (var child in item.children) {
      count += _countLeafNodes(child);
    }
    return count;
  }

  int _countCompletedLeafNodes(TodoItem item) {
    if (item.children.isEmpty) {
      return item.isDone ? 1 : 0;
    }
    int count = 0;
    for (var child in item.children) {
      count += _countCompletedLeafNodes(child);
    }
    return count;
  }

  void _showAddItemDialog(
      BuildContext context, TodoProvider provider, TodoItem parent) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.primaryGradient),
                    shape: BoxShape.circle),
                child:
                    const Icon(Icons.add_task, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 20),
              Text('Add New Task',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Create a new task in "${parent.title}"',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(
                      hintText: 'Enter task title...',
                      prefixIcon: Icon(Icons.check_box_outlined)),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      provider.addTodoItem(parent, value);
                      Navigator.of(context).pop();
                    }
                  }),
              const SizedBox(height: 28),
              Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'))),
                const SizedBox(width: 12),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            provider.addTodoItem(parent, controller.text);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Add Task')))
              ])
            ],
          ),
        ),
      ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  void _showDeleteItemDialog(BuildContext context, TodoProvider provider,
      TodoItem parent, TodoItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.delete_outline, color: AppColors.error),
          SizedBox(width: 8),
          Text('Delete Task')
        ]),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete "${item.title}"?'),
              if (item.children.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: AppColors.warning, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(
                              'This will also delete ${_countLeafNodes(item)} subtask${_countLeafNodes(item) > 1 ? 's' : ''}.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w500)))
                    ]))
              ]
            ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                provider.removeTodoItem(parent, item);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.textOnPrimary),
              child: const Text('Delete'))
        ],
      ),
    );
  }
}