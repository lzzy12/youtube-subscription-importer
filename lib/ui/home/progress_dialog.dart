import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_migrator/controllers/progress_dialog_controller.dart';

class ProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProgressDialogController controller = Get.find();
    return AlertDialog(
      title: Text("Processing.."),
      content: Obx(
        () => Text(
            "Subscribing to ${controller.currentCreator?.name} (${controller.count}/${controller.totalCount})"),
      ),
      actions: [
        ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text("Cancel"))
      ],
    );
  }
}
