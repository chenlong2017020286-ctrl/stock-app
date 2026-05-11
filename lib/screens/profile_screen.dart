import 'package:flutter/material.dart';
import '../services/api_config_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, color: AppTheme.primary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('投资者', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text('风险偏好：稳健型', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          _MenuTile(icon: Icons.notifications_outlined, title: '消息推送设置', onTap: () {}),
          _MenuTile(icon: Icons.api, title: 'API 设置', onTap: () => _openApiSettings(context)),
          _MenuTile(icon: Icons.palette_outlined, title: '主题切换', onTap: () {}),
          _MenuTile(icon: Icons.info_outline, title: '关于', onTap: () => _showAbout(context)),
        ],
      ),
    );
  }

  void _openApiSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const _ApiSettingsScreen()));
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: '智能投顾',
      applicationVersion: '1.0.0',
      children: [
        const Text('基于 DeepSeek AI 的智能投资分析工具。\n\n免责声明：所有分析仅供参考，不构成投资建议。'),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primary),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
        onTap: onTap,
      ),
    );
  }
}

class _ApiSettingsScreen extends StatefulWidget {
  const _ApiSettingsScreen();

  @override
  State<_ApiSettingsScreen> createState() => _ApiSettingsScreenState();
}

class _ApiSettingsScreenState extends State<_ApiSettingsScreen> {
  final _config = ApiConfigService.instance;
  late TextEditingController _endpointCtrl;
  late TextEditingController _keyCtrl;
  late TextEditingController _modelCtrl;
  bool _keyVisible = false;

  @override
  void initState() {
    super.initState();
    _endpointCtrl = TextEditingController(text: _config.endpoint);
    _keyCtrl = TextEditingController(text: _config.apiKey);
    _modelCtrl = TextEditingController(text: _config.model);
  }

  @override
  void dispose() {
    _endpointCtrl.dispose();
    _keyCtrl.dispose();
    _modelCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await _config.setEndpoint(_endpointCtrl.text.trim());
    await _config.setApiKey(_keyCtrl.text.trim());
    await _config.setModel(_modelCtrl.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('配置已保存')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API 设置'), actions: [
        TextButton(onPressed: _save, child: const Text('保存', style: TextStyle(fontWeight: FontWeight.w600))),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('API 地址', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(controller: _endpointCtrl, decoration: _input('https://api.deepseek.com')),
          const SizedBox(height: 16),
          const Text('API Key', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(controller: _keyCtrl, obscureText: !_keyVisible,
            decoration: _input('sk-xxx').copyWith(suffixIcon: IconButton(
              icon: Icon(_keyVisible ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _keyVisible = !_keyVisible),
            )),
          ),
          const SizedBox(height: 16),
          const Text('模型名称', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(controller: _modelCtrl, decoration: _input('deepseek-chat')),
          const SizedBox(height: 6),
          const Text('常见模型：deepseek-chat、deepseek-reasoner',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  InputDecoration _input(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true, fillColor: Colors.grey[50],
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}
