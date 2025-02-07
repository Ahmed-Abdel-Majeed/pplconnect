import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverProfilePic;

  const ChatPage({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverProfilePic,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? chatId;
  int unreadMessages = 0;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _clearUnreadMessages();
  }

  void _initializeChat() async {
    String currentUserId = _auth.currentUser!.uid;
    chatId = getChatId(currentUserId, widget.receiverId);

    DocumentSnapshot chatDoc = await _firestore.collection('chats').doc(chatId).get();

    if (!chatDoc.exists) {
      await _firestore.collection('chats').doc(chatId).set({
        'unreadMessages': 0,
        'participants': [currentUserId, widget.receiverId],
        'lastMessage': '',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    _getUnreadMessages();
    _markMessagesAsRead();
  }

  String getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  void _clearUnreadMessages() async {
    await _firestore.collection('Userss').doc(_auth.currentUser!.uid).update({
      'unreadMessages': 0,
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    String message = _messageController.text.trim();
    String senderId = _auth.currentUser!.uid;
    String receiverId = widget.receiverId;

    _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'readStatus': false,
    });

    _firestore.collection('chats').doc(chatId).update({
      'unreadMessages': FieldValue.increment(1),
    });

    _messageController.clear();
  }

  Widget _buildMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DocumentSnapshot> messages = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> messageData =
                messages[index].data() as Map<String, dynamic>;
            bool isMe = messageData['senderId'] == _auth.currentUser!.uid;

            return _buildMessageBubble(
              messageData['message'],
              isMe,
            );
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _getUnreadMessages() async {
    DocumentSnapshot chatDoc = await _firestore.collection('chats').doc(chatId).get();
    setState(() {
      unreadMessages = chatDoc['unreadMessages'] ?? 0;
    });
  }

  void _markMessagesAsRead() async {
    var messagesRef = _firestore.collection('chats').doc(chatId).collection('messages');
    var messages = await messagesRef.where('receiverId', isEqualTo: _auth.currentUser!.uid).where('readStatus', isEqualTo: false).get();
    for (var message in messages.docs) {
      await message.reference.update({'readStatus': true});
    }

    await _firestore.collection('chats').doc(chatId).update({
      'unreadMessages': 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.receiverProfilePic),
            ),
            const SizedBox(width: 10),
            Text(widget.receiverName),
            if (unreadMessages > 0) ...[
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  '$unreadMessages',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
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