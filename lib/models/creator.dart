
import 'package:hive/hive.dart';
part 'creator.g.dart';
@HiveType(typeId: 1)
class Creator {
  @HiveField(1)
  String id;
  @HiveField(2)
  String name;
  @HiveField(3)
  String subscribersCountText;
  @HiveField(4)
  bool notificationOn;
  @HiveField(5)
  String imageUrl;

  Creator(
      {required this.id,
      required this.name,
      required this.subscribersCountText,
      required this.notificationOn,
      required this.imageUrl});

  @override
  bool operator ==(Object other) {
    return other is Creator && other.id == this.id && other.name == this.name;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

}
