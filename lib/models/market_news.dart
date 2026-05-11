class MarketNews {
  final String title;
  final String summary;
  final String source;
  final String time;
  final String category;

  MarketNews({required this.title, required this.summary, required this.source, required this.time, required this.category});

  static List<MarketNews> samples() => [
        MarketNews(title: '央行宣布降准0.5个百分点 释放长期资金约1万亿',
            summary: '中国人民银行决定自2026年6月5日起下调金融机构存款准备金率0.5个百分点，预计释放长期资金约1万亿元。',
            source: '新华社', time: '10分钟前', category: '宏观'),
        MarketNews(title: '新能源板块持续走强 光伏龙头创新高',
            summary: '新能源板块今日继续强势表现，光伏龙头隆基绿能股价创历史新高，带动整个产业链走强。',
            source: '证券时报', time: '30分钟前', category: '板块'),
        MarketNews(title: '北向资金今日净买入超80亿元',
            summary: '北向资金今日大幅净买入A股，沪股通净买入45亿元，深股通净买入35亿元。',
            source: '财联社', time: '1小时前', category: '资金'),
        MarketNews(title: '多家公募基金下调管理费率',
            summary: '包括易方达、华夏基金在内的多家头部公募宣布下调旗下部分基金的管理费率，平均降幅约20%。',
            source: '中国基金报', time: '2小时前', category: '基金'),
        MarketNews(title: 'AI大模型概念股全线上涨 多股涨停',
            summary: '受政策利好推动，AI大模型概念股今日全面爆发，科大讯飞、三六零等多股涨停。',
            source: '每日经济新闻', time: '3小时前', category: '热点'),
      ];
}
