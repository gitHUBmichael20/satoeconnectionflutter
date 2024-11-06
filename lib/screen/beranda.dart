import 'package:flutter/material.dart';
import 'package:satoe_connection/screen/kontak.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const Beranda(),
    );
  }
}

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  List<Map<String, String>> chatItems = [
  {'name': 'Michael Scott', 'message': 'Hey, are you coming to the party?', 'time': '1m ago'},
  {'name': 'Pam Beesly', 'message': 'Don\'t forget to bring the snacks!', 'time': '5m ago', 'belumdibaca': 'true'},
  {'name': 'Jim Halpert', 'message': 'Did you finish the project?', 'time': '10m ago'},
  {'name': 'Dwight Schrute', 'message': 'I need to discuss beet farming with you.', 'time': '15m ago', 'belumdibaca': 'true'},
  {'name': 'Angela Martin', 'message': 'Reminder: The meeting is at 3 PM.', 'time': '20m ago'},
  {'name': 'Kevin Malone', 'message': 'I spilled chili on my shirt again.', 'time': '25m ago', 'belumdibaca': 'true'},
  {'name': 'Stanley Hudson', 'message': 'I\'m taking a break. Don\'t bother me.', 'time': '30m ago'},
  {'name': 'Ryan Howard', 'message': 'I have a new business idea to share.', 'time': '35m ago', 'belumdibaca': 'true'},
  {'name': 'Kelly Kapoor', 'message': 'Did you see the latest episode of the show?', 'time': '40m ago'},
  {'name': 'Toby Flenderson', 'message': 'Can we talk about the HR issues?', 'time': '45m ago', 'belumdibaca': 'true'},
  {'name': 'Phyllis Vance', 'message': 'Let\'s have lunch together tomorrow.', 'time': '50m ago'},
  {'name': 'Creed Bratton', 'message': 'I found a new band to listen to!', 'time': '55m ago', 'belumdibaca': 'true'},
  {'name': 'Meredith Palmer', 'message': 'Let\'s go out for drinks after work.', 'time': '1h ago'},
  {'name': 'Oscar Martinez', 'message': 'We need to review the budget.', 'time': '1h 5m ago', 'belumdibaca': 'true'},
  {'name': 'Angela Martin', 'message': 'I need more cat supplies.', 'time': '1h 10m ago'},
  {'name': 'Michael Scott', 'message': 'I need everyone to come to my meeting.', 'time': '1h 15m ago', 'belumdibaca': 'true'},
  {'name': 'Pam Beesly', 'message': 'Thanks for the reminder!', 'time': '1h 20m ago'},
  {'name': 'Jim Halpert', 'message': 'I\'ll bring the cupcakes.', 'time': '1h 25m ago', 'belumdibaca': 'true'},
  {'name': 'Dwight Schrute', 'message': 'Beets are the best.', 'time': '1h 30m ago'},
  {'name': 'Stanley Hudson', 'message': 'I have a dentist appointment tomorrow.', 'time': '1h 35m ago', 'belumdibaca': 'true'},
  {'name': 'Ryan Howard', 'message': 'Let\'s brainstorm ideas for the new project.', 'time': '1h 40m ago'},
];

  List<Map<String, String>> filteredChatItems = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredChatItems = chatItems; // Show all items initially
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredChatItems = chatItems; // Reset to original list
      } else {
        filteredChatItems = chatItems.where((item) {
          return item['name']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        filteredChatItems = chatItems; // Reset to original list when not searching
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.green[800]),
                    onPressed: _toggleSearch,
                  ),
                ],
              ),
            ),
            // Search Bar
            if (isSearching)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchController,
                  onChanged: _onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            // Chat List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredChatItems.length,
                itemBuilder: (context, index) {
                  final item = filteredChatItems[index];
                  return _buildChatItem(
                    item['name']!,
                    item['message']!,
                    item['time']!,
                    belumdibaca: item.containsKey('belumdibaca') && item['belumdibaca'] == 'true',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Kontak page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KontakPonsel()),
          );
        },
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.contact_page),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildChatItem(String name, String message, String time, {bool belumdibaca = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: belumdibaca ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: belumdibaca ? Colors.red : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: belumdibaca ? Colors.black : Colors.grey,
                    fontSize: 14,
                    fontWeight: belumdibaca ? FontWeight.w500 : FontWeight.normal,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}