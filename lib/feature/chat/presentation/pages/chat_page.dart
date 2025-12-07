import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/ws/ws_service.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../providers/chat_provider.dart';

class ChatPage extends StatefulWidget {
  final String chatUuid;
  final String driverUuid;
  final String mechanicUuid;

  const ChatPage({
    super.key,
    required this.chatUuid,
    required this.driverUuid,
    required this.mechanicUuid,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  late VoidCallback _wsListener;
  late WsService ws;

  @override
  void initState() {
    super.initState();

    ws = context.read<WsService>();
    final chatProvider = context.read<ChatProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await chatProvider.loadMessages(widget.chatUuid);
      _scrollToBottom();
    });

    _wsListener = () {
      final incoming = ws.lastChatMessage;
      if (incoming == null) return;

      if (incoming["chatUuid"] != widget.chatUuid &&
          incoming["chat_uuid"] != widget.chatUuid) {
        return;
      }

      try {
        final msg = ChatMessageEntity(
          id: int.tryParse(incoming["id"].toString()),
          chatUuid: incoming["chatUuid"] ?? incoming["chat_uuid"],
          driverUuid: incoming["driverUuid"] ?? incoming["driver_uuid"],
          mechanicUuid: incoming["mechanicUuid"] ?? incoming["mechanic_uuid"],
          senderType: incoming["senderType"] ?? incoming["sender_type"],
          message: incoming["message"],
          createdAt: DateTime.parse(
            incoming["createdAt"] ?? incoming["created_at"],
          ),
        );

        chatProvider.addRealtimeMessage(msg);
        _scrollToBottom();
      } catch (e) {
        debugPrint("❌ Error parseando mensaje WS: $e");
      }
    };

    ws.addListener(_wsListener);
  }

  @override
  void dispose() {
    ws.removeListener(_wsListener);
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          0, // ✅ porque ahora está invertido
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    context.read<ChatProvider>().send(
      chatUuid: widget.chatUuid,
      driverUuid: widget.driverUuid,
      mechanicUuid: widget.mechanicUuid,
      senderType: "driver",
      message: text,
    );

    _msgCtrl.clear();
    _scrollToBottom();
  }

  // ───────────────── UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomHeader(),
            _buildConnectionStatus(),

            Expanded(
              child: Consumer<ChatProvider>(
                builder: (_, chat, __) {
                  if (chat.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final msgs = chat.messages;

                  return ListView.builder(
                    controller: _scrollCtrl,
                    reverse: true, // ✅ ESTE ES EL CAMBIO CLAVE
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    itemCount: msgs.length,
                    itemBuilder: (_, i) {
                      final m =
                          msgs[msgs.length - 1 - i]; // ✅ INVERTIMOS EL ORDEN
                      final isMine = m.senderType == "driver";

                      return Align(
                        alignment: isMine
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 4,
                            bottom: 10,
                            left: isMine ? 60 : 8,
                            right: isMine ? 8 : 60,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isMine
                                ? const Color(0xFF235EE8)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.message,
                                style: TextStyle(
                                  color: isMine ? Colors.white : Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  _formatTime(m.createdAt),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isMine
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  // ───────────────── HEADER PRO
  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF235EE8),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(22)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.build, color: Color(0xFF235EE8)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Chat con el mecánico",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── ESTADO CONEXIÓN
  Widget _buildConnectionStatus() {
    return Consumer<WsService>(
      builder: (_, ws, __) {
        if (!ws.connected) {
          return Container(
            width: double.infinity,
            color: Colors.orange.shade100,
            padding: const EdgeInsets.all(8),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 6),
                Text("Sin conexión en tiempo real"),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // ───────────────── INPUT
  Widget _buildMessageInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Escribe un mensaje...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _sendMessage,
              child: const CircleAvatar(
                radius: 23,
                backgroundColor: Color(0xFF235EE8),
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
