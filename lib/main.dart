import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app_day3/TaskPage.dart';
import 'package:todo_app_day3/data.dart';

const TodoTaskBoxName = "task";
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoTaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TodoTask>(TodoTaskBoxName);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: PrimaryColor,
  ));
  runApp(const MyApp());
}

const Color PrimaryColor = Color(0xff794cff);
final SecondryColor = Color(0xffAFBED0);
const Color PrimaryTextColor = Color(0xff1D2830);
const Color normalColor = Color.fromARGB(255, 46, 221, 237);
const Color lowColor = Color.fromARGB(255, 214, 99, 17);
const Color highColor = PrimaryColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xff1D2830);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: SecondryColor,
          ),
          //rang icon
          iconColor: SecondryColor,
          //hazf border
          border: InputBorder.none,
        ),
        colorScheme: ColorScheme.light(
          primary: PrimaryColor,
          primaryContainer: Color(0xff5c0aff),
          background: const Color(0xffF3f5f8),
          onSurface: PrimaryTextColor,
          onBackground: primaryColor,
          secondary: SecondryColor,
          onSecondary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TextEditingController controller = TextEditingController();
  final ValueNotifier searchkeyword = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    //Create box for Hive
    final box =
        Hive.box<TodoTask /*data dart*/ >(TodoTaskBoxName /*main dart*/);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditTextScreen(
                          task: TodoTask(),
                        )));
              },
              label: const Text("Add New Task")),
          //create listeable builder for update Task
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 105,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    themeData.primaryColor,
                    themeData.primaryColor.withOpacity(0.7),
                  ])),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "To Do List",
                              style: themeData.textTheme.headlineSmall!.apply(
                                  color: themeData.colorScheme.onPrimary),
                            ),
                            const Icon(
                              CupertinoIcons.share,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,

                              //width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(19),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 20)
                                ],
                              ),
                              child: TextField(
                                onChanged: (value) {
                                  searchkeyword.value = controller.text;
                                },
                                cursorHeight: 25,
                                controller: controller,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(top: 3),
                                  //filled: true,
                                  //hintStyle: TextStyle(fontSize: 20),
                                  hintText: 'Search your task...',
                                  prefixIcon: Icon(CupertinoIcons.search),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: searchkeyword,
                    builder: (context, value, child) => ValueListenableBuilder<
                            Box<TodoTask>>(
                        valueListenable: box.listenable(),
                        builder: (context, box, child) {
                          final List items;
                          if (controller.text.isEmpty) {
                            items = box.values.toList();
                          } else {
                            items = box.values
                                .where((task) =>
                                    task.name.contains(controller.text))
                                .toList();
                          }
                          if (items.isNotEmpty) {
                            return ListView.builder(
                              padding: EdgeInsets.only(
                                  top: 16, right: 16, left: 16, bottom: 100),
                              itemCount: items.length + 1,
                              itemBuilder: (context, index) {
                                if (index.toDouble() == 0) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Today",
                                            style: themeData
                                                .textTheme.headlineSmall
                                                ?.apply(
                                              fontSizeFactor: 0.9,
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 4),
                                            width: 70,
                                            height: 3,
                                            decoration: BoxDecoration(
                                              color: PrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(1.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                      MaterialButton(
                                        elevation: 0,
                                        color: Colors.grey.shade300,
                                        textColor: Colors.black45,
                                        onPressed: () {
                                          box.clear();
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              "Delete all item",
                                              style: TextStyle(
                                                fontFamily:
                                                    GoogleFonts.poppins()
                                                        .fontFamily,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Icon(
                                              CupertinoIcons.delete,
                                              size: 18,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  final Taskentity = items[index - 1];
                                  return TaskItem(Taskentity: Taskentity);
                                }
                              },
                            );
                          } else {
                            return epmtyState();
                          }
                        }),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class epmtyState extends StatelessWidget {
  const epmtyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/empty.jpg",
          width: 400,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          "Todo list is empty",
          style: TextStyle(fontSize: 25),
        ),
      ],
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.Taskentity,
  });

  final TodoTask Taskentity;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    final prorityColor;
    switch (widget.Taskentity.priority) {
      case Priority.low:
        prorityColor = lowColor;
        break;
      case Priority.normal:
        prorityColor = normalColor;
        break;
      case Priority.high:
        prorityColor = highColor;
        break;
    }
    return InkWell(
      //highlightColor: Colors.transparent,
      //splashFactory: NoSplash.splashFactory,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditTextScreen(task: widget.Taskentity)));
      },
      onLongPress: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Delete Item'),
            content: const Text('Do you want to delete this item?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Delete');
                  widget.Taskentity.delete();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(
          left: 15,
        ),
        height: 84,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
            )
          ],
          borderRadius: BorderRadius.circular(8),
          color: themedata.colorScheme.surface,
        ),
        child: Row(
          children: [
            CheckBox(
              value: widget.Taskentity.isCompleted,
              ontap: () {
                setState(() {
                  widget.Taskentity.isCompleted =
                      !widget.Taskentity.isCompleted;
                });
              },
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                widget.Taskentity.name,
                style: TextStyle(
                  decoration: widget.Taskentity.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            Container(
              width: 6,
              height: 84,
              decoration: BoxDecoration(
                color: prorityColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBox extends StatelessWidget {
  const CheckBox({super.key, required this.value, required this.ontap});

  final bool value;
  final Function() ontap;
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: ontap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: !value ? Border.all(color: SecondryColor, width: 2) : null,
          color: value ? PrimaryColor : null,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                color: themeData.colorScheme.onPrimary,
                size: 14,
              )
            : null,
      ),
    );
  }
}

//app bar widget


