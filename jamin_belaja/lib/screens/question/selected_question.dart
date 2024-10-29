import 'package:flutter/material.dart';

class SelectedQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Question & Replies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Replace with dynamic data
            buildQuestionCard('Question Title', 'Question body...', '78', '78'),
            SizedBox(height: 10),
            buildReplyCard('Reply text...', 'Replier Name', 'Reply Date'),
          ],
        ),
      ),
    );
  }

  Widget buildQuestionCard(
      String title, String description, String commentCount, String likeCount) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(description),
            Row(
              children: [
                Icon(Icons.comment_outlined),
                SizedBox(width: 4),
                Text(commentCount),
                SizedBox(width: 16),
                Icon(Icons.thumb_up_alt_outlined),
                SizedBox(width: 4),
                Text(likeCount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReplyCard(
      String replyText, String replierName, String replyDate) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$replierName . $replyDate',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(replyText),
          ],
        ),
      ),
    );
  }
}
