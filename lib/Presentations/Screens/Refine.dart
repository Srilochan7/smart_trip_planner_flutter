import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RefineScreen extends StatefulWidget {
  final String prompt;
  
  const RefineScreen({Key? key, required this.prompt}) : super(key: key);
  
  @override
  _RefineScreenState createState() => _RefineScreenState();
}

class _RefineScreenState extends State<RefineScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '7 days in Bali...',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(right: 4.w),
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 2.5.h,
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
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  children: [
                    // User message
                    _buildUserMessage(),
                    SizedBox(height: 2.h),
                    // AI response
                    _buildAIResponse(),
                  ],
                ),
              ),
              _buildInputSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.green,
          radius: 2.h,
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 2.5.h,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.prompt,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Icon(Icons.copy, size: 2.h, color: Colors.grey),
                  SizedBox(width: 1.w),
                  Text(
                    'Copy',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAIResponse() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4.h,
          height: 4.h,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'I',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Itinera AI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 1.h),
              _buildItineraryContent(),
              SizedBox(height: 2.h),
              _buildActionButtons(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItineraryContent() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDayItem('Day 1:', 'Arrival in Bali & Settle in Ubud'),
          _buildSubItem('Morning: Arrive in Bali, Denpasar Airport.'),
          _buildSubItem('Transfer: Private driver to Ubud (around 1.5 hours).'),
          _buildSubItem('Accommodation: Check-in at a boutique resort or guesthouse outside of villa in Ubud (e.g., Ubud Aura Retreat or Kamandalu at Bisma).'),
          _buildSubItem('Afternoon: Explore Ubud\'s local area, walk through the tranquil rice terraces at Tegallalang.'),
          _buildSubItem('Evening: Dinner at Locavore (known for farm-to-table dishes in a peaceful setting).'),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.map_outlined, color: Colors.red, size: 2.h),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Open in maps',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                Icon(Icons.open_in_new, color: Colors.red, size: 2.h),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Mumbai to Bali, Indonesia | 11hrs 5mins',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(String day, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black, fontSize: 13.sp),
          children: [
            TextSpan(
              text: day,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: ' $description'),
          ],
        ),
      ),
    );
  }

  Widget _buildSubItem(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 0.5.w,
            height: 0.5.w,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Icon(Icons.copy, size: 2.h, color: Colors.grey),
        SizedBox(width: 1.w),
        Text(
          'Copy',
          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
        ),
        SizedBox(width: 4.w),
        Icon(Icons.share, size: 2.h, color: Colors.grey),
        SizedBox(width: 1.w),
        Text(
          'Share Offline',
          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
        ),
        SizedBox(width: 4.w),
        Icon(Icons.refresh, size: 2.h, color: Colors.grey),
        SizedBox(width: 1.w),
        Text(
          'Regenerate',
          style: TextStyle(color: Colors.grey, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Follow up to refine',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.mic, color: Colors.grey[600], size: 2.5.h),
                ],
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Container(
            width: 6.h,
            height: 6.h,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.white,
                size: 2.5.h,
              ),
              onPressed: () {
                // Handle send message
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}