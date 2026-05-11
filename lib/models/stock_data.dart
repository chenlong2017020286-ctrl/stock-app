class StockIndex {
  final String name;
  final double price;
  final double change;
  final double changePercent;

  StockIndex({required this.name, required this.price, required this.change, required this.changePercent});

  bool get isUp => changePercent >= 0;

  static List<StockIndex> samples() => [
        StockIndex(name: '上证指数', price: 3285.67, change: 26.35, changePercent: 0.81),
        StockIndex(name: '深证成指', price: 10452.18, change: 128.45, changePercent: 1.24),
        StockIndex(name: '创业板指', price: 2156.89, change: 38.72, changePercent: 1.83),
        StockIndex(name: '科创50', price: 968.42, change: -5.23, changePercent: -0.54),
      ];
}

class SectorData {
  final String name;
  final double changePercent;
  final double amount;

  SectorData({required this.name, required this.changePercent, required this.amount});

  bool get isUp => changePercent >= 0;

  static List<SectorData> samples() => [
        SectorData(name: '新能源', changePercent: 2.35, amount: 385.6),
        SectorData(name: '半导体', changePercent: 1.89, amount: 298.3),
        SectorData(name: '人工智能', changePercent: 3.12, amount: 456.7),
        SectorData(name: '消费电子', changePercent: -0.45, amount: 156.2),
        SectorData(name: '医药生物', changePercent: -1.23, amount: 201.8),
        SectorData(name: '食品饮料', changePercent: 0.67, amount: 178.4),
      ];
}

class FundItem {
  final String id;
  final String code;
  final String name;
  final double nav; // net asset value
  final double dayChangePercent;
  final double weeklyChangePercent;
  final double monthlyChangePercent;
  final double yearlyChangePercent;
  final String type; // 股票型/混合型/债券型/指数型/货币型
  final double rating; // 1-5

  FundItem({
    required this.id,
    required this.code,
    required this.name,
    required this.nav,
    required this.dayChangePercent,
    required this.weeklyChangePercent,
    required this.monthlyChangePercent,
    required this.yearlyChangePercent,
    required this.type,
    required this.rating,
  });

  bool get isUp => dayChangePercent >= 0;

  static List<FundItem> samples() => [
        FundItem(id: '1', code: '110011', name: '易方达中小盘混合', nav: 4.8567, dayChangePercent: 1.25, weeklyChangePercent: 2.1, monthlyChangePercent: 5.3, yearlyChangePercent: 12.8, type: '混合型', rating: 4.5),
        FundItem(id: '2', code: '005827', name: '中欧时代先锋股票', nav: 1.2345, dayChangePercent: -0.56, weeklyChangePercent: 1.2, monthlyChangePercent: 3.8, yearlyChangePercent: 8.5, type: '股票型', rating: 4),
        FundItem(id: '3', code: '000001', name: '华夏成长混合', nav: 1.8765, dayChangePercent: 0.89, weeklyChangePercent: 0.5, monthlyChangePercent: 2.1, yearlyChangePercent: 6.2, type: '混合型', rating: 3.5),
        FundItem(id: '4', code: '161725', name: '招商中证白酒指数', nav: 0.9876, dayChangePercent: -1.34, weeklyChangePercent: -2.5, monthlyChangePercent: -1.2, yearlyChangePercent: 15.6, type: '指数型', rating: 4),
        FundItem(id: '5', code: '007844', name: '天弘沪深300ETF联接', nav: 1.3456, dayChangePercent: 0.45, weeklyChangePercent: 1.8, monthlyChangePercent: 4.2, yearlyChangePercent: 10.3, type: '指数型', rating: 4.5),
      ];

  String get changeStr => isUp ? '+$dayChangePercent%' : '${dayChangePercent}%';
}

class HoldingItem {
  final String fundId;
  final String fundName;
  final double shares;
  final double costNav;
  final double currentNav;
  final double dayChangePercent;

  HoldingItem({required this.fundId, required this.fundName, required this.shares, required this.costNav, required this.currentNav, required this.dayChangePercent});

  double get costValue => shares * costNav;
  double get currentValue => shares * currentNav;
  double get profit => currentValue - costValue;
  double get profitPercent => costValue > 0 ? (profit / costValue * 100) : 0;
  bool get isProfit => profit >= 0;

  static List<HoldingItem> samples() => [
        HoldingItem(fundId: '1', fundName: '易方达中小盘混合', shares: 5000, costNav: 4.5, currentNav: 4.8567, dayChangePercent: 1.25),
        HoldingItem(fundId: '2', fundName: '中欧时代先锋股票', shares: 3000, costNav: 1.3, currentNav: 1.2345, dayChangePercent: -0.56),
        HoldingItem(fundId: '4', fundName: '招商中证白酒指数', shares: 8000, costNav: 0.95, currentNav: 0.9876, dayChangePercent: -1.34),
      ];
}
