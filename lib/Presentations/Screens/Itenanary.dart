// screens/itinerary_result_screen.dart
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:smart_trip_planner/Presentations/Screens/Profile.dart';


class ItineraryResultScreen extends StatelessWidget {
  final String prompt;
  ItineraryResultScreen({required this.prompt});
   
  @override
  Widget build(BuildContext context) {
    // print('$prompt');
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
       
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 6.w),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 3.h,
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h),
              Row(
                children: [
                  Text(
                    'Itinerary Created ',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text('🏝️', style: TextStyle(fontSize: 24.sp)),
                ],
              ),
              SizedBox(height: 3.h),
              Container(
                width: 100.w,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    // SizedBox(height: 2.h),
                    // _buildItineraryItem(
                    //   'Morning: Arrive in Bali, Denpasar Airport.',
                    // ),
                    // _buildItineraryItem(
                    //   'Transfer: Private driver to Ubud (around 1.5 hours).',
                    // ),
                    // _buildItineraryItem(
                    //   'Accommodation: Check-in at a peaceful boutique hotel or villa in Ubud (e.g., Ubud Aura Retreat).',
                    // ),
                    // _buildItineraryItem(
                    //   "Afternoon: Explore Ubud's local area, walk around the tranquil rice terraces at Tegallalang.",
                    // ),
                    // _buildItineraryItem(
                    //   'Evening: Dinner at Locavore (known for farm-to-table cuisine) in peaceful environment)',
                    // ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red, size: 4.w),
                        SizedBox(width: 1.w),
                        GestureDetector(
                          onTap: () {
                            // Handle map opening
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Opening in maps...'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text(
                            'Open in maps',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14.sp,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(width: 1.w),
                        Icon(Icons.open_in_new, color: Colors.blue, size: 3.w),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Mumbai to Bali, Indonesia - 11hrs 5mins',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: 100.w,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Follow up feature coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, color: Colors.white, size: 5.w),
                      SizedBox(width: 2.w),
                      Text(
                        'Follow up to refine',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: 100.w,
                height: 6.h,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_outline, color: Colors.grey, size: 5.w),
                      SizedBox(width: 2.w),
                      Text(
                        'Save Offline',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5.h),
            ],
          ),
        ),
      ),
    );
    });
  }

  Widget _buildItineraryItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 1.w,
            height: 1.w,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}