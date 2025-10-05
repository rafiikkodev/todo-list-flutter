import 'package:flutter/material.dart';
import 'package:template_project_flutter/shared/theme.dart';
import 'package:template_project_flutter/widgets/custom_card.dart';
import 'package:template_project_flutter/widgets/custom_category.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          buildHeader(),
          buildGreetingTexts(),
          buildSearchContainer(),
          buildTaskCategories(context),
          buildTodaysTasks(),
          buildTasksCards(),
        ],
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
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Good Morning, Yanto!",
            style: blackSecondaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: medium,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "You have 49 tasks\nthis month",
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
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: blackThirdColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        onPressed: () {},
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Image.asset("assets/ic-search.png"),
              SizedBox(width: 10),
              Text(
                "Search a task...",
                style: whiteTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: medium,
                ),
              ),
            ],
          ),
        ),
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
              Navigator.pushNamed(context, "/todo");
            },
          ),
          CustomCategory(iconPath: "assets/ic-todo-done.png", title: "Done"),
          CustomCategory(iconPath: "assets/ic-pomodoro.png", title: "Pomodoro"),
          CustomCategory(iconPath: "assets/ic-add-task.png", title: "Add Task"),
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
          Text(
            "Today’s Tasks",
            style: blackPrimaryTextStyle.copyWith(
              fontSize: 24,
              fontWeight: semiBold,
            ),
          ),
          Text(
            "See All",
            style: blackSecondaryTextStyle.copyWith(
              fontSize: 12,
              fontWeight: regular,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTasksCards() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            CustomCardHome(
              title: "Lorem ipsum",
              subTitle: "dolor sit amet, consectetur",
              time: "10:00 AM",
              progress: "48%",
            ),
            SizedBox(width: 14),
            CustomCardHome(
              title: "Lorem ipsum",
              subTitle: "dolor sit amet, consectetur",
              time: "10:00 AM",
              progress: "48%",
            ),
            SizedBox(width: 14),
            CustomCardHome(
              title: "Lorem ipsum",
              subTitle: "dolor sit amet, consectetur",
              time: "10:00 AM",
              progress: "48%",
            ),
          ],
        ),
      ),
    );
  }
}
