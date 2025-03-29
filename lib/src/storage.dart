import 'dart:async';
import 'dart:convert';

import 'package:dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/dashboard_item_model.dart';

class ColoredDashboardItem extends DashboardItem {
  ColoredDashboardItem({
    required this.itemData,
    required super.width,
    required super.height,
    required super.identifier,
    super.startX,
    super.startY,
  });

  final DashboardItemData itemData;

  factory ColoredDashboardItem.fromJson(Map<String, dynamic> json) {
    return ColoredDashboardItem(
      itemData: DashboardItemData.fromJson(json['item_data']),
      width: json['layout']['width'],
      height: json['layout']['height'],
      identifier: json['item_id'],
      startX: json['layout']['start_x'],
      startY: json['layout']['start_y'],
    );
  }

  Map<String, dynamic> toJson() => {
        'item_id': identifier,
        'item_data': itemData.toJson(),
        'layout': {
          'width': width,
          'height': height,
          'start_x': startX,
          'start_y': startY,
        },
      };

  ColoredDashboardItem copyWith({
    DashboardItemData? itemData,
    int? width,
    int? height,
    String? identifier,
    int? startX,
    int? startY,
  }) =>
      ColoredDashboardItem(
        itemData: itemData ?? this.itemData,
        width: width ?? this.width,
        height: height ?? this.height,
        identifier: identifier ?? this.identifier,
        startX: startX ?? this.startX,
        startY: startY ?? this.startY,
      );

  int get width => layoutData.width;
  int get height => layoutData.height;
  int? get startX => layoutData.startX;
  int? get startY => layoutData.startY;
}

class MyItemStorage extends DashboardItemStorageDelegate<ColoredDashboardItem> {
  SharedPreferences? _preferences;
  static const String _storageKey = 'dashboard_items';
  List<ColoredDashboardItem> _items = [];

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _items = await _loadItems();
  }

  Future<List<ColoredDashboardItem>> _loadItems() async {
    final String? jsonString = _preferences?.getString(_storageKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => ColoredDashboardItem.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  FutureOr<List<ColoredDashboardItem>> getAllItems(int slotCount) async {
    if (_preferences == null) await init();
    return List<ColoredDashboardItem>.from(_items);
  }

  @override
  FutureOr<void> onItemsUpdated(items, int slotCount) async {
    _items = items;
    final jsonList = _items.map((item) => item.toJson()).toList();
    await _preferences?.setString(_storageKey, json.encode(jsonList));
  }

  @override
  FutureOr<void> onItemsAdded(items, int slotCount) async {
    _items = [..._items, ...items];
    return onItemsUpdated(_items, slotCount);
  }

  @override
  FutureOr<void> onItemsDeleted(items, int slotCount) async {
    _items.removeWhere((item) =>
        items.any((deleted) => deleted.identifier == item.identifier));
    return onItemsUpdated(_items, slotCount);
  }

  Future<void> clear() async {
    await _preferences?.remove(_storageKey);
    _items.clear();
  }

  @override
  bool get layoutsBySlotCount => false;
  @override
  bool get cacheItems => true;
}
