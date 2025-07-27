// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:sizer/sizer.dart';
import 'package:smart_trip_planner/Features/Models/TripsHiveModel/TripsHiveModel.dart';
import 'package:smart_trip_planner/Features/Presentation/Screens/Itenanary.dart';
import 'package:smart_trip_planner/Features/Presentation/Screens/Profile.dart';
import 'package:smart_trip_planner/Features/Presentation/Screens/Saved.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _visionController = TextEditingController(
    text: "",
  );

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
        
          backgroundColor: Colors.white,
          elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Row(
          children: [
            Text(
              'Hey Shubham 👋',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 2.h,
                child: Text(
                  'S',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              ),
          ),)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h),
              Text(
                "What's your vision\nfor this trip?",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                width: 100.w,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(3.w),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    TextField(
                      
                      controller: _visionController,
                      
                      maxLines: 4,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        
                        border: InputBorder.none,
                        hintText: "Describe your ideal trip...",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Align(
                      alignment: Alignment.centerRight,
                      // child: Icon(
                      //   Icons.keyboard_arrow_down,
                      //   color: Colors.green,
                      //   size: 6.w,
                      // ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              SizedBox(
                width: 100.w,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: () {
                    if(_visionController.text.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please describe your ideal trip")));
                    }
                    else{
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ItineraryResultScreen(prompt: _visionController.text)),
                     
                    );
                     _visionController.clear();
                    }
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Create My Itinerary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Offline Saved Itineraries',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 2.h),
ValueListenableBuilder(
  valueListenable: Hive.box<TripsHiveModel>('itineraries').listenable(),
  builder: (context, Box<TripsHiveModel> box, _) {
    if (box.isEmpty) {
      return Text(
        "No saved itineraries yet.",
        style: TextStyle(fontSize: 14.sp),
      );
    }

    return Column(
      children: List.generate(box.length, (index) {
        final trip = box.getAt(index);
        return _buildItineraryItem(
          trip?.prompt ?? "Untitled",
          Colors.green,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Saved(trip: trip!),
              ),
            );
          },
        );
      }),
    );
  },
),

SizedBox(height: 5.h),

            ],
          ),
        ),
      ),
    );
    });
  }

  Widget _buildItineraryItem(String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.w),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 2.w,
              height: 2.w,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _visionController.dispose();
    super.dispose();
  }
}