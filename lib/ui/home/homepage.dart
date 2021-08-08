import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_migrator/controllers/progress_dialog_controller.dart';
import 'package:youtube_migrator/controllers/subscription_controller.dart';
import 'package:youtube_migrator/ui/home/creators_list.dart';
import 'package:youtube_migrator/ui/home/progress_dialog.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SubscriptionController controller = Get.find();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Obx(
          () => controller.subscribing
              ? CircularProgressIndicator()
              : Icon(Icons.navigate_next),
        ),
        tooltip: "Subscribe to all channels in target account",
        onPressed: () async {
          if (controller.targetUser.value == null) {
            Get.snackbar("Error", "Sign in to target account first to continue",
                duration: Duration(seconds: 3));
            return;
          }
          if (controller.targetSubscriptions.length == 0) {
            Get.snackbar("Error",
                "Add channels to the target list to subscribe to first",
                duration: Duration(seconds: 3));
            return;
          }
          showDialog(
              context: context,
              builder: (context) => ProgressDialog(),
              barrierDismissible: false);
          ProgressDialogController dialogController = Get.find();
          await controller.subscribeChannelsToTarget(
              dialogController.onProgress,
              (String error) => Get.snackbar("Error", error,
                  backgroundColor: Colors.red, duration: Duration(seconds: 3)));
        },
      ),
      body: Container(
        padding: EdgeInsets.all(62),
        child: Column(
          children: [
            Text(
              "Youtube Subscriber Importer",
              style: GoogleFonts.inconsolata(
                  fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CreatorsList(
                      listType: ListType.source,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () =>
                          controller.addAllCreatorsToTargetClicked()),
                  Expanded(
                    child: CreatorsList(
                      listType: ListType.target,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
