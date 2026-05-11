import 'package:flutter/material.dart';
import '../models/stock_data.dart';
import '../models/market_news.dart';
import '../widgets/stock_tile.dart';
import '../widgets/data_badge.dart';
import '../theme/app_theme.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('市场行情')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Demo notice
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.science_outlined, size: 16, color: Colors.orange[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('行情数据为演示样本。使用 AI 投资助手可获取真实市场分析。',
                        style: TextStyle(fontSize: 12, color: Colors.orange[800])),
                  ),
                ],
              ),
            ),

            // Index cards
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Row(
                      children: [
                        const Text('主要指数', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const Spacer(),
                        const DataBadge(source: DataSource.demo),
                      ],
                    ),
                  ),
                  ...StockIndex.samples().map((i) => IndexTile(index: i)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Row(
                      children: [
                        const Text('板块资金流向', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const Spacer(),
                        const DataBadge(source: DataSource.demo),
                      ],
                    ),
                  ),
                  ...SectorData.samples().map((s) => SectorTile(sector: s)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Market News
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('市场资讯', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  const Spacer(),
                  const DataBadge(source: DataSource.demo, customText: '示例'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...MarketNews.samples().map((n) => Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(n.category, style: const TextStyle(fontSize: 10, color: AppTheme.primary)),
                            ),
                            const SizedBox(width: 8),
                            Text(n.source, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                            const Spacer(),
                            Text(n.time, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(n.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(n.summary, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
