import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/stock_data.dart';
import '../services/ai_service.dart';
import '../widgets/stock_tile.dart';
import '../widgets/data_badge.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _holdings = HoldingItem.samples();
  String? _aiBrief;
  bool _loadingBrief = false;

  @override
  void initState() {
    super.initState();
    _loadBrief();
  }

  Future<void> _loadBrief() async {
    setState(() => _loadingBrief = true);
    final resp = await AiService.marketBrief();
    if (mounted) setState(() { _aiBrief = resp.content; _loadingBrief = false; });
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '¥', decimalDigits: 0);
    final totalValue = _holdings.fold(0.0, (s, h) => s + h.currentValue);
    final totalProfit = _holdings.fold(0.0, (s, h) => s + h.profit);

    return Scaffold(
      appBar: AppBar(title: const Text('投资概览')),
      body: RefreshIndicator(
        onRefresh: _loadBrief,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Demo notice banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 12),
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
                      child: Text('以下持仓数据为演示样本。AI 速览和市场分析使用真实数据。',
                          style: TextStyle(fontSize: 12, color: Colors.orange[800])),
                    ),
                    Icon(Icons.touch_app, size: 14, color: Colors.orange[400]),
                  ],
                ),
              ),

              // Asset card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('总资产', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                          const Spacer(),
                          const DataBadge(source: DataSource.demo),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(fmt.format(totalValue),
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(totalProfit >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                              size: 16, color: totalProfit >= 0 ? AppTheme.up : AppTheme.down),
                          const SizedBox(width: 4),
                          Text('${totalProfit >= 0 ? '+' : ''}${fmt.format(totalProfit)}',
                              style: TextStyle(fontSize: 16, color: totalProfit >= 0 ? AppTheme.up : AppTheme.down)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120,
                        child: Row(
                          children: [
                            Expanded(
                              child: PieChart(
                                PieChartData(
                                  sections: _buildPieSections(),
                                  centerSpaceRadius: 28,
                                  sectionsSpace: 2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildPieLegend(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // AI Daily Brief - 真实数据
              Card(
                child: InkWell(
                  onTap: _loadBrief,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, size: 16, color: AppTheme.primary),
                            const SizedBox(width: 6),
                            const Text('AI 市场速览', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            const Spacer(),
                            const DataBadge(source: DataSource.ai),
                            if (_loadingBrief) ...[
                              const SizedBox(width: 8),
                              const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(_aiBrief ?? (_loadingBrief ? '正在获取...' : '点击刷新获取今日市场速览'),
                            style: TextStyle(fontSize: 13, color: _aiBrief != null ? AppTheme.textPrimary : AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text('持有基金', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  const DataBadge(source: DataSource.demo),
                ],
              ),
              const SizedBox(height: 8),
              ..._holdings.map((h) => HoldingCard(holding: h)),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections() {
    final colors = [Colors.blue, Colors.orange, Colors.green];
    return _holdings.asMap().entries.map((e) => PieChartSectionData(
      value: e.value.currentValue,
      color: colors[e.key % colors.length],
      radius: 35,
      title: '',
    )).toList();
  }

  List<Widget> _buildPieLegend() {
    final colors = [Colors.blue, Colors.orange, Colors.green];
    return _holdings.asMap().entries.map((e) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: colors[e.key], shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(e.value.fundName, style: const TextStyle(fontSize: 11)),
        ],
      ),
    )).toList();
  }
}
