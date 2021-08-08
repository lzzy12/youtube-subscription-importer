import 'package:get/get.dart';
import 'package:youtube_migrator/models/creator.dart';

class ProgressDialogController extends GetxController {
  final _count = 0.obs;
  final _currentCreator = Rx<Creator?>(null);
  final _total = 0.obs;

  Creator? get currentCreator => _currentCreator.value;

  int get count => _count.value;

  int get totalCount => _total.value;

  void onProgress(Creator creator, int i, int total) {
    if (_total.value != total) _total.value = total;
    _count.value = i;
    _currentCreator.value = creator;
  }
}
