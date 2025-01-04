import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProgressPage extends StatelessWidget {
  final List<Map<String, dynamic>> exercises;
  final double previousAveragePr;

  const ProgressPage({super.key, required this.exercises, required this.previousAveragePr});

  @override
  Widget build(BuildContext context) {
    // Calculate the current average PR
    double currentAveragePr = exercises.isNotEmpty
        ? exercises.map((e) => e['pr']).reduce((a, b) => a + b) / exercises.length
        : 0;

    // Determine the progress message and its style
    String progressMessage;
    TextStyle messageStyle;

    if (currentAveragePr > previousAveragePr) {
      progressMessage = 'Aaat kani kani aguthalev ga!';
      messageStyle = const TextStyle(
          color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18);
    } else if (currentAveragePr < previousAveragePr) {
      progressMessage = 'Siggu ledha?? dabake kaa utake fekhh!';
      messageStyle = const TextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18);
    } else {
      progressMessage = 'inka enni rojul kani kani iga !';
      messageStyle = const TextStyle(
          color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Progress'),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: exercises.isEmpty
            ? const Center(child: Text('No exercises to display'))
            : Column(
                children: [
               const   Text(
                    'Progress Over Time',
                    style:  TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    progressMessage,
                    style: messageStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: exercises.length + 1, // Add one for overall indicator
                      itemBuilder: (context, index) {
                        if (index < exercises.length) {
                          final exercise = exercises[index];
                          double previousPr = exercise['previousPr'] ?? 0;
                          double currentPr = exercise['pr'];

                          // Determine individual progress message and style
                          String individualProgressMessage;
                          if (currentPr > previousPr) {
                            individualProgressMessage = 'Dawth?!';
                          } else if (currentPr < previousPr) {
                            individualProgressMessage = 'kastam itla ithey!';
                          } else {
                            individualProgressMessage = 'Change led em led';
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exercise['name'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text('Previous PR: $previousPr'),
                                  Text('Current PR: $currentPr'),
                                  Text('Progress: $individualProgressMessage'),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                             const   Text(
                                  'Overall Progress Indicator',
                                  style:  TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                SfLinearGauge(
                                  minimum: 0,
                                  maximum: 100,
                                  ranges:const [
                                    LinearGaugeRange(
                                      startValue: 0,
                                      endValue: 33,
                                      color: Colors.red,
                                    ),
                                    LinearGaugeRange(
                                      startValue: 33,
                                      endValue: 66,
                                      color: Colors.orange,
                                    ),
                                    LinearGaugeRange(
                                      startValue: 66,
                                      endValue: 100,
                                      color: Colors.green,
                                    ),
                                  ],
                                  markerPointers: [
                                    LinearShapePointer(
                                      value: currentAveragePr,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Current Average PR: ${currentAveragePr.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Previous Average PR: ${previousAveragePr.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
