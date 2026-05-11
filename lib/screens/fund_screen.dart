import 'package:flutter/material.dart';
import '../models/stock_data.dart';
import '../widgets/stock_tile.dart';
import '../theme/app_theme.dart';

class FundScreen extends StatefulWidget {
  const FundScreen({super.key});

  @override
  State<FundScreen> createState() => _FundScreenState();
}

class _FundScreenState extends State<FundScreen> {
  final List<FundItem> _funds = FundItem.samples();
  final Set<String> _watchlist = {'1', '3', '5'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('基金分析')),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: _funds.length + 2,
        itemBuilder: (_, i) {
          if (i == 0) return _buildFilterBar();
          if (i == 1) return const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Text('自选基金', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                Spacer(),
                Text('点击查看分析', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              ],
            ),
          );
          final fund = _funds[i - 2];
          final watched = _watchlist.contains(fund.id);
          return Stack(
            children: [
              FundListTile(fund: fund, onTap: () => _showFundDetail(fund)),
              Positioned(right: 8, top: 8, child: IconButton(
                icon: Icon(watched ? Icons.star : Icons.star_border, size: 20,
                    color: watched ? Colors.amber : AppTheme.textSecondary),
                onPressed: () => setState(() {
                  if (watched) { _watchlist.remove(fund.id); } else { _watchlist.add(fund.id); }
                }),
              )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: ['全部', '股票型', '混合型', '指数型', '债券型'].map((name) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(name, style: const TextStyle(fontSize: 12)),
                selected: name == '全部',
                visualDensity: VisualDensity.compact,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showFundDetail(FundItem fund) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _FundDetailSheet(fund: fund),
    );
  }
}

class _FundDetailSheet extends StatelessWidget {
  final FundItem fund;
  const _FundDetailSheet({required this.fund});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(fund.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              Icon(fund.isUp ? Icons.trending_up : Icons.trending_down,
                  color: fund.isUp ? AppTheme.up : AppTheme.down, size: 28),
            ],
          ),
          const SizedBox(height: 4),
          Text('${fund.code}  ·  ${fund.type}', style: const TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metric('单位净值', fund.nav.toStringAsFixed(4)),
              _metric('日涨跌', fund.changeStr),
              _metric('评级', '${fund.rating}⭐'),
            ],
          ),
          const SizedBox(height: 20),
          const Text('阶段收益', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _period('近1周', fund.weeklyChangePercent),
              _period('近1月', fund.monthlyChangePercent),
              _period('近1年', fund.yearlyChangePercent),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('AI 分析该基金'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    );
  }

  Widget _period(String label, double pct) {
    return Column(
      children: [
        Text('${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(2)}%',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                color: pct >= 0 ? AppTheme.up : AppTheme.down)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    );
  }
}
