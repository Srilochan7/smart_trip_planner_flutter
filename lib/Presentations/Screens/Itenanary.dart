import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:smart_trip_planner/Blocs/ItineraryBloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/Models/ItineraryModel.dart';
import 'package:smart_trip_planner/Presentations/Screens/Profile.dart';

class ItineraryResultScreen extends StatefulWidget {
  final String prompt;

  const ItineraryResultScreen({super.key, required this.prompt});

  @override
  State<ItineraryResultScreen> createState() => _ItineraryResultScreenState();
}

class _ItineraryResultScreenState extends State<ItineraryResultScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ItineraryBloc>().add(FetchItinerary(widget.prompt));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItineraryBloc, ItineraryState>(
      builder: (context, state) {
        if (state is ItineraryLoading || state is ItineraryInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ItineraryError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
              ),
            ),
          );
        }

        if (state is ItineraryLoaded) {
          final itinerary = state.itinerary; // ✅ FIXED: Get itinerary from state

          return _buildSuccessUI(context, itinerary);
        }

        return const Scaffold(body: Center(child: Text("Something went wrong.")));
      },
    );
  }

  Widget _buildSuccessUI(BuildContext context, Itinerary itinerary) {
    return Sizer(
      builder: (context, orientation, deviceType) {
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
              'Home',
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
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            Text('🏝️', style: TextStyle(fontSize: 24.sp)),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: itinerary.days.length,
                          itemBuilder: (context, index) {
                            final day = itinerary.days[index];
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
                                    'Day ${index + 1}: ${day.summary}',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 1.5.h),
                                  ...day.items.map((item) {
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
                                              '${item.time} - ${item.activity} (${item.location})',
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
                                  }).toList(),
                                  SizedBox(height: 2.h),
                                  Row(
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
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    'Mumbai to Bali, Indonesia · 11hrs 5mins',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15.h), // Space for bottom buttons
                      ],
                    ),
                  ),
                ),
              ),
              Container(
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
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2E7D32),
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chat_bubble_outline, color: Colors.white, size: 4.w),
                            SizedBox(width: 2.w),
                            Text(
                              'Follow up to refine',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Container(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bookmark_border, color: Colors.black, size: 4.w),
                            SizedBox(width: 2.w),
                            Text(
                              'Save Offline',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      width: 10.w,
                      height: 0.5.h,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(0.5.w),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}