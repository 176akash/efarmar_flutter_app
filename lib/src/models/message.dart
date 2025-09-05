class Message {
  final int id;
  final String sender;
  final String text;
  final int ts;

  Message({required this.id, required this.sender, required this.text, required this.ts});

  factory Message.fromJson(Map<String, dynamic> j) => Message(
    id: j['id'],
    sender: j['sender'],
    text: j['text'],
    ts: j['ts'],
  );
}
