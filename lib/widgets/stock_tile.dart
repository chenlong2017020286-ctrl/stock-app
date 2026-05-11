import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/stock_data.dart';
import '../theme/app_theme.dart';

class IndexTile extends StatelessWidget {
  final StockIndex index;
  const IndexTile({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final color = index.isUp ? AppTheme.up : AppTheme.down;
    final fmt = NumberFormat('#,##0.00');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(index.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
          const Spacer(),
          Text(fmt.format(index.price), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(width: 16),
          SizedBox(
            width: 80,
            child: Text('${index.change >= 0 ? '+' : ''}${index.change.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12, color: color)),
          ),
          Container(
            width: 70, padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
            child: Text('${index.changePercent >= 0 ? '+' : ''}${index.changePercent.toStringAsFixed(2)}%',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class SectorTile extends StatelessWidget {
  final SectorData sector;
  const SectorTile({super.key, required this.sector});

  @override
  Widget build(BuildContext context) {
    final color = sector.isUp ? AppTheme.up : AppTheme.down;
    final fmt = NumberFormat.currency(symbol: '', decimalDigits: 1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(sector.name, style: const TextStyle(fontSize: 13))),
          const Spacer(),
          Text('${fmt.format(sector.amount)}亿', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(width: 16),
          Container(
            width: 64, padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
            child: Text('${sector.changePercent >= 0 ? '+' : ''}${sector.changePercent.toStringAsFixed(2)}%',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class FundListTile extends StatelessWidget {
  final FundItem fund;
  final VoidCallback onTap;

  const FundListTile({super.key, required this.fund, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = fund.isUp ? AppTheme.up : AppTheme.down;
    final fmt = NumberFormat('#,##0.0000');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fund.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('${fund.code}  ·  ${fund.type}',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(fmt.format(fund.nav), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                    child: Text(fund.changeStr,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HoldingCard extends StatelessWidget {
  final HoldingItem holding;
  const HoldingCard({super.key, required this.holding});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '¥', decimalDigits: 2);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(holding.fundName, style: const TextStyle(fontWeight: FontWeight.w600))),
                Text(holding.isProfit ? '+${fmt.format(holding.profit)}' : fmt.format(holding.profit),
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
                        color: holding.isProfit ? AppTheme.up : AppTheme.down)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _info('市值', fmt.format(holding.currentValue)),
                const SizedBox(width: 24),
                _info('收益', '${holding.profitPercent.toStringAsFixed(2)}%'),
                const SizedBox(width: 24),
                _info('份额', '${holding.shares.toStringAsFixed(0)}份'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
