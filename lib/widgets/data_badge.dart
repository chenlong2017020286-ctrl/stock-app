import 'package:flutter/material.dart';

/// 数据来源标记组件
enum DataSource {
  demo,    // 演示数据
  ai,      // AI 实时分析
  pending, // 待接入
}

class DataBadge extends StatelessWidget {
  final DataSource source;
  final String? customText;

  const DataBadge({super.key, this.source = DataSource.demo, this.customText});

  @override
  Widget build(BuildContext context) {
    final config = _config;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: config.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 10, color: config.color),
          const SizedBox(width: 3),
          Text(
            customText ?? config.label,
            style: TextStyle(fontSize: 9, color: config.color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  _BadgeConfig get _config {
    switch (source) {
      case DataSource.demo:
        return _BadgeConfig(Icons.science_outlined, '演示数据', Colors.orange);
      case DataSource.ai:
        return _BadgeConfig(Icons.auto_awesome, 'AI 实时', Colors.deepPurple);
      case DataSource.pending:
        return _BadgeConfig(Icons.construction, '待接入', Colors.grey);
    }
  }
}

class _BadgeConfig {
  final IconData icon;
  final String label;
  final Color color;
  const _BadgeConfig(this.icon, this.label, this.color);
}
