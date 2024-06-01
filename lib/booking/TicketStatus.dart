// ignore_for_file: prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:goevent2/booking/Ticket/CancelledTicket.dart';
import 'package:goevent2/booking/Ticket/CompletedTicket.dart';
import 'package:goevent2/booking/Ticket/UpcomingTicket.dart';
import 'package:goevent2/utils/color.dart';
import 'package:goevent2/utils/colornotifire.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketStatusPage extends StatefulWidget {
  final String? type;
  const TicketStatusPage({Key? key, this.type}) : super(key: key);

  @override
  State<TicketStatusPage> createState() => _TicketStatusPageState();
}

class _TicketStatusPageState extends State<TicketStatusPage>
    with SingleTickerProviderStateMixin {
  late ColorNotifire notifire;

  @override
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");

    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: notifire.getprimerycolor,
          centerTitle: true,
          leading: widget.type == "0"
              ? InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back, color: notifire.getdarkscolor))
              : Container(),
          title: Text("Tickets",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Gilroy Medium',
                  color: notifire.getdarkscolor)),
          bottom: TabBar(
            unselectedLabelStyle: const TextStyle(
                color: Colors.grey, fontFamily: 'Gilroy_Bold', fontSize: 16),
            labelStyle: const TextStyle(
                fontFamily: 'Gilroy Medium',
                fontSize: 18,
                fontWeight: FontWeight.w700),
            indicatorColor: buttonColor,
            labelColor: buttonColor,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.grey,
            tabs: [
              const Tab(text: "Upcoming"),
              const Tab(text: "Completed"),
              const Tab(text: "Cancelled"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UpcomingTicket(),
            Completedticket(),
            Cancelledticket(),
          ],
        ),
      ),
    );
  }
}
