
class Creator {
  String id;
  String name;
  String subscribersCountText;
  bool notificationOn;
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
