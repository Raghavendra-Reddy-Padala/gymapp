import 'package:flutter/material.dart';
import 'package:gym/muscle_detail_page.dart';

class MuscleListPage extends StatelessWidget {
  final List<Map<String, String>> muscles = [
    {'name': 'Bicep', 'image': 'assets/bicep.jpeg'},
    {'name': 'Tricep', 'image': 'assets/tricep.jpeg'},
    {'name': 'Chest', 'image': 'assets/chest.jpeg'},
    {'name': 'Back', 'image': 'assets/back.jpeg'},
    {'name': 'Shoulders', 'image': 'assets/shoulders.jpeg'},
    {'name': 'Legs', 'image': 'assets/legs.jpeg'},
  ];

  MuscleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Muscle Group'),centerTitle: true,),
      body: ListView.builder(
        itemCount: muscles.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: Image.asset(muscles[index]['image']!),
              title: Text(muscles[index]['name']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MuscleDetailPage(muscle: muscles[index]['name']!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}