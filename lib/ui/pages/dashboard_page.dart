import 'package:dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import '../../src/models/dashboard_item_model.dart';
import '../../src/edit_dialog.dart';
import '../../src/storage.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../ui/pages/timer_page.dart';
import 'dart:math' as math;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DashboardItemController<ColoredDashboardItem> _itemController;
  final ScrollController _scrollController = ScrollController();
  bool _isEditing = false;
  final storage = MyItemStorage();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initStorage();
  }

  Future<void> _initStorage() async {
    await storage.init();
    _itemController =
        DashboardItemController<ColoredDashboardItem>.withDelegate(
      itemStorageDelegate: storage,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        final isDarkMode = themeNotifier.isDarkMode;

        if (_isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          backgroundColor: isDarkMode ? const Color(0xFF1C1C1E) : Colors.white,
          appBar: AppBar(
            backgroundColor:
                isDarkMode ? const Color(0xFF3D3D50) : const Color(0xFF3D3D50),
            title: const Text(
              'Dashboard',
              style: TextStyle(
                fontFamily: 'Inter Tight',
                color: Colors.white,
                fontSize: 24.0,
                letterSpacing: 0.0,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isEditing ? Icons.check : Icons.edit),
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                    _itemController.isEditing = _isEditing;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addNewItem,
              ),
            ],
          ),
          body: Dashboard<ColoredDashboardItem>(
            scrollController: _scrollController,
            shrinkToPlace: true,
            slideToTop: true,
            slotCount: 16,
            padding: const EdgeInsets.all(10),
            horizontalSpace: 0,
            verticalSpace: 0,
            editModeSettings: EditModeSettings(
              resizeCursorSide: 33,
              paintBackgroundLines: true,
              shrinkOnMove: true,
            ),
            dashboardItemController: _itemController,
            itemBuilder: (ColoredDashboardItem item) {
              return _buildDashboardItem(item);
            },
          ),
        );
      },
    );
  }

  Widget _buildDashboardItem(ColoredDashboardItem item) {
    final double width = item.itemData.duration.inMinutes * 10.0;
    final double height = item.itemData.duration.inMinutes * 10.0;

    const double minSize = 10.0;

    Color bodyColor = _getUserDefinedColor(item);
    Color borderColor = _getPriorityColor(item.itemData.priority);
    final double screenWidth = MediaQuery.of(context).size.width;

    const double minTextSize = 12.0;
    const double maxTextSize = 24.0;
    final double adaptiveTextSize = math.max(
      minTextSize,
      math.min(maxTextSize, screenWidth / 20),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () => _showHeroDetails(item),
          onDoubleTap: () => _startTimer(item),
          child: Hero(
            tag: item.identifier,
            child: Container(
              constraints: BoxConstraints(
                minWidth: minSize,
                minHeight: minSize,
                maxWidth: screenWidth - 20,
              ),
              width: width.clamp(minSize, screenWidth),
              height: height,
              decoration: BoxDecoration(
                color: bodyColor,
                border: Border.all(color: borderColor, width: 2),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        item.itemData.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: adaptiveTextSize),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            '${item.itemData.duration.inMinutes} min',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Visibility(
                          visible: constraints.maxWidth >
                              40, // Adjust threshold as needed
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getPriorityColor(item.itemData.priority),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _startTimer(ColoredDashboardItem item) {
    final duration = item.itemData.duration;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TimerScr(initialDuration: duration),
      ),
    );
  }

  Color _getUserDefinedColor(ColoredDashboardItem item) {
    switch (item.itemData.category) {
      case 'Work':
        return const Color.fromARGB(100, 121, 18, 255);
      case 'Personal':
        return const Color.fromARGB(100, 124, 222, 137);
      case 'Urgent':
        return const Color.fromARGB(100, 251, 89, 92);
      case 'Hobby':
        return const Color.fromARGB(100, 245, 255, 132);

      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return const Color(0xFFFB595C);
      case 2:
        return const Color(0xFFF5FF84);
      case 3:
        return const Color(0xFF8FFF6A);
      case 4:
        return const Color(0xFF7FFFFF);
      default:
        return Colors.grey;
    }
  }

  Future<void> _editItemDetails(ColoredDashboardItem item) async {
    final result = await showDialog<DashboardItemData>(
      context: context,
      builder: (context) => EditItemDialog(
        initialData: item.itemData,
      ),
    );

    if (result != null) {
      Navigator.of(context).pop();

      final updatedItem = ColoredDashboardItem(
        itemData: result,
        width: item.width,
        height: item.height,
        identifier: item.identifier,
        startX: item.startX,
        startY: item.startY,
      );

      final allItems = await storage.getAllItems(12);
      final updatedItems = allItems
          .map((i) => i.identifier == item.identifier ? updatedItem : i)
          .toList();
      await storage.onItemsUpdated(updatedItems, 12);

      _itemController.delete(item.identifier);
      _itemController.add(updatedItem);

      setState(() {});
    }
  }

  void _addNewItem() async {
    final result = await showDialog<DashboardItemData>(
      context: context,
      builder: (context) => const EditItemDialog(),
    );

    if (result != null) {
      final newItem = ColoredDashboardItem(
        itemData: result,
        width: 2,
        height: 2,
        identifier: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      _itemController.add(newItem);
    }
  }

  void _deleteItem(ColoredDashboardItem item) async {
    await storage.onItemsDeleted([item], 12);

    _itemController.delete(item.identifier);

    setState(() {});
  }

  void _showHeroDetails(ColoredDashboardItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
              maxHeight: 600,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.itemData.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.timer),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _startTimer(item);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editItemDetails(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _deleteItem(item);
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Category', item.itemData.category),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            'Duration',
                            '${item.itemData.duration.inMinutes} minutes',
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            'Priority',
                            'Level ${item.itemData.priority}',
                          ),
                          if (item.itemData.description.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Description',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(item.itemData.description),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
