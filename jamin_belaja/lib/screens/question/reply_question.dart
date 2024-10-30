import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jamin_belaja/models/questions.dart';
import 'package:jamin_belaja/models/reply.dart';
import 'package:jamin_belaja/services/database.dart';
import 'package:jamin_belaja/models/user.dart' as custom_user;

class ReplyQuestion extends StatefulWidget {
  final QuestionsList question;

  ReplyQuestion({required this.question});

  @override
  _ReplyQuestionState createState() => _ReplyQuestionState();
}

class _ReplyQuestionState extends State<ReplyQuestion> {
  final TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final custom_user.User? user = Provider.of<custom_user.User?>(context);
    final String userId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Question Detail'),
        backgroundColor: Color(0xFF6C74E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question details
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 15, color: Colors.grey[600]),
                ),
                SizedBox(width: 8),
                Spacer(),
                Text(
                  '• ${widget.question.createdAt.toDate().toLocal()}',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              widget.question.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(
              widget.question.context,
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: widget.question.keywords.values.map((keyword) {
                return Chip(
                  label: Text(keyword),
                  backgroundColor: Colors.grey[100],
                  labelStyle: TextStyle(color: Colors.black54),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Reply form
            TextField(
              controller: _replyController,
              decoration: InputDecoration(
                hintText: 'Write a reply...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (_replyController.text.isNotEmpty) {
                  await DatabaseService(uid: userId).addReply(
                    widget.question.id,
                    _replyController.text,
                    userId,
                  );
                  _replyController.clear();
                }
              },
              child: Text('Post Reply'),
            ),
            SizedBox(height: 20),
            // Replies section
            Expanded(
              child: StreamBuilder<List<Reply>>(
                stream:
                    DatabaseService(uid: userId).getReplies(widget.question.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final replies = snapshot.data!;
                  return ListView.builder(
                    itemCount: replies.length,
                    itemBuilder: (context, index) {
                      final reply = replies[index];
                      return ListTile(
                        title: Text(reply.content),
                        subtitle: Text(reply.createdAt.toLocal().toString()),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
