import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:todo_app_day3/data.dart';
import 'package:todo_app_day3/main.dart';

class EditTextScreen extends StatefulWidget {
  EditTextScreen({
    super.key,
    required this.task,
  });

  final TodoTask task;

  @override
  State<EditTextScreen> createState() => _EditTextScreenState();
}

class _EditTextScreenState extends State<EditTextScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        title: const Text("edit page"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: prioritycheckbox(
                    ontap: () => setState(() {
                      widget.task.priority = Priority.high;
                    }),
                    label: 'High',
                    color: PrimaryColor,
                    isSelected: widget.task.priority == Priority.high,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  flex: 1,
                  child: prioritycheckbox(
                    ontap: () => setState(() {
                      widget.task.priority = Priority.normal;
                    }),
                    label: 'Normal',
                    color: normalColor,
                    isSelected: widget.task.priority == Priority.normal,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  flex: 1,
                  child: prioritycheckbox(
                    ontap: () => setState(() {
                      widget.task.priority = Priority.low;
                    }),
                    label: 'Low',
                    color: lowColor,
                    isSelected: widget.task.priority == Priority.low,
                  ),
                ),
              ],
            ),
            TextField(
              controller: _controller,
              decoration:
                  const InputDecoration(label: Text("add a task for today...")),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_controller.text.isEmpty) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Please Fill Textbox'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            widget.task.name = _controller.text;
            //default priortiy of task
            widget.task.priority = widget.task.priority;
            //save task
            if (widget.task.isInBox) {
              widget.task.save();
            } else {
              final Box<TodoTask> box = Hive.box(TodoTaskBoxName);
              box.add(widget.task);
            }
            Navigator.pop(context);
          }

          //Get name task from Text field
        },
        label: const Text("Save task"),
      ),
    );
  }
}

class prioritycheckbox extends StatelessWidget {
  final GestureTapCallback ontap;
  const prioritycheckbox(
      {super.key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.ontap});

  final String label;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return InkWell(
      onTap: ontap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: SecondryColor.withOpacity(0.3),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              bottom: 0,
              top: 0,
              right: 10,
              child: Center(
                child: _chekBoxShap(
                  value: isSelected,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _chekBoxShap extends StatelessWidget {
  const _chekBoxShap({super.key, required this.value, required this.color});
  final Color color;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          12,
        ),
        color: color,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 14,
            )
          : null,
    );
  }
}
