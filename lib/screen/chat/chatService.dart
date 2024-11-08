// chat_services.dart

class ChatMessage {
  final String name;
  final String message;
  final String time;
  final String imageUrl;

  ChatMessage({
    required this.name,
    required this.message,
    required this.time,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'message': message,
      'time': time,
      'imageUrl': imageUrl,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      name: map['name'] ?? '',
      message: map['message'] ?? '',
      time: map['time'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}

class ChatServices {
  Stream<List<Map<String, dynamic>>> getChats() async* {
    final List<ChatMessage> messages = [
      ChatMessage(
        name: 'Michael Carlo',
        message: 'Hello, how are you?',
        time: '10:30 AM',
        imageUrl: '',
      ),
      ChatMessage(
        name: 'Kenzie Yassir',
        message: 'I\'m fine, thanks!',
        time: '09:45 AM',
        imageUrl: '',
      ),
      ChatMessage(
        name: 'Handika',
        message: 'Good, and you?',
        time: '08:15 AM',
        imageUrl: '',
      ),
    ];

    yield messages.map((msg) => msg.toMap()).toList();
  }
}