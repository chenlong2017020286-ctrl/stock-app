import 'package:flutter/material.dart';
import '../models/stock_data.dart';
import '../models/market_news.dart';
import '../widgets/stock_tile.dart';
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
            // Index cards
            Card(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: StockIndex.samples().map((i) => IndexTile(index: i)).toList(),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('板块资金流向', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: SectorData.samples().map((s) => SectorTile(sector: s)).toList(),
              ),
            ),
            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('市场资讯', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
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
