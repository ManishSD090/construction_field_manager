import 'package:flutter/material.dart';
import '../dpr_storage.dart';
import '../models/dpr_item.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = DPRStorage.submittedReports;

    return Scaffold(
      appBar: AppBar(title: const Text("Submission History")),
      body: reports.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  const Text("No reports submitted yet", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final item = reports[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Icon(Icons.assignment_turned_in, color: Theme.of(context).primaryColor),
                    ),
                    title: Text(item.projectName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${item.date} • ${item.workerCount} Workers"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item.weather, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text("${item.photoCount} Photos", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}