import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_trip_planner/Features/Presentation/Blocs/ItineraryBloc/itinerary_bloc.dart';
import 'package:smart_trip_planner/Features/Presentation/Blocs/RefineBloc/refine_bloc.dart';
import 'package:smart_trip_planner/Features/Presentation/Blocs/RefineBloc/refine_event.dart';
import 'package:smart_trip_planner/Features/Presentation/Blocs/RefineBloc/refine_state.dart';
import 'package:smart_trip_planner/Features/Domain/Entites/ChatModel.dart';
import 'package:smart_trip_planner/Features/Models/itineraryModel/ItineraryModel.dart';
import 'package:smart_trip_planner/Features/Presentation/Screens/home.dart';

class RefineScreen extends StatelessWidget {
  final String prompt;
  
  const RefineScreen({Key? key, required this.prompt}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RefineBloc(context.read<ItineraryBloc>())
        ..add(InitializeRefine(prompt)),
      child: const RefineView(),
    );
  }
}

class RefineView extends StatefulWidget {
  const RefineView({Key? key}) : super(key: key);

  @override
  State<RefineView> createState() => _RefineViewState();
}

class _RefineViewState extends State<RefineView> {
  final TextEditingController _controller = TextEditingController();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItineraryBloc, ItineraryState>(
      listener: (context, state) {
        if (state is ItineraryLoaded) {
          context.read<RefineBloc>().onItineraryUpdated(state.itinerary);
          _scrollToBottom();
        } else if (state is ItineraryError) {
          context.read<RefineBloc>().onItineraryError(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(child: _buildChatList()),
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Refine Itinerary',
        style: TextStyle(
          color: Colors.black, 
          fontSize: 18.sp, 
          fontWeight: FontWeight.w500
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
                fontWeight: FontWeight.bold
              )
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatList() {
    return BlocBuilder<RefineBloc, RefineState>(
      buildWhen: (previous, current) {
        // Only rebuild when messages change or loading state changes
        if (previous is RefineLoaded && current is RefineLoaded) {
          return previous.messages.length != current.messages.length ||
                 previous.isRefining != current.isRefining;
        }
        return true;
      },
      builder: (context, state) {
        if (state is RefineLoaded) {
          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            itemCount: state.messages.length + (state.isRefining ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.messages.length && state.isRefining) {
                return const LoadingMessage();
              }
              
              final message = state.messages[index];
              // Use const constructors and keys for better performance
              return message.isUser 
                  ? UserMessage(key: ValueKey('user_$index'), message: message)
                  : AIMessage(key: ValueKey('ai_$index'), message: message);
            },
          );
        }
        
        if (state is RefineError) {
          return Center(
            child: Text(
              'Error: ${state.message}', 
              style: TextStyle(color: Colors.red)
            )
          );
        }
        
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildInputSection() {
    return BlocSelector<RefineBloc, RefineState, bool>(
      selector: (state) => state is RefineLoaded && state.isRefining,
      builder: (context, isRefining) {
        return Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1), 
                spreadRadius: 1, 
                blurRadius: 5, 
                offset: const Offset(0, -2)
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(child: _buildTextField(isRefining)),
              SizedBox(width: 3.w),
              _buildSendButton(isRefining),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(bool isRefining) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.grey[100], 
        borderRadius: BorderRadius.circular(25)
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !isRefining,
              decoration: InputDecoration(
                hintText: 'Follow up to refine',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey[600], 
                  fontSize: 16.sp
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          Icon(Icons.mic, color: Colors.grey[600], size: 2.5.h),
        ],
      ),
    );
  }

  Widget _buildSendButton(bool isRefining) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 6.h,
      height: 6.h,
      decoration: BoxDecoration(
        color: isRefining ? Colors.grey : Colors.green, 
        shape: BoxShape.circle
      ),
      child: IconButton(
        icon: isRefining 
            ? SizedBox(
                width: 2.h, 
                height: 2.h, 
                child: const CircularProgressIndicator(
                  strokeWidth: 2, 
                  color: Colors.white
                )
              )
            : Icon(Icons.send, color: Colors.white, size: 2.5.h),
        onPressed: isRefining ? null : _sendMessage,
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    final message = _controller.text.trim();
    context.read<RefineBloc>().add(SendMessage(message));
    _controller.clear();
    
    // Auto-scroll to bottom after sending message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Optimized Widget Components with const constructors and better performance
class UserMessage extends StatelessWidget {
  final ChatMessage message;
  
  const UserMessage({Key? key, required this.message}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UserAvatar(),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18.sp
                  )
                ),
                SizedBox(height: 1.h),
                MessageBubble(
                  message: message.message,
                  isUser: true,
                ),
                SizedBox(height: 1.h),
                const ActionRow(actions: ['Copy']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AIMessage extends StatelessWidget {
  final ChatMessage message;
  
  const AIMessage({Key? key, required this.message}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AIAvatar(),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Itinera AI', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18.sp
                  )
                ),
                SizedBox(height: 1.h),
                if (message.itinerary != null) 
                  ItineraryContent(itinerary: message.itinerary!) 
                else 
                  MessageBubble(message: message.message, isUser: false),
                SizedBox(height: 2.h),
                ActionRow(
                  actions: const ['Copy', 'Save', 'Regenerate'], 
                  itinerary: message.itinerary
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted avatar widgets for better performance
class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.green, 
      radius: 2.h, 
      child: Icon(Icons.person, color: Colors.white, size: 2.5.h)
    );
  }
}

class AIAvatar extends StatelessWidget {
  const AIAvatar({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4.h, 
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.orange, 
        borderRadius: BorderRadius.circular(8)
      ),
      child: Center(
        child: Text(
          'I', 
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: 16.sp
          )
        )
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  
  const MessageBubble({
    Key? key, 
    required this.message, 
    required this.isUser
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isUser ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isUser ? null : Border.all(color: Colors.grey[200]!),
      ),
      child: Text(message, style: TextStyle(fontSize: 16.sp)),
    );
  }
}

class LoadingMessage extends StatelessWidget {
  const LoadingMessage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AIAvatar(),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Itinera AI', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 18.sp
                  )
                ),
                SizedBox(height: 1.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(12), 
                    border: Border.all(color: Colors.grey[200]!)
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 20, 
                        height: 20, 
                        child: CircularProgressIndicator(
                          strokeWidth: 2, 
                          color: Colors.orange
                        )
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Updating your itinerary...', 
                        style: TextStyle(
                          fontSize: 16.sp, 
                          fontStyle: FontStyle.italic
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageContent extends StatelessWidget {
  final String message;
  
  const MessageContent({Key? key, required this.message}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: Colors.grey[200]!)
      ),
      child: Text(message, style: TextStyle(fontSize: 16.sp)),
    );
  }
}

class ItineraryContent extends StatelessWidget {
  final Itinerary itinerary;
  
  const ItineraryContent({Key? key, required this.itinerary}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(12), 
        border: Border.all(color: Colors.grey[200]!)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Updated Itinerary:', 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 18.sp, 
              color: Colors.green[700]
            )
          ),
          SizedBox(height: 2.h),
          ...itinerary.days.asMap().entries.map((entry) => 
            DayContent(
              key: ValueKey('day_${entry.key}'),
              day: entry.value, 
              index: entry.key
            )
          ).toList(),
          SizedBox(height: 2.h),
          const MapLink(),
        ],
      ),
    );
  }
}

