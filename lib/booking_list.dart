import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://localhost/flutter_booking/php_api/";

class BookingList extends StatefulWidget {

  final int? roomId;

  const BookingList({super.key, this.roomId});

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {

  List bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  ////////////////////////////////////////////////////////////
  // FETCH BOOKINGS
  ////////////////////////////////////////////////////////////

  Future fetchBookings() async {

    String url;

    if(widget.roomId != null){

      url = "${baseUrl}get_bookings.php?room_id=${widget.roomId}";

    }else{

      url = "${baseUrl}get_bookings.php";

    }

    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){

      setState(() {

        bookings = json.decode(response.body);

      });

    }

  }

  ////////////////////////////////////////////////////////////
  // UI
  ////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.roomId == null
          ? "รายการจองทั้งหมด"
          : "รายการจองห้อง"
        ),
      ),

      body: bookings.isEmpty
      ? const Center(child: Text("ยังไม่มีการจอง"))
      : ListView.builder(

        itemCount: bookings.length,

        itemBuilder: (context,index){

          final b = bookings[index];

          return Card(

            margin: const EdgeInsets.all(10),

            child: ListTile(

              leading: const Icon(Icons.event),

              title: Text(b['user_name'] ?? ""),

              subtitle: Text(
                "${b['booking_date']}\n"
                "${b['start_time']} - ${b['end_time']}"
              ),

            ),

          );

        },

      ),

    );

  }

}