import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_trip_planner/HiveModels/TripsHiveModel/TripsHiveModel.dart';

class Saved extends StatelessWidget {
  final TripsHiveModel trip;

  const Saved({super.key, required this.trip});


  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: _buildBody(),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: BackButton(color: Colors.black),
      title: Text(
        'Saved',
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
        )
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3.h),
                  _buildHeader(),
                  SizedBox(height: 3.h),
                  _buildItineraryCard(),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ),
        _buildBottomSection(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Your saved trips ',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        Text('🏝️', style: TextStyle(fontSize: 24.sp)),
      ],
    );
  }

  Widget _buildItineraryCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
  trip.prompt,
  style: TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  ),
),
SizedBox(height: 1.5.h),
Text(
  trip.response,
  style: TextStyle(
    fontSize: 16.sp,
    color: Colors.black,
    height: 1.5,
  ),
),

        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              height: 1.4,
            ),
          ),
          Expanded(
            child: Text(
              activity,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapLink() {
    return Row(
      children: [
        Icon(Icons.map_outlined, color: Colors.blue, size: 4.w),
        SizedBox(width: 1.w),
        Text(
          'Open in maps',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14.sp,
            decoration: TextDecoration.underline,
          ),
        ),
        SizedBox(width: 1.w),
        Icon(Icons.open_in_new, color: Colors.blue, size: 3.w),
      ],
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      
    );
  }

}