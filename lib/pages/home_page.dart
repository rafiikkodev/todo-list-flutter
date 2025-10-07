import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template_project_flutter/models/todo.dart';
import 'package:template_project_flutter/services/storage_service.dart';
import 'package:template_project_flutter/shared/theme.dart';
import 'package:template_project_flutter/widgets/custom_card.dart';
import 'package:template_project_flutter/widgets/custom_category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StorageService _storageService = StorageService();
  final TextEditingController _searchController = TextEditingController();

  List<Todo> _allTodos = [];
  List<Todo> _todayTodos = [];
  List<Todo> _filteredTodos = [];
  int _totalTasks = 0;
  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final allTodos = await _storageService.getTodos();
    final todayTodos = await _storageService.getTodayTodos();

    // Sort today's todos by time
    todayTodos.sort((a, b) => a.time.compareTo(b.time));

    setState(() {
      _allTodos = allTodos;
      _todayTodos = todayTodos;
      _filteredTodos = todayTodos;
      _totalTasks = allTodos.length;
      _isLoading = false;
    });
  }

  void _searchTodos(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredTodos = _todayTodos;
        _isSearching = false;
      });
      return;
    }

    // Search di semua todos (tidak terbatas hari ini)
    setState(() {
      _isSearching = true;
      _filteredTodos = _allTodos.where((todo) {
        final titleLower = todo.title.toLowerCase();
        final descriptionLower = todo.description.toLowerCase();
        final searchLower = query.toLowerCase();

        return titleLower.contains(searchLower) ||
            descriptionLower.contains(searchLower);
      }).toList();

      // Sort by date and time
      _filteredTodos.sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) return dateCompare;
        return a.time.compareTo(b.time);
      });
    });
  }

  String _calculateTodayProgress() {
    if (_todayTodos.isEmpty) return "0%";
    final completed = _todayTodos.where((todo) => todo.isCompleted).length;
    final percentage = (completed / _todayTodos.length * 100).round();
    return "$percentage%";
  }

  int _getCompletedTasksCount() {
    return _todayTodos.where((todo) => todo.isCompleted).length;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            buildHeader(),
            buildGreetingTexts(),
            buildSearchContainer(),
            if (_isSearching) buildSearchResults(),
            if (!_isSearching) ...[
              buildTaskCategories(context),
              buildTodaysTasks(),
              buildTasksCards(),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/Profile Container.png"),
          Image.asset("assets/Profile.png"),
        ],
      ),
    );
  }

  Widget buildGreetingTexts() {
    final now = DateTime.now();
    String greeting = "Good Morning";
    if (now.hour >= 12 && now.hour < 17) {
      greeting = "Good Afternoon";
    } else if (now.hour >= 17) {
      greeting = "Good Evening";
    }

    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$greeting, User!",
            style: blackSecondaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _isLoading
                ? "Loading..."
                : "You have $_totalTasks ${_totalTasks == 1 ? 'task' : 'tasks'}\nthis month",
            style: blackPrimaryTextStyle.copyWith(
              fontSize: 28,
              fontWeight: semiBold,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget buildSearchContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 36),
      height: 48,
      child: TextField(
        controller: _searchController,
        onChanged: _searchTodos,
        decoration: InputDecoration(
          filled: true,
          fillColor: blackThirdColor,
          hintText: 'Search all tasks...',
          hintStyle: whiteTextStyle.copyWith(fontSize: 14, fontWeight: medium),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset("assets/ic-search.png"),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: whiteColor),
                  onPressed: () {
                    _searchController.clear();
                    _searchTodos('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
        style: whiteTextStyle.copyWith(fontSize: 14, fontWeight: medium),
        cursorColor: whiteColor,
      ),
    );
  }

  Widget buildSearchResults() {
    // Group by date
    final Map<String, List<Todo>> groupedTodos = {};

    for (var todo in _filteredTodos) {
      final dateKey = DateFormat('EEEE, dd MMM yyyy').format(todo.date);
      if (!groupedTodos.containsKey(dateKey)) {
        groupedTodos[dateKey] = [];
      }
      groupedTodos[dateKey]!.add(todo);
    }

    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Search Results",
                style: blackPrimaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: purplePrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_filteredTodos.length}',
                  style: whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_filteredTodos.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.search_off, size: 64, color: blackThirdColor),
                    const SizedBox(height: 16),
                    Text(
                      'No tasks found',
                      style: TextStyle(
                        fontSize: 16,
                        color: blackSecondaryColor,
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try different keywords',
                      style: TextStyle(
                        fontSize: 12,
                        color: blackSecondaryColor,
                        fontWeight: regular,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...groupedTodos.entries.map((entry) {
              final dateKey = entry.key;
              final todos = entry.value;
              final firstTodo = todos.first;
              final isToday = _isToday(firstTodo.date);
              final isTomorrow = _isTomorrow(firstTodo.date);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header
                  Container(
                    margin: const EdgeInsets.only(bottom: 12, top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isToday
                          ? purplePrimary
                          : isTomorrow
                          ? purplePrimary.withAlpha(150)
                          : blackThirdColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: isToday || isTomorrow
                              ? whiteColor
                              : blackPrimaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isToday
                              ? 'Today'
                              : isTomorrow
                              ? 'Tomorrow'
                              : dateKey,
                          style: TextStyle(
                            color: isToday || isTomorrow
                                ? whiteColor
                                : blackPrimaryColor,
                            fontSize: 12,
                            fontWeight: semiBold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '• ${todos.length}',
                          style: TextStyle(
                            color: isToday || isTomorrow
                                ? whiteColor.withAlpha(200)
                                : blackSecondaryColor,
                            fontSize: 11,
                            fontWeight: regular,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tasks
                  ...todos.map((todo) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/edit-todo',
                            arguments: {'todo': todo},
                          ).then((_) => _loadData());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: todo.isCompleted
                                ? blackThirdColor
                                : purplePrimary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      todo.title,
                                      style: whiteTextStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: semiBold,
                                        decoration: todo.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if (todo.isCompleted)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            'Done',
                                            style: whiteTextStyle.copyWith(
                                              fontSize: 10,
                                              fontWeight: bold,
                                            ),
                                          ),
                                        ),
                                      Text(
                                        todo.time,
                                        style: whiteTextStyle.copyWith(
                                          fontSize: 12,
                                          fontWeight: medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                todo.description,
                                style: whiteTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: regular,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget buildTaskCategories(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomCategory(
            iconPath: "assets/ic-todo.png",
            title: "To-Do",
            onTap: () {
              Navigator.pushNamed(context, "/todo").then((_) => _loadData());
            },
          ),
          CustomCategory(
            iconPath: "assets/ic-todo-done.png",
            title: "Done",
            onTap: () {},
          ),
          CustomCategory(
            iconPath: "assets/ic-pomodoro.png",
            title: "Pomodoro",
            onTap: () {
              Navigator.pushNamed(context, "/pomodoro");
            },
          ),
          CustomCategory(
            iconPath: "assets/ic-add-task.png",
            title: "Add Task",
            onTap: () {
              Navigator.pushNamed(
                context,
                "/todo",
                arguments: {'showModal': true},
              ).then((_) => _loadData());
            },
          ),
        ],
      ),
    );
  }

  Widget buildTodaysTasks() {
    return Container(
      margin: const EdgeInsets.only(top: 52),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Tasks",
                style: blackPrimaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${_getCompletedTasksCount()}/${_todayTodos.length} completed • ${_calculateTodayProgress()}",
                style: blackSecondaryTextStyle.copyWith(
                  fontSize: 12,
                  fontWeight: regular,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/todo").then((_) => _loadData());
            },
            child: Text(
              "See All",
              style: blackSecondaryTextStyle.copyWith(
                fontSize: 12,
                fontWeight: regular,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTasksCards() {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        height: 200,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_todayTodos.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: blackThirdColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.task_alt, size: 48, color: blackSecondaryColor),
              const SizedBox(height: 12),
              Text(
                'No tasks for today',
                style: TextStyle(
                  fontSize: 16,
                  color: blackSecondaryColor,
                  fontWeight: medium,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _todayTodos.take(5).map((todo) {
            return Padding(
              padding: const EdgeInsets.only(right: 14),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/edit-todo',
                    arguments: {'todo': todo},
                  ).then((_) => _loadData());
                },
                child: CustomCardHome(
                  title: todo.title,
                  subTitle: todo.description.length > 30
                      ? '${todo.description.substring(0, 30)}...'
                      : todo.description,
                  time: todo.time,
                  progress: todo.isCompleted ? "100%" : "0%",
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
