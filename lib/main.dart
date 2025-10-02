import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GradeCalculator(),
    );
  }
}

class GradeCalculator extends StatefulWidget {
  const GradeCalculator({super.key});

  @override
  _GradeCalculatorState createState() => _GradeCalculatorState();
}

class _GradeCalculatorState extends State<GradeCalculator> {
  final Map<String, TextEditingController> subjectControllers = {
    "Математика": TextEditingController(),
    "Русский язык": TextEditingController(),
    "Литература": TextEditingController(),
    "История": TextEditingController(),
    "Физика": TextEditingController(),
  };

  Map<String, double> subjectAverages = {};
  double totalAverage = 0;
  String errorMessage = '';

  void calculateAverages() {
    double totalSum = 0;
    int totalCount = 0;
    Map<String, double> tempAverages = {};
    String tempError = '';

    for (var entry in subjectControllers.entries) {
      String subject = entry.key;
      String input = entry.value.text;

      try {
        List<String> parts = input.split(',');
        List<double> grades = parts.map((e) => double.parse(e.trim())).toList();

        if (grades.isEmpty) {
          tempError = "Введите оценки для всех предметов";
          break;
        }

        double sum = grades.reduce((a, b) => a + b);
        double avg = sum / grades.length;

        tempAverages[subject] = avg;

        totalSum += sum;
        totalCount += grades.length;
      } catch (e) {
        tempError = "Ошибка в данных по предмету: $subject";
        break;
      }
    }

    setState(() {
      if (tempError.isNotEmpty) {
        errorMessage = tempError;
        subjectAverages.clear();
        totalAverage = 0;
      } else {
        subjectAverages = tempAverages;
        totalAverage = totalSum / totalCount;
        errorMessage = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Школьные оценки — средний балл'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Введите оценки по предметам (через запятую)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Поля ввода по предметам
            for (var entry in subjectControllers.entries) ...[
              TextField(
                controller: entry.value,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: entry.key,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 220, 250, 180),
                ),
              ),
              const SizedBox(height: 12),
            ],

            ElevatedButton(
              onPressed: calculateAverages,
              child: const Text("Вычислить средние баллы"),
            ),
            const SizedBox(height: 20),

            // Ошибка
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),

            // Результаты по предметам
            if (subjectAverages.isNotEmpty) ...[
              const Text(
                'Средние баллы по предметам:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              for (var entry in subjectAverages.entries)
                Text(
                  '${entry.key}: ${entry.value.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 20),
              Text(
                'Общий средний балл: ${totalAverage.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
