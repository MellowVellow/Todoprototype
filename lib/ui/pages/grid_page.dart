import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GridPage extends StatefulWidget {
  const GridPage({super.key});

  @override
  State<GridPage> createState() => _GridPageState();
}

class _GridPageState extends State<GridPage> {
  late List<int> items;
  Timer? _timer;
  final ScrollController gridScrollController = ScrollController();
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      gridScrollController
          .jumpTo(gridScrollController.position.maxScrollExtent);
    });

    super.initState();
    // Initialize with 20 items
    items = List.generate(1000, (index) => index);

    // Start timer to remove items
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (items.isNotEmpty) {
          items.removeLast();
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disappearing Grid'),
      ),
      body: GridView.builder(
        controller: gridScrollController,
        //! TODO: UP OR DOWN VIEW
        // reverse:true,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 60,
          mainAxisSpacing: 1,
          crossAxisSpacing: 1,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
            ),
            // child: Center(
            //   child: Text(
            //     items[index].toString(),
            //     style: const TextStyle(
            //       fontSize: 12,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          );
        },
      ),
    );
  }
}
