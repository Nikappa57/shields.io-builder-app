import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readme_editor/screens/single_readme.dart';
import 'package:readme_editor/widgets/readme_list/rename_readme.dart';

class ReadMeItemList extends StatelessWidget {
  ReadMeItemList(this.documentId, this.title, this.text);

  final String documentId;
  final String title;
  final String text;

  void _deleteReadme(DismissDirection d) async {
    final user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('readme')
        .document(documentId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('title'),
      direction: DismissDirection.endToStart,
      background: Container(
        child: const Text(
          "Delete",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerRight,
      ),
      onDismissed: _deleteReadme,
      confirmDismiss: (direction) async {
        bool _confirm = false;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete"),
              content: const Text("Do you want to delete the readme?"),
              actions: [
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () {
                    _confirm = true;
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return _confirm;
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleReadMe(documentId, title, text)),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).accentTextTheme.headline1.color,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).accentIconTheme.color,
            ),
            onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: RenameReadMe(documentId, title),
                  );
                }),
          ),
        ),
      ),
    );
  }
}