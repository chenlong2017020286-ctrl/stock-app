import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config_service.dart';

class AiResponse {
  final String content;
  final String? error;
  AiResponse({required this.content, this.error});
  bool get success => error == null;
}

class AiService {
  static final _config = ApiConfigService.instance;

  static String get _systemPrompt => '''你是一个专业的金融投资分析助手，擅长分析股票基金市场和提供投资建议。

## 能力范围
1. 市场行情分析：解读大盘走势、板块轮动、资金流向
2. 基金分析：基金业绩评价、持仓分析、同类对比
3. 投资建议：基于用户风险偏好的资产配置建议
4. 热点解读：实时财经热点的影响分析
5. 风险提示：市场风险、行业风险、持仓集中度风险

## 回答原则
- 数据驱动：基于事实数据进行分析
- 风险提示：任何建议都伴随风险说明
- 客观中立：不推荐具体个股，不承诺收益
- 通俗易懂：用平实的语言解释金融概念
- 免责声明：所有分析仅供参考，不构成投资建议

## 回答格式
使用 Markdown 格式，适当使用小标题、列表、emoji 增强可读性。
''';

  static Future<AiResponse> chat(String message, {String? context}) async {
    if (!_config.isConfigured) {
      return AiResponse(content: '', error: '请先在设置中配置 API');
    }

    try {
      final messages = [
        {'role': 'system', 'content': _systemPrompt},
        {'role': 'user', 'content': '当前日期：${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日\n\n${context != null ? "参考信息：\n$context\n\n" : ""}$message'},
      ];

      final resp = await http
          .post(
            Uri.parse('${_config.endpoint}/chat/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${_config.apiKey}',
            },
            body: json.encode({
              'model': _config.model,
              'messages': messages,
              'temperature': 0.3,
              'max_tokens': 2048,
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (resp.statusCode != 200) {
        final body = json.decode(resp.body);
        return AiResponse(content: '', error: body['error']?['message'] ?? '请求失败 (${resp.statusCode})');
      }

      final body = json.decode(resp.body);
      final content = body['choices']?[0]?['message']?['content'] as String? ?? '';
      return AiResponse(content: content);
    } catch (e) {
      return AiResponse(content: '', error: '请求失败：$e');
    }
  }

  static Future<AiResponse> marketBrief() async {
    return chat('请用简短的几句话概述今日市场整体情况，包括主要指数表现和市场情绪。');
  }

  static Future<AiResponse> analyzeFund(String fundName, String code, String type, double yearlyReturn) async {
    final context = '基金：$fundName($code)\n类型：$type\n近一年收益：${yearlyReturn}%\n当前日期：${DateTime.now().year}年${DateTime.now().month}月';
    return chat('请分析这只基金的综合表现，包括收益水平、风险特征和适合人群。', context: context);
  }

  static Future<AiResponse> portfolioAnalysis(String holdingsJson) async {
    return chat('分析我的基金组合，给出配置合理性评估和优化建议。', context: '当前持仓：\n$holdingsJson');
  }
}
