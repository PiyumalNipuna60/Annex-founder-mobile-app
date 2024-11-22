import 'package:annex_finder/src/modules/landing/message/view/call_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessengerScreen extends StatefulWidget {
  final String userId; // ID of the logged-in user
  final String otherUserId; // ID of the user being chatted with
  final String userName;

  const MessengerScreen({
    Key? key,
    required this.userId,
    required this.otherUserId,
    required this.userName,
  }) : super(key: key);

  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List to store messages
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  // Fetch messages from Firestore
  void _fetchMessages() {
    _firestore
        .collection('messages')
        .where('chatId',
            isEqualTo: getChatId(widget.userId, widget.otherUserId))
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _messages = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    });
  }

  // Get chat ID based on the user IDs
  String getChatId(String userId, String otherUserId) {
    return userId.hashCode <= otherUserId.hashCode
        ? "${userId}_$otherUserId"
        : "${otherUserId}_$userId";
  }

  // Send message to Firestore
  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firestore.collection('messages').add({
        'chatId': getChatId(widget.userId, widget.otherUserId),
        'senderId': widget.userId,
        'receiverId': widget.otherUserId,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  // Placeholder function for initiating a call
  void _initiateCall(bool isVideoCall) {
    // Navigate to the CallScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          userId: widget.userId, // Current user's ID
          otherUserId: widget.otherUserId, // Other user's ID
          isVideoCall:
              isVideoCall, // Determine if it's a video call or voice call
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.userName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () => _initiateCall(true), // Initiate video call
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => _initiateCall(false), // Initiate voice call
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSender = message['senderId'] == widget.userId;

                return Align(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: isSender
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['message'],
                          style: TextStyle(
                            color: isSender ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          message['timestamp'] != null
                              ? DateFormat('hh:mm a').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    (message['timestamp'] as Timestamp)
                                        .millisecondsSinceEpoch,
                                  ),
                                )
                              : '',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
