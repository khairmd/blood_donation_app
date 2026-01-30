import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_controller.dart'; // or correct path

class SearchView extends StatelessWidget {
  SearchView({super.key});
  final DoctorController controller = Get.put(DoctorController());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: searchController,
            onChanged: controller.filterDoctors,
            decoration: InputDecoration(
              hintText: 'Search doctors...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Obx(() => Expanded(
          child: ListView.builder(
              itemCount: controller.filteredDoctors.length,
              itemBuilder: (context, index) {
                var doctor = controller.filteredDoctors[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(doctor.name),
                  subtitle: Text(doctor.qualification),
                  trailing: Text(doctor.availability),
                );
              }),
        ))
      ],
    );
  }
}
