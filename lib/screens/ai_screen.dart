import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../theme/app_theme.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<ChatMsg> _messages = [];
  bool _loading = false;

  static const _suggestions = [
    '今日市场怎么样？',
    '帮我分析白酒板块走势',
    '基金定投有哪些注意事项',
    '新能源基金还能买吗？',
    '分析我的持仓配置合理性',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMsg(text: text, isUser: true));
      _loading = true;
    });
    _scrollToBottom();

    final resp = await AiService.chat(text);

    setState(() {
      _messages.add(ChatMsg(
        text: resp.content.isNotEmpty ? resp.content : '❌ ${resp.error ?? '未知错误'}',
        isUser: false,
        isError: resp.error != null,
      ));
      _loading = false;
    });
    _scrollToBottom();
    _ctrl.clear();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI 投资助手')),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty ? _buildEmpty() : ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _buildMessage(_messages[i]),
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      decoration: InputDecoration(
                        hintText: '输入你想了解的...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: _send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppTheme.primary,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: () => _send(_ctrl.text),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 40),
        const Icon(Icons.auto_awesome, size: 48, color: AppTheme.primary),
        const SizedBox(height: 16),
        const Text('AI 投资助手', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('随时提问市场行情、基金分析、投资策略',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        const SizedBox(height: 32),
        const Text('试试这些问题：', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ..._suggestions.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ActionChip(
            label: Text(s, style: const TextStyle(fontSize: 13)),
            onPressed: () => _send(s),
          ),
        )),
      ],
    );
  }

  Widget _buildMessage(ChatMsg msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: msg.isUser ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: msg.isUser ? const Radius.circular(4) : null,
            bottomLeft: msg.isUser ? null : const Radius.circular(4),
          ),
          boxShadow: msg.isUser ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
        ),
        child: SelectableText(
          msg.text,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: msg.isUser ? Colors.white : (msg.isError ? AppTheme.down : AppTheme.textPrimary),
          ),
        ),
      ),
    );
  }
}

class ChatMsg {
  final String text;
  final bool isUser;
  final bool isError;
  ChatMsg({required this.text, required this.isUser, this.isError = false});
}
