import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final int convId;
  final String title;
  const ChatScreen({super.key, required this.convId, required this.title});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _api = ApiService();
  final _controller = TextEditingController();
  List<Message> msgs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    msgs = await _api.getMessages(widget.convId);
    setState(() => loading = false);
  }

  Future<void> _send() async {
    final txt = _controller.text.trim();
    if (txt.isEmpty) return;
    _controller.clear();
    final newMsg = await _api.sendMessage(widget.convId, txt);
    setState(() => msgs.add(newMsg));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: msgs.length,
                  itemBuilder: (_, i) {
                    final m = msgs[i];
                    final isYou = m.sender == "You";
                    return Align(
                      alignment: isYou ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isYou ? Colors.teal[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(m.text),
                      ),
                    );
                  },
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: "Type a message", border: OutlineInputBorder()))),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _send, child: const Text("Send"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
