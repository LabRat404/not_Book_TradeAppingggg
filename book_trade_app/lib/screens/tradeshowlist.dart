import 'package:flutter/material.dart';
import 'package:trade_app/screens/data.dart';
import 'package:trade_app/screens/chatter.dart';
import 'package:trade_app/screens/tradeSelectList.dart';

class TradeShowList extends StatefulWidget {
  @override
  _TradeShowListState createState() => _TradeShowListState();
}

class _TradeShowListState extends State<TradeShowList> {
  bool isSelectionMode = false;
  List<Map> staticData = MyData.data;
  Map<int, bool> selectedFlag = {};
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Current trade list'),
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.pop(context, "something");
              },
            ),
            bottom: const TabBar(
              tabs: [
                //load user icons
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.create_outlined, size: 25),
                color: Color.fromARGB(255, 255, 255, 255),
                tooltip: 'Upload Book Menu',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TradeList()),
                  );
                },
              ),
            ],
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit)
            ],
          ),
        ),
      ),
    );
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      // Open Detail Page
    }
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }

  // Widget _buildSelectIcon(bool isSelected, Map data) {
  //   if (isSelectionMode) {
  //     return Icon(
  //       isSelected ? Icons.check_box : Icons.check_box_outline_blank,
  //       color: Theme.of(context).primaryColor,
  //     );
  //   } else {
  //     return
  //   }
  // }

  Widget? _buildSelectAllButton() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    if (isSelectionMode) {
      return FloatingActionButton(
        onPressed: _selectAll,
        child: Icon(
          isFalseAvailable ? Icons.done_all : Icons.remove_done,
        ),
      );
    } else {
      return null;
    }
  }

  void _selectAll() {
    bool isFalseAvailable = selectedFlag.containsValue(false);
    // If false will be available then it will select all the checkbox
    // If there will be no false then it will de-select all
    selectedFlag.updateAll((key, value) => isFalseAvailable);
    setState(() {
      isSelectionMode = selectedFlag.containsValue(true);
    });
  }
}
