import 'package:flutter/material.dart';
import 'package:youtube_migrator/models/user.dart';

class UserTile extends StatelessWidget {
  final GoogleUser user;
  final void Function() onLogout;
  final void Function()? onDelete;

  UserTile({required this.user, required this.onLogout, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 45,
        child: Image.network(user.profilePic ?? ""),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: onLogout,
          ),
          if (onDelete != null)
            IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
        ],
      ),
    );
  }
}
