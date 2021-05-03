import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gpa_analyzer/bloc/data_bloc.dart';
import 'package:circular_custom_loader/circular_custom_loader.dart';
import 'package:gpa_analyzer/data/data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DataBloc dataBloc;
  Data dataObject;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  // String getRank(ranks, index) {
  //   int prevNo = 1;
  //   for (int i = 0; i <= ranks.length; i++) {
  //     int no = i + 1;
  //     if (i > 0 && ranks[i].data()['gpa'] == ranks[i - 1].data()['gpa']) {
  //       no = prevNo;
  //     } else
  //       prevNo = no;
  //     if (ranks[i].id == index) return no.toString();
  //   }
  // }

  @override
  void initState() {
    dataBloc = DataBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    super.initState();
  }

  @override
  void dispose() {
    dataBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dataObject = dataBloc.dataResult;

    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await dataBloc.refresh();
        },
        child: StreamBuilder<Data>(
            stream: dataBloc.data,
            initialData: dataObject,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: Text(
                  'Please Wait',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ));
              }

              if (snapshot.connectionState == ConnectionState.done) {}

              return Container(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                      30, MediaQuery.of(context).size.height * 0.03, 30, 0),
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              snapshot.data.username == null
                                  ? 'Welcome ${snapshot.data.index}!'
                                  : 'Welcome ${snapshot.data.username}!',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text('You have obtained,',
                                style: TextStyle(fontSize: 17))),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.08,
                        ),
                        CircularLoader(
                          coveredPercent: snapshot.data.gpa * 25,
                          width: MediaQuery.of(context).size.width * .6,
                          height: MediaQuery.of(context).size.width * .6,
                          circleWidth: 12.0,
                          circleColor: Colors.grey[300],
                          coveredCircleColor: Color.fromRGBO(254, 101, 65, 1),
                          circleHeader: 'GPA',
                          unit: '/4.00',
                          coveredPercentStyle: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(
                                  fontSize: 41.0,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                  color: Colors.black87),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.07,
                        ),
                        Column(
                          children: [
                            Text(
                              snapshot.data.classType,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01),
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Divider(
                            thickness: 1,
                            color: Color.fromRGBO(255, 91, 53, 1),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RowItem(title: 'Rank', value: snapshot.data.rank),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                child: VerticalDivider(
                                  color: Color.fromRGBO(255, 91, 53, 1),
                                  thickness: 1,
                                )),
                            RowItem(
                                title: 'Credits',
                                value: snapshot.data.totalCredits.toString()),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ],
                    )
                  ],
                ),
              );
            })
    );
  }
}

class RowItem extends StatelessWidget {
  RowItem({@required this.title, this.value});
  String title;
  String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 17),
          )
        ],
      ),
    );
  }
}
