import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';

import 'package:smart_trip_planner/Blocs/ItineraryBloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/Blocs/RefineBloc/refine_event.dart';
import 'package:smart_trip_planner/HiveModels/TripsHiveModel/TripsHiveModel.dart';
import 'package:smart_trip_planner/Models/ItineraryModel.dart';
import 'package:smart_trip_planner/Presentations/Screens/Profile.dart';
import 'package:smart_trip_planner/Presentations/Screens/Refine.dart';

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

//   void saveItinerary(String prompt, String result) async {
//   final box = Hive.box<TripsHiveModel>('itineraries');

//   final newItem = TripsHiveModel(
//     prompt: prompt,
//     response: result,
//     createdAt: DateTime.now(),
//   );

//   await box.add(newItem);
// }

String formatItinerary(Itinerary itinerary) {
  final buffer = StringBuffer();

  for (int i = 0; i < itinerary.days.length; i++) {
    final day = itinerary.days[i];
    buffer.writeln("Day ${i + 1}: ${day.summary}");
    for (var item in day.items) {
      buffer.writeln("• ${item.time} - ${item.activity} (${item.location})");
    }
    buffer.writeln(""); // extra space between days
  }

  return buffer.toString().trim();
}



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItineraryBloc, ItineraryState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: _buildBody(state),
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
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            ),
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
          ),
        )
      ],
    );
  }

  Widget _buildBody(ItineraryState state) {
    if (state is ItineraryLoading || state is ItineraryInitial) {
      return _buildLoadingBody();
    }

    if (state is ItineraryError) {
      return Center(
        child: Text(
          'Error: ${state.message}',
          style: TextStyle(color: Colors.red, fontSize: 16.sp),
        ),
      );
    }

    if (state is ItineraryLoaded) {
      return _buildSuccessBody(state.itinerary);
    }

    return const Center(child: Text("Something went wrong."));
  }

  Widget _buildLoadingBody() {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Creating Itinerary...',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              CircularProgressIndicator(
                color: Color(0xFF2E7D32),
                strokeWidth: 3,
              ),
              SizedBox(height: 4.h),
              Text(
                'Curating a perfect plan for you...',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        _buildBottomSection(isLoading: true),
      ],
    );
  }

  Widget _buildSuccessBody(Itinerary itinerary) {
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
                  _buildItineraryList(itinerary),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ),
        ),
        _buildBottomSection(isLoading: false),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
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
    );
  }

  Widget _buildItineraryList(Itinerary itinerary) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itinerary.days.length,
      itemBuilder: (context, index) {
        final day = itinerary.days[index];
        return _buildDayCard(day, index);
      },
    );
  }

  Widget _buildDayCard(dynamic day, int index) {
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
          ...day.items.map((item) => _buildActivityItem(item)).toList(),
          SizedBox(height: 2.h),
          _buildMapLink(),
        ],
      ),
    );
  }

  Widget _buildActivityItem(dynamic item) {
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
                fontSize: 16.sp,
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

  Widget _buildBottomSection({required bool isLoading}) {
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
      child: Column(
        children: [
          _buildRefineButton(isLoading),
          SizedBox(height: 1.5.h),
          _buildSaveButton(isLoading),
          SizedBox(height: 3.h),
          _buildBottomIndicator(),
        ],
      ),
    );
  }

  Widget _buildRefineButton(bool isLoading) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RefineScreen(prompt: widget.prompt),
            ),
          );
        },
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
    );
  }

  Widget _buildSaveButton(bool isLoading) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading
    ? null
    : () {
        final itineraryState = context.read<ItineraryBloc>().state;
        if (itineraryState is ItineraryLoaded) {
          final formattedResult = formatItinerary(itineraryState.itinerary);
          
          // saveItinerary(widget.prompt, formattedResult);
          context.read<ItineraryBloc>().add(
  ItinerarySaveOffline(
    widget.prompt,
    formattedResult,
  ),
);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Saved offline successfully')),
          );
          Navigator.pop(context);
        }
      },

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
    );
  }

  Widget _buildBottomIndicator() {
    return Container(
      width: 10.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(0.5.w),
      ),
    );
  }
}
