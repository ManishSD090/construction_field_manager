import 'package:flutter/material.dart';
import 'dpr_form_screen.dart';
import 'history_screen.dart';
import 'login_screen.dart';
import '../widgets/project_card.dart';

class ProjectListScreen extends StatelessWidget {
  const ProjectListScreen({super.key});

  final List<Map<String, String>> projects = const [
    {"name": "Bandra Sky Gardens", "status": "In Progress", "date": "2023-01-15", "location": "Bandra West"},
    {"name": "Coastal Road Phase 2", "status": "In Progress", "date": "2023-03-10", "location": "Worli Seaface"},
    {"name": "Tech Hub Airoli", "status": "Completed", "date": "2022-11-20", "location": "Navi Mumbai"},
    {"name": "Metro Line 3 Depot", "status": "Delayed", "date": "2023-06-01", "location": "Aarey Colony"},
    {"name": "Dadar Redevelopment", "status": "In Progress", "date": "2023-08-15", "location": "Dadar East"},
    {"name": "Oberoi Springs Ext", "status": "In Progress", "date": "2023-09-05", "location": "Andheri West"},
    {"name": "Thane Creek Bridge", "status": "Completed", "date": "2022-12-10", "location": "Vashi"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Projects"),
        actions: [
          //History Button
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
          
          //Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false, 
                        );
                      },
                      child: const Text("Logout", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          
          return ProjectCard(
            name: project['name']!,
            status: project['status']!,
            date: project['date']!,
            location: project['location']!,
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => DPRFormScreen(initialProjectName: project['name']!))
              );
            },
          );
        },
      ),
    );
  }
}