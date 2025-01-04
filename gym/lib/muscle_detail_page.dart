import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_exercise_page.dart';
import 'progress_page.dart';

class MuscleDetailPage extends StatefulWidget {
  final String muscle;

  const MuscleDetailPage({super.key, required this.muscle});

  @override
  _MuscleDetailPageState createState() => _MuscleDetailPageState();
}

class _MuscleDetailPageState extends State<MuscleDetailPage> {
  List<Map<String, dynamic>> exercises = [];
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    if (user == null) {
      print('No user signed in');
      return;
    }

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('exercises')
          .where('muscle', isEqualTo: widget.muscle)
          .get();
      setState(() {
        exercises = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      print('Error loading exercises: $e');
    }
  }

  void addExercise(Map<String, dynamic> exercise) {
    if (user == null) {
      print('No user signed in');
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('exercises')
        .add(exercise)
        .then((docRef) {
      setState(() {
        exercise['id'] = docRef.id;
        exercises.add(exercise);
      });
    }).catchError((error) {
      print('Error adding exercise: $error');
    });
  }

  void editExercise(int index, Map<String, dynamic> updatedExercise) {
    if (user == null) {
      print('No user signed in');
      return;
    }

    final String exerciseId = exercises[index]['id'];
    final previousPr = exercises[index]['pr'];

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('exercises')
        .doc(exerciseId)
        .update({
      'pr': updatedExercise['pr'],
      'previousPr': previousPr, // Update previous PR to current PR
      'reps': updatedExercise['reps'],
    }).then((_) {
      setState(() {
        exercises[index] = {
          'id': exerciseId,
          'name': exercises[index]['name'], // Name remains the same
          'pr': updatedExercise['pr'],
          'previousPr': previousPr,
          'reps': updatedExercise['reps'],
          'muscle': exercises[index]['muscle'],
        };
      });
    }).catchError((error) {
      print('Error updating exercise: $error');
    });
  }

  void deleteExercise(int index) {
    if (user == null) {
      print('No user signed in');
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('exercises')
        .doc(exercises[index]['id'])
        .delete()
        .then((_) {
      setState(() {
        exercises.removeAt(index);
      });
    }).catchError((error) {
      print('Error deleting exercise: $error');
    });
  }

  void incrementReps(int index) async {
    if (user == null) {
      print('No user signed in');
      return;
    }

    try {
      setState(() {
        exercises[index]['reps']++;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('exercises')
          .doc(exercises[index]['id'])
          .update({'reps': exercises[index]['reps']});
    } catch (e) {
      print('Error incrementing reps: $e');
    }
  }

  void decrementReps(int index) async {
    if (user == null) {
      print('No user signed in');
      return;
    }

    try {
      setState(() {
        exercises[index]['reps'] =
            (exercises[index]['reps'] > 0) ? exercises[index]['reps'] - 1 : 0;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('exercises')
          .doc(exercises[index]['id'])
          .update({'reps': exercises[index]['reps']});
    } catch (e) {
      print('Error decrementing reps: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.muscle} Exercises'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            onPressed: () {
              double previousAveragePr = exercises.isNotEmpty
                  ? exercises
                      .map((e) => e['previousPr'] ?? e['pr'])
                      .reduce((a, b) => a + b) /
                      exercises.length
                  : 0;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgressPage(
                    exercises: exercises,
                    previousAveragePr: previousAveragePr,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body:exercises.isEmpty?const Center(child: Text("Add an excersie ",style: TextStyle(fontWeight: FontWeight.bold),),):ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(exercises[index]['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PR: ${exercises[index]['pr']}'),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => decrementReps(index),
                      ),
                      Text('Reps: ${exercises[index]['reps']}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => incrementReps(index),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddExercisePage(
                            muscle: widget.muscle,
                            exercise: exercises[index],
                            index: index,
                            onSave: editExercise,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteExercise(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExercisePage(
                muscle: widget.muscle,
                onSave: (int _, Map<String, dynamic> exercise) =>
                    addExercise(exercise),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
