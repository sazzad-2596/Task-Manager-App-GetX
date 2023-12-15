import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:task_manager_app_getx/ui/controller/progress_task_controller.dart';
import '../../style/styles.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_list_card.dart';


class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<ProgressTaskController>().getTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummeryCard(),
            Expanded(
              child: GetBuilder<ProgressTaskController>(
                builder: (progressTaskController) {
                  return Visibility(
                    visible: progressTaskController.getNewTaskInProgress == false,
                    replacement: Center(
                      child: CircularProgressIndicator(color: PrimaryColor.color),
                    ),
                    child: RefreshIndicator(
                      color: PrimaryColor.color,
                      onRefresh: progressTaskController.getTaskList,
                      child: ListView.builder(
                        itemCount: progressTaskController.taskListModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListCard(
                            statusColor: Colors.purple,
                            task: progressTaskController.taskListModel.taskList![index],
                            onStatusChangeRefresh: () {
                              progressTaskController.getTaskList();
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