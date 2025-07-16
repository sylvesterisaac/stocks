import 'package:flutter/material.dart';

class ItemsWidget extends StatelessWidget {
  final List<Map<String, dynamic>>? data;

  const ItemsWidget({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: (150 / 195),
      children: List.generate(
        6, // Change this to the number of items you want to display
        (index) => Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF212325),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
