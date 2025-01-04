import 'package:flutter/material.dart';

class AddExercisePage extends StatefulWidget {
  final String muscle;
  final Map<String, dynamic>? exercise;
  final int? index;
  final Function(int, Map<String, dynamic>)? onSave;

  const AddExercisePage({
    super.key,
    required this.muscle,
    this.exercise,
    this.index,
    this.onSave,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddExercisePageState createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  final _formKey = GlobalKey<FormState>();
  late String _exerciseName;
  late int _pr;
  late int _reps;

  @override
  void initState() {
    super.initState();
    _exerciseName = widget.exercise?['name'] ?? '';
    _pr = widget.exercise?['pr'] ?? 0;
    _reps = widget.exercise?['reps'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add/Edit Exercise'),centerTitle: true,),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _exerciseName,
                decoration: const InputDecoration(labelText: 'Exercise Name'),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter exercise name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _exerciseName = value!;
                },
              ),
              TextFormField(
                initialValue: _pr.toString(),
                decoration: const InputDecoration(labelText: 'Personal Record (PR)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a PR';
                  }
                  return null;
                },
                onSaved: (value) {
                  _pr = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _reps.toString(),
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reps';
                  }
                  return null;
                },
                onSaved: (value) {
                  _reps = int.parse(value!);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Map<String, dynamic> updatedExercise = {
                      'muscle': widget.muscle,
                      'name': _exerciseName,
                      'pr': _pr,
                      'reps': _reps,
                    };
                    widget.onSave!(widget.index ?? -1, updatedExercise);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
