import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_migrator/models/creator.dart';

class CreatorTile extends StatelessWidget {
  final Creator creator;
  final void Function()? onMoveClicked;
  CreatorTile(this.creator, {this.onMoveClicked});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 45,
        child: Image.network(creator.imageUrl),
      ),
      title: Text(
        creator.name,
        style: GoogleFonts.openSans(
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        creator.subscribersCountText,
        style: GoogleFonts.inconsolata(
          fontSize: 20,
        ),
      ),
      trailing: onMoveClicked == null? null: IconButton(icon: Icon(Icons.navigate_next), onPressed: () {}),
    );
  }
}
