
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../data/models/task_list_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class CompletedTaskController extends GetxController{

  bool _getTaskListInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

  //expose
  bool get getNewTaskInProgress => _getTaskListInProgress;
  TaskListModel get taskListModel => _taskListModel;

  Future<bool> getTaskList() async {
    bool isSuccess = false;
    _getTaskListInProgress = true;
    update();
    NetworkResponse response =
    await NetworkCaller.getRequest(Urls.getProgressTaskList);
    _getTaskListInProgress = false;

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    update();
    return isSuccess;

  }
}