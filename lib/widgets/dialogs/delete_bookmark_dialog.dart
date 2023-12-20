import 'package:flutter/material.dart';
import 'package:studi_match/models/bookmark.dart';

class DeleteBookmarkDialog extends StatelessWidget {
  final Bookmark bookmark;

  const DeleteBookmarkDialog({super.key, required this.bookmark});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Lösche Lesezeichen'),
        backgroundColor: Colors.white,
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Bist du dir sicher ein favoritisiertes Lesezeichen zu löschen?'),
              const SizedBox(height: 8),
              ListTile(
                title: Text(bookmark.title ?? 'Kein Titel verfügbar'),
                subtitle: Text(bookmark.employer),
              ),
            ]),
        actions: <Widget>[
          OutlinedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ja', style: TextStyle(color: Colors.black87))),
          OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Nein', style: TextStyle(color: Colors.black87))),
        ],
      );
}
