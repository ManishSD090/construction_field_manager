import 'dart:io';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:construction_app/dpr_storage.dart';
import 'package:construction_app/models/dpr_item.dart';

class DPRFormScreen extends StatefulWidget {
  final String? initialProjectName;
  const DPRFormScreen({super.key, this.initialProjectName});

  @override
  State<DPRFormScreen> createState() => _DPRFormScreenState();
}

class _DPRFormScreenState extends State<DPRFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _workerCountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String? _selectedProject;
  String? _selectedWeather;
  DateTime _selectedDate = DateTime.now();
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  final List<String> _projectOptions = [
    "Bandra Sky Gardens",
    "Coastal Road Phase 2",
    "Tech Hub Airoli",
    "Metro Line 3 Depot",
    "Dadar Redevelopment",
    "Oberoi Springs Ext",
    "Thane Creek Bridge"
  ];

  final List<String> _weatherOptions = ['Sunny', 'Rainy', 'Cloudy', 'Stormy'];

  @override
  void initState() {
    super.initState();
    if (widget.initialProjectName != null && _projectOptions.contains(widget.initialProjectName)) {
      _selectedProject = widget.initialProjectName;
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please upload at least one photo'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      setState(() => _isSubmitting = true);
      await Future.delayed(const Duration(seconds: 2));

      DPRStorage.addReport(DPRItem(
        projectName: _selectedProject!,
        date: DateFormat('MM/dd/yyyy').format(_selectedDate),
        weather: _selectedWeather!,
        workerCount: _workerCountController.text,
        description: _descriptionController.text,
        photoCount: _selectedImages.length,
      ));

      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Success"),
            content: Text("DPR submitted for $_selectedProject"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); 
                  Navigator.pop(context); 
                },
                child: const Text("OK"),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New DPR")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Project Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedProject,
                decoration: const InputDecoration(
                  labelText: "Select Project",
                  prefixIcon: Icon(Icons.business),
                ),
                items: _projectOptions.map((String project) {
                  return DropdownMenuItem(value: project, child: Text(project));
                }).toList(),
                onChanged: (val) => setState(() => _selectedProject = val),
                validator: (val) => val == null ? "Please select a project" : null,
              ),

              const SizedBox(height: 16),

              //Date Picker
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Date",
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(DateFormat('MM/dd/yyyy').format(_selectedDate)),
                ),
              ),

              const SizedBox(height: 16),

              //Weather Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedWeather,
                decoration: const InputDecoration(labelText: "Weather", prefixIcon: Icon(Icons.cloud)),
                items: _weatherOptions.map((String weather) {
                  return DropdownMenuItem(value: weather, child: Text(weather));
                }).toList(),
                onChanged: (val) => setState(() => _selectedWeather = val),
                validator: (val) => val == null ? "Required" : null,
              ),

              const SizedBox(height: 16),

              //Worker Count
              TextFormField(
                controller: _workerCountController,
                decoration: const InputDecoration(labelText: "Worker Count", prefixIcon: Icon(Icons.people)),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? "Enter count" : null,
              ),

              const SizedBox(height: 16),

              //Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Work Description", prefixIcon: Icon(Icons.description), alignLabelWithHint: true),
                maxLines: 4,
                validator: (val) => val!.isEmpty ? "Enter description" : null,
              ),

              const SizedBox(height: 24),

              //Image Upload
              Text("Site Photos (${_selectedImages.length})", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ..._selectedImages.map((img) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: kIsWeb 
                          ? Image.network(img.path, width: 100, height: 100, fit: BoxFit.cover)
                          : Image.file(File(img.path), width: 100, height: 100, fit: BoxFit.cover),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedImages.remove(img)),
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.remove_circle, color: Colors.red, size: 20),
                          ),
                        ),
                      )
                    ],
                  )),
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.add_a_photo, color: Colors.grey), SizedBox(height: 4), Text("Add", style: TextStyle(color: Colors.grey, fontSize: 12))],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  child: _isSubmitting 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                    : const Text("SUBMIT REPORT"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}