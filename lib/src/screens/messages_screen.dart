import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/conversation.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _api = ApiService();
  List<Conversation> list = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    list = await _api.getConversations();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final c = list[i];
                return ListTile(
                  leading: CircleAvatar(child: Text(c.title.isNotEmpty ? c.title[0] : "?")),
                  title: Text(c.title),
                  subtitle: Text(c.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: c.unread > 0 ? CircleAvatar(radius: 10, child: Text("${c.unread}", style: const TextStyle(fontSize: 12))) : null,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(convId: c.id, title: c.title))),
                );
              },
            ),
    );
  }
}
