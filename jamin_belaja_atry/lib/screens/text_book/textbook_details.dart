//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/textbook_model.dart';


class TextbookDetailsPage extends StatelessWidget {
  final Textbook textbook;

  TextbookDetailsPage({required this.textbook});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(textbook.name ?? 'Textbook Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF6C74E1),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue, Color(0xFFE5E5E5)], // Soft gradient from white to light grey
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              margin: EdgeInsets.all(20.0),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      textbook.name ?? 'No Title',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C74E1),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    _buildDetailRow('Subject:', textbook.subject ?? 'Unknown Subject'),
                    _buildDetailRow('Year:', textbook.year?.toString() ?? 'Unknown Year'),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _openTextbook(context, textbook.downloadUrl);
                      },
                      child: Text('Download and Read',style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6C74E1),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C74E1),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _openTextbook(BuildContext context, String? downloadUrl) {
    if (downloadUrl != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Opening textbook...')),
      );
      // Example: Use url_launcher to launch the download URL
      // launch(downloadUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No download URL available')),
      );
    }
  }
}