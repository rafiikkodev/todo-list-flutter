import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template_project_flutter/models/todo.dart';
import 'package:template_project_flutter/services/storage_service.dart';
import 'package:template_project_flutter/shared/theme.dart';
import 'package:template_project_flutter/widgets/custom_button.dart';
import 'package:template_project_flutter/widgets/custom_card.dart';
import 'package:template_project_flutter/widgets/custom_calendar_dialog.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final StorageService _storageService = StorageService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<Todo> _allTodos = [];
  List<Todo> _filteredTodos = [];
  List<Todo> _displayedTodos = [];
  DateTime _selectedCalendarDate = DateTime.now();
  DateTime? _selectedTaskDate;
  TimeOfDay? _selectedTaskTime;
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadTodos();

    // Check if modal should be shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['showModal'] == true) {
        _showAddTaskModal(context);
      }
    });
  }

  Future<void> _loadTodos() async {
    setState(() => _isLoading = true);
    final todos = await _storageService.getTodos();

    // Sort by date and time
    todos.sort((a, b) {
      final dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) return dateCompare;
      return a.time.compareTo(b.time);
    });

    setState(() {
      _allTodos = todos;
      _filterTodosByDate(_selectedCalendarDate);
      _isLoading = false;
    });
  }

  void _filterTodosByDate(DateTime date) {
    final filtered = _allTodos.where((todo) {
      return todo.date.year == date.year &&
          todo.date.month == date.month &&
          todo.date.day == date.day;
    }).toList();

    setState(() {
      _filteredTodos = filtered;
      _displayedTodos = filtered;
      _isSearching = false;
      _searchController.clear();
    });
  }

  void _searchTodos(String query) {
    if (query.isEmpty) {
      setState(() {
        _displayedTodos = _filteredTodos;
        _isSearching = false;
      });
      return;
    }

    // Search di semua todos (tidak terbatas tanggal)
    setState(() {
      _isSearching = true;
      _displayedTodos = _allTodos.where((todo) {
        final titleLower = todo.title.toLowerCase();
        final descriptionLower = todo.description.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();

      // Sort hasil search by date and time
      _displayedTodos.sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) return dateCompare;
        return a.time.compareTo(b.time);
      });
    });
  }

  Future<void> _addTodo() async {
    if (_titleController.text.isEmpty ||
        _selectedTaskDate == null ||
        _selectedTaskTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      date: _selectedTaskDate!,
      time: _selectedTaskTime!.format(context),
    );

    final success = await _storageService.addTodo(newTodo);

    if (success) {
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedTaskDate = null;
        _selectedTaskTime = null;
      });

      await _loadTodos();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task added successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _toggleTodoCompletion(String id) async {
    await _storageService.toggleTodoCompletion(id);
    await _loadTodos();

    // Refresh search results if searching
    if (_isSearching && _searchController.text.isNotEmpty) {
      _searchTodos(_searchController.text);
    }
  }

  Future<void> _deleteTodo(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.deleteTodo(id);
      await _loadTodos();

      // Refresh search results if searching
      if (_isSearching && _searchController.text.isNotEmpty) {
        _searchTodos(_searchController.text);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          _buildHeader(context),
          if (!_isSearching) _buildCalendar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _displayedTodos.isEmpty
                ? _buildEmptyState()
                : _buildScrollableStepper(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 85, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset("assets/ic-back.png"),
          ),
          CustomButtonMedium(
            title: "Add Task",
            iconPath: "assets/ic-plus.png",
            onPressed: () => _showAddTaskModal(context),
          ),
        ],
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black.withAlpha(200),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildModalHandle(),
                      _buildModalTitle(),
                      const SizedBox(height: 16),
                      _buildTitleTextField(),
                      const SizedBox(height: 16),
                      _buildDescriptionTextField(),
                      const SizedBox(height: 16),
                      _buildModalActions(context, setModalState),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalHandle() {
    return Container(
      width: 50,
      height: 5,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: blackThirdColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildModalTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Add Task",
        style: TextStyle(
          fontSize: 24,
          fontWeight: semiBold,
          color: blackPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildTitleTextField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        filled: true,
        fillColor: blackThirdColor,
        hintText: 'Task title',
        hintStyle: TextStyle(
          color: blackPrimaryColor,
          fontSize: 14,
          fontWeight: medium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
      ),
      style: TextStyle(color: blackPrimaryColor),
      cursorColor: blackPrimaryColor,
    );
  }

  Widget _buildDescriptionTextField() {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        filled: true,
        fillColor: blackThirdColor,
        hintText: 'Description',
        hintStyle: TextStyle(
          color: blackPrimaryColor,
          fontSize: 14,
          fontWeight: medium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
      ),
      style: TextStyle(color: blackPrimaryColor),
      cursorColor: blackPrimaryColor,
      minLines: 3,
      maxLines: null,
    );
  }

  Widget _buildModalActions(BuildContext context, StateSetter setModalState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            final result = await showCustomCalendarPicker(
              context,
              initialDate: _selectedTaskDate ?? DateTime.now(),
            );

            if (result != null && context.mounted) {
              setModalState(() {
                _selectedTaskDate = result['date'] as DateTime?;
                _selectedTaskTime = result['time'] as TimeOfDay?;
              });
            }
          },
          child: Row(
            children: [
              Image.asset("assets/ic-clock.png"),
              if (_selectedTaskDate != null && _selectedTaskTime != null) ...[
                const SizedBox(width: 8),
                Text(
                  _formatDateTime(_selectedTaskDate!, _selectedTaskTime!),
                  style: TextStyle(
                    color: blackPrimaryColor,
                    fontSize: 12,
                    fontWeight: medium,
                  ),
                ),
              ],
            ],
          ),
        ),
        GestureDetector(
          onTap: _addTodo,
          child: Image.asset("assets/ic-send.png"),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date, TimeOfDay time) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$formattedDate | $hour:$minute $period';
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: SizedBox(
        height: 100,
        child: DatePicker(
          DateTime.now(),
          width: 60,
          height: 80,
          initialSelectedDate: _selectedCalendarDate,
          selectedTextColor: whiteColor,
          selectionColor: purplePrimary,
          onDateChange: (date) {
            setState(() {
              _selectedCalendarDate = date;
              _filterTodosByDate(date);
            });
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isSearching ? Icons.search_off : Icons.task_alt,
            size: 80,
            color: blackThirdColor,
          ),
          const SizedBox(height: 16),
          Text(
            _isSearching ? 'No tasks found' : 'No tasks for this date',
            style: TextStyle(
              fontSize: 18,
              color: blackSecondaryColor,
              fontWeight: medium,
            ),
          ),
          if (_isSearching) ...[
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(
                fontSize: 14,
                color: blackSecondaryColor,
                fontWeight: regular,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScrollableStepper() {
    if (_isSearching) {
      // Group by date when searching
      return _buildGroupedSearchResults();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 24),
      itemCount: _displayedTodos.length,
      itemBuilder: (context, index) => _buildStepperItem(index),
    );
  }

  Widget _buildGroupedSearchResults() {
    // Group todos by date
    final Map<String, List<Todo>> groupedTodos = {};

    for (var todo in _displayedTodos) {
      final dateKey = DateFormat('EEEE, dd MMMM yyyy').format(todo.date);
      if (!groupedTodos.containsKey(dateKey)) {
        groupedTodos[dateKey] = [];
      }
      groupedTodos[dateKey]!.add(todo);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 24),
      itemCount: groupedTodos.length,
      itemBuilder: (context, groupIndex) {
        final dateKey = groupedTodos.keys.elementAt(groupIndex);
        final todos = groupedTodos[dateKey]!;
        final isToday = _isToday(todos.first.date);
        final isTomorrow = _isTomorrow(todos.first.date);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isToday
                    ? purplePrimary
                    : isTomorrow
                    ? purplePrimary.withAlpha(150)
                    : blackThirdColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: isToday || isTomorrow
                        ? whiteColor
                        : blackPrimaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isToday
                        ? 'Today • $dateKey'
                        : isTomorrow
                        ? 'Tomorrow • $dateKey'
                        : dateKey,
                    style: TextStyle(
                      color: isToday || isTomorrow
                          ? whiteColor
                          : blackPrimaryColor,
                      fontSize: 12,
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isToday || isTomorrow
                          ? whiteColor.withAlpha(50)
                          : purplePrimary.withAlpha(50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${todos.length}',
                      style: TextStyle(
                        color: isToday || isTomorrow
                            ? whiteColor
                            : purplePrimary,
                        fontSize: 10,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tasks for this date
            ...List.generate(todos.length, (index) {
              final todo = todos[index];
              final isLast = index == todos.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepperIndicatorForTodo(todo, isLast),
                  const SizedBox(width: 16),
                  _buildTaskCardForTodo(todo, isLast),
                ],
              );
            }),

            // Spacing between date groups
            if (groupIndex < groupedTodos.length - 1)
              const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  Widget _buildStepperItem(int index) {
    final todo = _displayedTodos[index];
    final isLast = index == _displayedTodos.length - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepperIndicator(todo, isLast),
        const SizedBox(width: 16),
        _buildTaskCard(todo, isLast),
      ],
    );
  }

  Widget _buildStepperIndicator(Todo todo, bool isLast) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _toggleTodoCompletion(todo.id),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: todo.isCompleted ? purplePrimary : Colors.transparent,
              border: Border.all(
                color: todo.isCompleted ? purplePrimary : blackThirdColor,
                width: 2,
              ),
            ),
            child: Center(
              child: todo.isCompleted
                  ? Icon(Icons.check, size: 14, color: whiteColor)
                  : const SizedBox.shrink(),
            ),
          ),
        ),
        if (!isLast)
          Container(
            width: 2,
            height: 100,
            color: todo.isCompleted ? purplePrimary : blackThirdColor,
          ),
      ],
    );
  }

  Widget _buildStepperIndicatorForTodo(Todo todo, bool isLast) {
    return _buildStepperIndicator(todo, isLast);
  }

  Widget _buildTaskCard(Todo todo, bool isLast) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
        child: Dismissible(
          key: Key(todo.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Task'),
                content: const Text(
                  'Are you sure you want to delete this task?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            _deleteTodo(todo.id);
          },
          child: CustomCardTodo(
            title: todo.title,
            subTitle: todo.description,
            time: todo.time,
            width: double.infinity,
            isActive: !todo.isCompleted,
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/edit-todo',
                arguments: {'todo': todo},
              ).then((_) => _loadTodos());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCardForTodo(Todo todo, bool isLast) {
    return _buildTaskCard(todo, isLast);
  }
}
