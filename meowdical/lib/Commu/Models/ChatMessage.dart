class ChatMessage {
  final String email;
  final String message;

  ChatMessage({required this.email, required this.message});

  Map<String, dynamic> toMap() {
    return {'email': email, 'message': message};
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(email: map['email'], message: map['message']);
  }
}
