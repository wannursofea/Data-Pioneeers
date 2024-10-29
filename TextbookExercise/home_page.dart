import 'package:flutter/material.dart';
import 'textbook_page.dart';
import 'exercise_page.dart';
//import 'exercise_chapter.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sila Pilih:',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TextbookPage()),
                );
              },
              child: const Text('Buku Teks'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExercisePage()),
                );
              },
              child: const Text('Buku Latihan'),
            ),
           
          ],
        ),
      ),
    );
  }
}
