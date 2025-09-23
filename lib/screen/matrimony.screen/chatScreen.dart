import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {'text': "Hello!", 'isMe': false},
    {'text': "Hi, how are you?", 'isMe': true},
    {'text': "I'm fine. You?", 'isMe': false},
  ];

  final TextEditingController _controller = TextEditingController();
  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({'text': _controller.text.trim(), 'isMe': true});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat", style: TextStyle(color:Colors.white,fontSize: 16.sp)),
        backgroundColor:   Color(0xFF97144d),
        leading: const BackButton(color: Colors.white,),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment:
                  msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                    margin: EdgeInsets.symmetric(vertical: 5.h),
                    constraints: BoxConstraints(maxWidth: 250.w),
                    decoration: BoxDecoration(
                      color: msg['isMe']
                          ? Colors.pink.shade100
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.r),
                        topRight: Radius.circular(12.r),
                        bottomLeft: Radius.circular(msg['isMe'] ? 12.r : 0),
                        bottomRight: Radius.circular(msg['isMe'] ? 0 : 12.r),
                      ),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child:TextField(
                    controller: _controller,
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
                      hintText: "Type a message",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.r),
                        borderSide: const BorderSide(
                          color: Color(0xFF97144d), // Orange border
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.r),
                        borderSide: const BorderSide(
                          color: Color(0xFF97144d), // Orange border when focused
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                ),
                SizedBox(width: 8.w),
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor:   Color(0xFF97144d),
                  child: IconButton(
                    icon: Icon(Icons.send, size: 20.sp, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
