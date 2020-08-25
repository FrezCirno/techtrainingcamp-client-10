import 'package:flutter/material.dart';
import 'package:hello_Flutter/constants/constants.dart';

class LocationList extends StatefulWidget {
  final String selectedLocation;
  LocationList({this.selectedLocation});

  @override
  _LocationListState createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  String input;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(silver),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: TextField(
                  onChanged: (value) => this.setState(() {
                        input = value;
                      })),
            ),
            Expanded(
              child: getListView(search: input),
            ),
          ],
        ),
      ),
    );
  }

  ListView getListView({String search}) {
    var filterList = TimeLocation.where((element) =>
        element.toLowerCase().indexOf((search ?? "").toLowerCase().trim()) !=
        -1).toList();
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            filterList[index],
            style: widget.selectedLocation == filterList[index]
                ? kSelectedTextStyle
                : kTopRowTextStyle,
          ),
          onTap: () {
            Navigator.pop(context, filterList[index]);
          },
        );
      },
      itemCount: filterList.length,
    );
  }
}
