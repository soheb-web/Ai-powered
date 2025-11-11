import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatScreen.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});
  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final List<Map<String, String>> messages = [
    {
      "name": "Aisha Khan",
      "lastMessage": "Hi, how are you?",
      "imageUrl":
          "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?_gl=1*1ur01ia*_ga*MjEyNTk4MDgxLjE3NTE1NzEzNDg.*_ga_8JE65Q40S6*czE3NTE1NzEzNDckbzEkZzEkdDE3NTE1NzEzNjMkajQ0JGwwJGgw",
    },
    {
      "name": "Rajeev Sharma",
      "lastMessage": "Let's catch up tomorrow.",
      "imageUrl":
          "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?_gl=1*1ur01ia*_ga*MjEyNTk4MDgxLjE3NTE1NzEzNDg.*_ga_8JE65Q40S6*czE3NTE1NzEzNDckbzEkZzEkdDE3NTE1NzEzNjMkajQ0JGwwJGgw",
    },
    {
      "name": "Emily",
      "lastMessage": "Thank you!",
      "imageUrl":
          "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?_gl=1*1ur01ia*_ga*MjEyNTk4MDgxLjE3NTE1NzEzNDg.*_ga_8JE65Q40S6*czE3NTE1NzEzNDckbzEkZzEkdDE3NTE1NzEzNjMkajQ0JGwwJGgw",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF6F8),

      appBar: AppBar(
        backgroundColor: Color(0xFFFDF6F8),
        centerTitle: true,
        title: Text(
          "Messages",
          style: GoogleFonts.gothicA1(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF030016),
          ),
          // style: TextStyle( fontSize: 15,),
        ),
        leading: Icon(Icons.add, color: Colors.white),
      ),

      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];

          return Container(
            margin: EdgeInsets.all(10),
            // padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 50, // Yahan apni desired radius set karein
                    child: ClipOval(
                      child: Image.network(
                        msg['imageUrl']!,
                        fit: BoxFit.cover,
                        width: 50, // radius * 2 for consistent clipping
                        height: 50,
                      ),
                    ),
                  ),

                  title: Text(msg['name']!),
                  subtitle: Text(msg['lastMessage']!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
                  },

                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top time
                      Text(
                        "10:30", // Format your time here as needed
                        style: GoogleFonts.gothicA1(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF030016),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ), // Space between time and notification icon
                      // Bottom notification icon
                      // if (hasNotification)
                      Icon(
                        Icons.notifications,
                        size: 20,
                        color: const Color(0xFF97144d),
                      ),
                      // );
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
