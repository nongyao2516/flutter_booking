import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'booking_page.dart';

//////////////////////////////////////////////////////////////
// API URL
//////////////////////////////////////////////////////////////

const String baseUrl = "http://localhost/flutter_booking/php_api/";

//////////////////////////////////////////////////////////////
// ROOM LIST PAGE
//////////////////////////////////////////////////////////////

class RoomList extends StatefulWidget {
  const RoomList({super.key});

  @override
  State<RoomList> createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {

  List rooms = [];
  List filteredRooms = [];

  TextEditingController searchController = TextEditingController();

  ////////////////////////////////////////////////////////////
  // INIT
  ////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  ////////////////////////////////////////////////////////////
  // FETCH ROOMS
  ////////////////////////////////////////////////////////////

  Future<void> fetchRooms() async {

    final response = await http.get(
      Uri.parse("${baseUrl}get_rooms.php"),
    );

    if (response.statusCode == 200) {

      setState(() {

        rooms = json.decode(response.body);
        filteredRooms = rooms;

      });

    }

  }

  ////////////////////////////////////////////////////////////
  // SEARCH ROOM
  ////////////////////////////////////////////////////////////

  void searchRoom(String keyword) {

    final results = rooms.where((room) {

      final name = room['room_name'].toString().toLowerCase();

      return name.contains(keyword.toLowerCase());

    }).toList();

    setState(() {
      filteredRooms = results;
    });

  }

  ////////////////////////////////////////////////////////////
  // UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Meeting Room Booking"),
      ),

      body: Column(

        children: [

          //////////////////////////////////////////////////////
          // SEARCH BOX
          //////////////////////////////////////////////////////

          Padding(

            padding: const EdgeInsets.all(10),

            child: TextField(

              controller: searchController,

              decoration: const InputDecoration(
                hintText: "ค้นหาห้องประชุม...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),

              onChanged: searchRoom,

            ),

          ),

          //////////////////////////////////////////////////////
          // ROOM LIST
          //////////////////////////////////////////////////////

          Expanded(

            child: filteredRooms.isEmpty
                ? const Center(child: Text("ไม่พบข้อมูลห้อง"))
                : ListView.builder(

                    itemCount: filteredRooms.length,

                    itemBuilder: (context, index) {

                      final room = filteredRooms[index];

                      String imageUrl =
                          "${baseUrl}images/${room['image'] ?? ''}";

                      return Card(

                        margin: const EdgeInsets.all(10),

                        child: ListTile(

                          //////////////////////////////////////////////////
                          // ROOM IMAGE
                          //////////////////////////////////////////////////

                          leading: Image.network(
                            imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.meeting_room),
                          ),

                          //////////////////////////////////////////////////
                          // ROOM NAME
                          //////////////////////////////////////////////////

                          title: Text(room['room_name'] ?? ""),

                          //////////////////////////////////////////////////
                          // ROOM DETAIL
                          //////////////////////////////////////////////////

                          subtitle: Text(
                            "Capacity: ${room['capacity']} คน\nLocation: ${room['location']}",
                          ),

                          //////////////////////////////////////////////////
                          // BOOK BUTTON
                          //////////////////////////////////////////////////

                          trailing: ElevatedButton(

                            child: const Text("จอง"),

                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingPage(room: room),
                                ),
                              );

                            },

                          ),

                        ),

                      );

                    },

                  ),

          )

        ],

      ),

    );

  }
} 