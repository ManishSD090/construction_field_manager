import 'package:construction_app/models/dpr_item.dart';

class DPRStorage {
  static List<DPRItem> submittedReports = [];

  static void addReport(DPRItem item) {
    submittedReports.insert(0, item);
  }
}