
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../../style/styles.dart';
import '../controller/new_task_controller.dart';
import '../controller/validation_input.dart';
import '../widgets/body_background.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/snack_message.dart';
import 'main_bottom_nav_screen.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _subjectInputTEController =
  TextEditingController();
  final TextEditingController _descriptionInputTEController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool taskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainBottomNavScreen(),
            ),
                (route) => false);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const ProfileSummeryCard(),
              Expanded(
                child: BodyBackGround(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 40,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add New Task",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _subjectInputTEController,
                              decoration: const InputDecoration(
                                hintText: "Subject",
                              ),
                              validator: FormValidation.inputValidation,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _descriptionInputTEController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                  hintText: "Description"),
                              validator: FormValidation.inputValidation,
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: Visibility(
                                visible: taskInProgress == false,
                                replacement: Center(
                                  child: CircularProgressIndicator(
                                      color: PrimaryColor.color),
                                ),
                                child: ElevatedButton(
                                  onPressed: _createNewTask,
                                  child: const Text('ADD', style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createNewTask() async {
    if (_formKey.currentState!.validate()) {
      taskInProgress = true;
      if (mounted) {
        setState(() {});
      }

      final NetworkResponse response =
      await NetworkCaller.postRequest(Urls.createNewTask, body: {
        "title": _subjectInputTEController.text.trim(),
        "description": _descriptionInputTEController.text.trim(),
        "status": "New",
      });

      taskInProgress = false;
      if (mounted) {
        setState(() {});
      }

      if (response.isSuccess) {
        _subjectInputTEController.clear();
        _descriptionInputTEController.clear();
        //autometically trigger
        // Get.find<NewTaskController>().getTaskList();
        if (mounted) {
          SnackMsg(context, "New Task Added Successfully!");
        }
      } else {
        if (mounted) {
          SnackMsg(context, "Failed! Please Try Again.", true);
        }
      }
    }
  }

  @override
  void dispose() {
    _subjectInputTEController.dispose();
    _descriptionInputTEController.dispose();
    super.dispose();
  }
}