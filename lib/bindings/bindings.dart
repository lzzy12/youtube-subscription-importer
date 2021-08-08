import 'package:get/get.dart';
import 'package:youtube_migrator/controllers/progress_dialog_controller.dart';
import 'package:youtube_migrator/controllers/subscription_controller.dart';

class GlobalBindings extends Bindings{

  @override
  void dependencies() {
    Get.put<SubscriptionController>(SubscriptionController(), permanent: true);
    Get.put<ProgressDialogController>(ProgressDialogController());
  }
}