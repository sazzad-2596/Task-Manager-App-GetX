

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app_getx/ui/controller/cancel_task_controller.dart';

import '../../data/models/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../../style/styles.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_list_card.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {


  @override
  void initState() {
    super.initState();
    Get.find<CancelTaskController>().getTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummeryCard(),
            Expanded(
              child: GetBuilder<CancelTaskController>(
                builder: (cancelTaskController) {
                  return Visibility(
                    visible: cancelTaskController.getNewTaskInProgress == false,
                    replacement: Center(
                      child: CircularProgressIndicator(color: PrimaryColor.color),
                    ),
                    child: RefreshIndicator(
                      color: PrimaryColor.color,
                      onRefresh: cancelTaskController.getTaskList,
                      child: ListView.builder(
                        itemCount: cancelTaskController.taskListModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListCard(
                            statusColor: Colors.redAccent,
                            task: cancelTaskController.taskListModel.taskList![index],
                            onStatusChangeRefresh: () {
                              cancelTaskController.getTaskList();
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