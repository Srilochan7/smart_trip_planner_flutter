// screens/profile_screen.dart
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:smart_trip_planner/Presentations/Screens/home.dart';


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            SizedBox(height: 5.h),
            Container(
              width: 100.w,
              padding: EdgeInsets.all(5.w),
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
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 4.h,
                        child: Text(
                          'S',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shubham S.',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'shubham.s@gmail.com',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  _buildTokenItem(
                    'Request Tokens',
                    '100/1000',
                    Colors.green,
                    0.1,
                  ),
                  SizedBox(height: 2.h),
                  _buildTokenItem(
                    'Response Tokens',
                    '75/1000',
                    Colors.red,
                    0.075,
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Cost',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '\$0.07 USD',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(
              width: 100.w,
              child: TextButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.red, size: 5.w),
                    SizedBox(width: 2.w),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.red,
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
    );
    });
  }

  Widget _buildTokenItem(String title, String value, Color color, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 1.h,
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          title: Text(
            'Log Out',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Logged out successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}