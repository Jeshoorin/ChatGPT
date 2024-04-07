import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textController = TextEditingController();
  List<String> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ChatGPT'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Type a message...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    String message = _textController.text;
    _textController.clear();
    setState(() {
      _messages.add('You: $message');
    });
    String response = await getChatGPTResponse(message);
    setState(() {
      _messages.add('ChatGPT: $response');
    });
  }

  Future<String> getChatGPTResponse(String message) async {
    String endpoint = 'https://api.openai.com/v1/completions';
    String prompt = 'You: $message\nChatGPT:';

    // Use environment variables or secure configuration file to store the API key
    // String apiKey = YOUR_API_KEY;

    var response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        // Use environment variables or secure configuration file to retrieve the API key
        // 'Authorization': 'Bearer $apiKey',
      },
      body: '{"model": "text-davinci-002", "prompt": "$prompt"}',
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch response from ChatGPT API');
    }
  }
}
