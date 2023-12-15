import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:task_manager_app_getx/ui/controller/new_task_controller.dart';
import '../../data/models/task_count.dart';
import '../../data/models/task_list_status_count.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../../style/styles.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_list_card.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool getTaskStatusCountInProgress = false;
  TaskListStatusCountModel taskListStatusCountModel =
  TaskListStatusCountModel();

  Future<void> getTaskStatusCount() async {
    getTaskStatusCountInProgress = true;
    if (mounted) {
      setState(() {});
    }
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.getTaskStatusCount);
    if (response.isSuccess) {
      taskListStatusCountModel =
          TaskListStatusCountModel.fromJson(response.jsonResponse);
    }
    getTaskStatusCountInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }


  @override
  void initState() {
    super.initState();
    getTaskStatusCount();
    Get.find<NewTaskController>().getTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummeryCard(),
            Visibility(
              visible: getTaskStatusCountInProgress == false &&
                  (taskListStatusCountModel.taskCountList?.isNotEmpty ?? false),
              replacement: LinearProgressIndicator(
                color: PrimaryColor.color,
                backgroundColor: Colors.grey,
              ),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                  taskListStatusCountModel.taskCountList?.length ?? 0,
                  itemBuilder: (context, index) {
                    TaskCount taskCount =
                    taskListStatusCountModel.taskCountList![index];
                    return FittedBox(
                      child: SummaryCard(
                        summaryCount: taskCount.sum.toString(),
                        summaryTitle: taskCount.sId ?? '',
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: GetBuilder<NewTaskController>(
                builder: (newTaskController) {
                  return Visibility(
                    visible: newTaskController.getNewTaskInProgress == false,
                    replacement: Center(
                      child: CircularProgressIndicator(color: PrimaryColor.color),
                    ),
                    child: RefreshIndicator(
                      color: PrimaryColor.color,
                      onRefresh: () => newTaskController.getTaskList(),
                      child: ListView.builder(
                        itemCount: newTaskController.taskListModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListCard(
                            task: newTaskController.taskListModel.taskList![index],
                            onStatusChangeRefresh: () {
                              newTaskController.getTaskList();
                              getTaskStatusCount();
                            },
                            taskUpdateStatusInProgress: (inProgress) {
                            },
                          );
                        },
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );
        },
        backgroundColor: PrimaryColor.color,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}