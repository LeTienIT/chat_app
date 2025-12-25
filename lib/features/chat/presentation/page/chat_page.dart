import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/authentication/domain/usecases/get_current_user.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';

class ChatPage extends StatefulWidget{
  String groupId;
  String groupName;

  ChatPage({super.key, required this.groupId, required this.groupName});

  @override
  State<StatefulWidget> createState() {
    return _ChatPage();
  }
}

class _ChatPage extends State<ChatPage>{
  final userId = FirebaseAuth.instance.currentUser!.uid;
  // final user = sl<GetCurrentUser>().call(NoParams());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(ChatStartedEvent(widget.groupId));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }


  void _onScroll() {
    if (_scrollController.offset <= 100 && !context.read<ChatBloc>().state.isLoadingMore && context.read<ChatBloc>().state.hasMore) {
      context.read<ChatBloc>().add(ChatLoadMoreEvent());
    }
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      final message = Message(
        id: '',
        content: _textController.text.trim(),
        senderId: userId,
        groupId: widget.groupId,
        type: MessageType.text,
        createdAt: DateTime.now(),
      );
      context.read<ChatBloc>().add(ChatSendMessageEvent(message));
      _textController.clear();
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state){
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Lỗi: ${state.error}'),
                          ElevatedButton(
                            onPressed: () => context.read<ChatBloc>().add(ChatStartedEvent(widget.groupId)),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      ListView.builder(
                        controller:  _scrollController,
                        reverse: true,
                        itemCount: state.messages.length + (state.isLoading ? 1 : 0),
                        itemBuilder: (context, index){
                          // final reversedIndex = state.messages.length - 1 - index;
                          if (index >= state.messages.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final message = state.messages[index];
                          return MessageBubble(message: message, userId: userId,);
                        },
                      ),
                      if (state.hasMore && state.messages.isNotEmpty)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
                            child: const Text('Scroll lên để load thêm', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                    ],
                  );
                },
              )
          ),

          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(color: Colors.grey[100], border: Border(top: BorderSide(color: Colors.grey[300]!))),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onSubmitted: (_) => _sendMessage(), // Enter để send
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final String userId;  // Để check isMe

  const MessageBubble({super.key, required this.message, required this.userId});

  @override
  Widget build(BuildContext context) {
    final isMe = message.senderId == userId;
    final senderName = message.senderName ?? "NoName";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: !isMe
            ? Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 16,  // Nhỏ gọn
                    backgroundColor: _getAvatarColor(senderName),  // Màu random
                    child: Text(
                      _getInitials(senderName),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: _buildMessageContent(context: context),
                    ),
                  ),
                ],
              )
            : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _buildMessageContent(isMe: true, context: context),
            ),
      ),
    );
  }

  Widget _buildMessageContent({
    required BuildContext context,
    bool isMe = false,
  }) {
    return GestureDetector(
      onLongPress: isMe
          ? () => _showDeleteMessageMenu(context)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTime(message.createdAt),
            style: TextStyle(
              fontSize: 10,
              color: isMe ? Colors.white70 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteMessageMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text(
              'Xóa tin nhắn',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);

              // TODO: gọi Bloc xóa message
              context.read<ChatBloc>().add(
                DeleteMessageEvent(
                  message.groupId,
                  message.id,
                ),
              );
            },
          ),
        );
      },
    );
  }
  String _getInitials(String name) {
    return name.isNotEmpty ? name[0].toUpperCase() : '?';  // Chữ cái đầu
  }

  Color _getAvatarColor(String name) {
    final hash = name.hashCode;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    return colors[hash.abs() % colors.length];
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}