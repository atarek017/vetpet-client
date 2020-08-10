import 'package:flutter/material.dart';

class StepDetails extends StatelessWidget {

  final int index;
  final BuildContext parentContext;


  StepDetails(this.index, this.parentContext);

  @override
  Widget build(BuildContext context) {

    Widget content = Container();

    switch (index) {
      case 1:
        content = Container(
          height: 50,
          width: MediaQuery.of(parentContext).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Text('description not available'),
              SizedBox(height: 10),
             // TODO add content
            ],
          ),
        );
        break;
      case 2:
        content = Container(
          height: 50,
          width: MediaQuery.of(parentContext).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Text('description not available'),
            SizedBox(height: 10),
            // TODO add content
          ],
        ),
        );
        break;
      case 3:
        content = Container(
          height: 50,
          width: MediaQuery.of(parentContext).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Text('description not available'),
              SizedBox(height: 10),
              // TODO add content
            ],
          ),
        );
        break;
      case 4:
        // TODO add step 3
        content = Container(
          height: 50,
          width: MediaQuery.of(parentContext).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Text('description not available'),
              SizedBox(height: 10),
              // TODO add content
            ],
          ),
        );
        break;
      case 5:
      // TODO add step 4 details
        content = Container(
          height: 50,
          width: MediaQuery.of(parentContext).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Text('description not available'),
              SizedBox(height: 10),
              // TODO add content
            ],
          ),
        );
        break;
    }
    return content;
  }
}
