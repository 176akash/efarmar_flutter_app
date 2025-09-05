class Conversation {
  final int id;
  final String title;
  final String lastMessage;
  final int unread;

  Conversation({required this.id, required this.title, required this.lastMessage, required this.unread});

  factory Conversation.fromJson(Map<String, dynamic> j) => Conversation(
    id: j['id'],
    title: j['title'],
    lastMessage: j['lastMessage'] ?? '',
    unread: j['unread'] ?? 0,
  );
}
