import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_migrator/controllers/subscription_controller.dart';
import 'package:youtube_migrator/models/user.dart';
import 'package:youtube_migrator/ui/home/creator_tile.dart';
import 'package:youtube_migrator/ui/home/user_tile.dart';

enum ListType { source, target }

class CreatorsList extends StatelessWidget {
  final ListType listType;

  CreatorsList({required this.listType});

  @override
  Widget build(BuildContext context) {
    SubscriptionController controller = Get.find();
    final list = listType == ListType.source
        ? controller.sourceSubscriptions
        : controller.targetSubscriptions;
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Obx(
        () => ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: controller.isLoadingSourceSubscription &&
                  listType == ListType.source
              ? 2
              : list.length + 1,
          itemBuilder: (ctx, i) {
            return Obx(() {
              if (i == 0) {
                if (listType == ListType.source) {
                  if (controller.sourceUser.value != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UserTile(
                          user: controller.sourceUser
                                  .value ?? // this should not be null if it reaches this code
                              GoogleUser(
                                  email: "", name: "", profilePic: "", id: ""),
                          onLogout: controller.logoutSource,
                        ),
                      ),
                    );
                  } else
                    return SignInButton(Buttons.Google, onPressed: () {
                      if (controller.sourceLoginRequesting) {
                        Get.snackbar(
                            "Error", "A login flow is already in progress",
                            duration: Duration(seconds: 3));
                        return;
                      }
                      controller.onSourceLoginClicked((String error) {
                        Get.snackbar("Error", error,
                            duration: Duration(seconds: 5),
                            snackPosition: SnackPosition.TOP);
                      });
                    });
                } else {
                  if (controller.targetUser.value != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: UserTile(
                          user: controller.targetUser
                                  .value ?? // this should not be null if it reaches this code
                              GoogleUser(
                                  email: "", name: "", profilePic: "", id: ""),
                          onLogout: controller.logoutTarget,
                          onDelete: () => controller.deleteAllTargetItems(),
                        ),
                      ),
                    );
                  } else {
                    return SignInButton(Buttons.Google,
                        onPressed: () =>
                            controller.onTargetLoginClicked((String error) {
                              Get.snackbar("Error", error,
                                  duration: Duration(seconds: 5),
                                  snackPosition: SnackPosition.BOTTOM);
                            }));
                  }
                }
              }
              if (controller.isLoadingSourceSubscription &&
                  i == 1 &&
                  listType == ListType.source) {
                return Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Center(child: CircularProgressIndicator()));
              }
              return CreatorTile(
                list[i - 1],
                onMoveClicked: listType == ListType.source ? () {} : null,
              );
            });
          },
          separatorBuilder: (ctx, i) => SizedBox(
            height: 1.0,
            child: Center(
              child: Container(
                margin: EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                height: 1.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
