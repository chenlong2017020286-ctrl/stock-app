import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static StorageService? _instance;
  late File _file;
  Map<String, dynamic> _data = {};

  StorageService._();

  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/stock_app_data.json');
    await load();
  }

  Future<void> load() async {
    if (!await _file.exists()) return;
    try {
      _data = json.decode(await _file.readAsString()) as Map<String, dynamic>;
    } catch (_) {
      _data = {};
    }
  }

  Future<void> save() async {
    await _file.writeAsString(json.encode(_data));
  }

  List<String> get watchlistFunds => List<String>.from(_data['watchlistFunds'] ?? []);
  List<String> get watchlistStocks => List<String>.from(_data['watchlistStocks'] ?? []);

  Future<void> addFundWatchlist(String code) async {
    final list = watchlistFunds;
    if (!list.contains(code)) {
      list.add(code);
      _data['watchlistFunds'] = list;
      await save();
    }
  }

  Future<void> removeFundWatchlist(String code) async {
    _data['watchlistFunds'] = watchlistFunds.where((c) => c != code).toList();
    await save();
  }
}
