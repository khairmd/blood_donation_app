import 'package:flutter/material.dart';

class DonorFinderScreen extends StatefulWidget {
  const DonorFinderScreen({super.key});

  @override
  State<DonorFinderScreen> createState() => _DonorFinderScreenState();
}

class _DonorFinderScreenState extends State<DonorFinderScreen> {
  TextEditingController searchController = TextEditingController();
  bool showActiveOnly = true;

  final List<Map<String, dynamic>> donors = [
    {
      'name': 'John Doe',
      'bloodType': 'A+',
      'location': 'New York',
      'active': true,
    },
    {
      'name': 'Jane Smith',
      'bloodType': 'O-',
      'location': 'Los Angeles',
      'active': false,
    },
    {
      'name': 'Mark Taylor',
      'bloodType': 'B+',
      'location': 'Chicago',
      'active': true,
    },
    // Add more sample donors if needed
  ];

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.toLowerCase();
    final filteredDonors = donors.where((donor) {
      final matchesQuery = donor['name'].toLowerCase().contains(query) ||
          donor['bloodType'].toLowerCase().contains(query) ||
          donor['location'].toLowerCase().contains(query);
      final isActive = !showActiveOnly || donor['active'];
      return matchesQuery && isActive;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Finder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              onChanged: (val) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Search by name, blood type or location',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            SizedBox(height: 10),

            // Toggle Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Show Active Donors Only'),
                Switch(
                  value: showActiveOnly,
                  onChanged: (val) {
                    setState(() {
                      showActiveOnly = val;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 10),

            // Donor List
            Expanded(
              child: filteredDonors.isEmpty
                  ? Center(child: Text('No donors found.'))
                  : ListView.builder(
                itemCount: filteredDonors.length,
                itemBuilder: (context, index) {
                  final donor = filteredDonors[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(donor['bloodType']),
                      ),
                      title: Text(donor['name']),
                      subtitle: Text(donor['location']),
                      trailing: IconButton(
                        icon: Icon(Icons.phone),
                        onPressed: () {
                          // Replace with actual contact logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Calling ${donor['name']}...'),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
