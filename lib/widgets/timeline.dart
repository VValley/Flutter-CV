import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyTimeline extends StatefulWidget {
  @override
  _MyTimelineState createState() => _MyTimelineState();
}

class _MyTimelineState extends State<MyTimeline> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Query timeline =
        FirebaseFirestore.instance.collection("timeline").orderBy('year');

    return StreamBuilder<QuerySnapshot>(
      stream: timeline.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) return new Text("There is no expense");
        List<QueryDocumentSnapshot> data = snapshot.data!.docs;
        return Column(children: getTimeline(data));
      },
    );
  }

  getTimeline(List<QueryDocumentSnapshot> data) {
    List<Widget> timeline = [];

    for (var i = 0; i < data.length; i++) {
      QueryDocumentSnapshot doc = data[i];
      bool isLast = i + 1 == data.length;

      Widget indicator = Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Center(
          child: Text(
            doc.get('year').toString(),
            style: Theme.of(context)
                .textTheme
                .headline5!
                .apply(color: Colors.black),
          ),
        ),
      );

      Widget content = Align(
        alignment: i.isOdd ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(60),
          child: Column(
            children: [
              Text(
                  doc.get(
                    'title',
                  ),
                  style: Theme.of(context).textTheme.headline6),
              Text(doc.get('description').toString(),
                  style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ),
      );

      IndicatorStyle indicatorStyle = IndicatorStyle(
        indicator: indicator,
        height: 50,
        width: 100,
      );

      Widget timelineDivider = TimelineDivider(
        begin: 0.1,
        end: 0.9,
        thickness: 6,
      );
      if (i.isEven) {
        timeline.addAll([
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: i == 0,
            isLast: isLast,
            beforeLineStyle: LineStyle(
              thickness: 6,
            ),
            afterLineStyle: LineStyle(
              thickness: 6,
            ),
            endChild: content,
            indicatorStyle: indicatorStyle,
          ),
          isLast ? Container() : timelineDivider
        ]);
      } else if (i.isOdd) {
        timeline.addAll([
          TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.9,
              isLast: isLast,
              beforeLineStyle: LineStyle(
                thickness: 6,
              ),
              startChild: content,
              afterLineStyle: LineStyle(
                thickness: 6,
              ),
              indicatorStyle: indicatorStyle),
          isLast ? Container() : timelineDivider
        ]);
      }
    }

    return timeline;
  }
}
