import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../data/models/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../../style/styles.dart';
import '../controller/completed_task_controller.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_list_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {


  @override
  void initState() {
    super.initState();
    Get.find<CompletedTaskController>().getTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummeryCard(),
            Expanded(
              child: GetBuilder<CompletedTaskController>(
                builder: (completedTaskController) {
                  return Visibility(
                    visible: completedTaskController.getNewTaskInProgress == false,
                    replacement: Center(
                      child: CircularProgressIndicator(color: PrimaryColor.color),
                    ),
                    child: RefreshIndicator(
                      color: PrimaryColor.color,
                      onRefresh: completedTaskController.getTaskList,
                      child: ListView.builder(
                        itemCount: completedTaskController.taskListModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListCard(
                            statusColor: PrimaryColor.color,
                            task: completedTaskController.taskListModel.taskList![index],
                            onStatusChangeRefresh: () {
                              completedTaskController.getTaskList();
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
            )
          ],
        ),
      ),
    );
  }
}