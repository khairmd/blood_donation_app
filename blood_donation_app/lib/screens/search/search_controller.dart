import 'package:get/get.dart';
import 'dart:math';

class Doctor {
  final String name;
  final String qualification;
  final String availability;

  Doctor(this.name, this.qualification, this.availability);
}

class DoctorController extends GetxController {
  var doctors = <Doctor>[].obs;           // Full doctor list
  var filteredDoctors = <Doctor>[].obs;   // Filtered list based on search

  final searchQuery = ''.obs;

  final List<String> names = ['Dr. Ajmal', 'Dr. Sara', 'Dr. Khan', 'Dr. Ali', 'Dr. Noor'];
  final List<String> qualifications = ['MBBS LUMHS', 'MBBS KEMU', 'MBBS DUHS', 'MBBS FJMU'];
  final List<String> availability = ['Available', 'Busy', 'Offline'];

  @override
  void onInit() {
    generateDoctors();
    super.onInit();
  }

  void generateDoctors() {
    final random = Random();
    doctors.value = List.generate(10, (index) {
      return Doctor(
        names[random.nextInt(names.length)],
        qualifications[random.nextInt(qualifications.length)],
        availability[random.nextInt(availability.length)],
      );
    });
    filteredDoctors.assignAll(doctors);
  }

  void filterDoctors(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredDoctors.assignAll(doctors);
    } else {
      filteredDoctors.assignAll(doctors.where((doc) =>
      doc.name.toLowerCase().contains(query.toLowerCase()) ||
          doc.qualification.toLowerCase().contains(query.toLowerCase()) ||
          doc.availability.toLowerCase().contains(query.toLowerCase())));
    }
  }
}