class DayContent extends StatelessWidget {
  final dynamic day;
  final int index;
  
  const DayContent({Key? key, required this.day, required this.index}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day ${index + 1}: ${day.summary}', 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16.sp, 
              color: Colors.black87
            )
          ),
          SizedBox(height: 1.h),
          ...day.items.map((item) => 
            SubItem(
              key: ValueKey('${item.time}_${item.activity}'),
              text: '${item.time} - ${item.activity} (${item.location})'
            )
          ).toList(),
        ],
      ),
    );
  }
}

class SubItem extends StatelessWidget {
  final String text;
  
  const SubItem({Key? key, required this.text}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 1.h), 
            width: 0.5.w, 
            height: 0.5.w, 
            decoration: const BoxDecoration(
              color: Colors.black, 
              shape: BoxShape.circle
            )
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14.sp))
          ),
        ],
      ),
    );
  }
}

class MapLink extends StatelessWidget {
  const MapLink({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
      decoration: BoxDecoration(
        color: Colors.red[50], 
        borderRadius: BorderRadius.circular(8), 
        border: Border.all(color: Colors.red[200]!)
      ),
      child: Row(
        children: [
          Icon(Icons.map_outlined, color: Colors.red, size: 2.h),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Open in maps', 
              style: TextStyle(color: Colors.red, fontSize: 14.sp)
            )
          ),
          Icon(Icons.open_in_new, color: Colors.red, size: 2.h),
        ],
      ),
    );
  }
}

class ActionRow extends StatelessWidget {
  final List<String> actions;
  final Itinerary? itinerary;
  
  const ActionRow({Key? key, required this.actions, this.itinerary}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: actions.map((action) => 
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: GestureDetector(
            onTap: () => _handleAction(context, action),
            child: Row(
              children: [
                Icon(_getIcon(action), size: 2.h, color: _getColor(action)),
                SizedBox(width: 1.w),
                Text(
                  action, 
                  style: TextStyle(
                    color: _getColor(action), 
                    fontSize: 14.sp
                  )
                ),
              ],
            ),
          ),
        ),
      ).toList(),
    );
  }
  
  void _handleAction(BuildContext context, String action) {
    switch (action) {
      case 'Save':
        if (itinerary != null) {
          context.read<RefineBloc>().add(SaveItinerary());
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
        }
        break;
      case 'Regenerate':
        // Handle regenerate logic
        break;
      case 'Copy':
        // Handle copy logic
        break;
    }
  }
  
  IconData _getIcon(String action) {
    switch (action) {
      case 'Copy': return Icons.copy;
      case 'Save': return Icons.bookmark;
      case 'Regenerate': return Icons.refresh;
      default: return Icons.help;
    }
  }
  
  Color _getColor(String action) {
    return action == 'Save' && itinerary != null ? Colors.green : Colors.grey;
  }
}