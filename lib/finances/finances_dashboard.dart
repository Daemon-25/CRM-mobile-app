import 'package:crm/dialogs/add_people.dart';
import 'package:crm/dialogs/dialog.dart';
import 'package:crm/dialogs/new_order_dialog.dart';
import 'package:crm/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard>
    with TickerProviderStateMixin {
  var headNumArr = [25, 10, 78.3, 50];
  var headStrArr = [
    "Gross Amount",
    "Shipping Fee",
    "Equity Ratio",
    "Total Payable Amount"
  ];
  var orders = [
    [1, 1, 1, 1],
    [2, 2, 2, 2],
    [3, 3, 3, 3],
    [4, 4, 4, 4],
    [4, 4, 4, 4],
    [4, 4, 4, 4],
    [4, 4, 4, 4]
  ];
  List<String> charts = [
    "Top 5 products by Sales",
    "Top 5 Employees by Sales",
    "Top 5 States by Sales",
    "Quarterly Sales"
  ];
  List<List<_ChartData>> data = [
    [
      _ChartData('CHN', 12),
      _ChartData('GER', 15),
      _ChartData('RUS', 30),
      _ChartData('BRZ', 6.4),
      _ChartData('IND', 14)
    ],
    [
      _ChartData('CHN', 12),
      _ChartData('GER', 15),
      _ChartData('RUS', 30),
      _ChartData('BRZ', 6.4),
      _ChartData('IND', 14)
    ],
    [
      _ChartData('CHN', 12),
      _ChartData('GER', 15),
      _ChartData('RUS', 30),
      _ChartData('BRZ', 6.4),
      _ChartData('IND', 14)
    ],
    [
      _ChartData('CHN', 12),
      _ChartData('GER', 15),
      _ChartData('RUS', 30),
      _ChartData('BRZ', 6.4),
      _ChartData('IND', 14)
    ]
  ];
  late TabController tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(context) {
    tabController = TabController(length: 2, vsync: this);

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(child: Text("Sales Dashboard")),
              GestureDetector(
                onTap: () async {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: const Icon(
                  Icons.logout,
                  color: Color.fromRGBO(134, 97, 255, 1),
                  size: 30,
                ),
              ),
            ],
          ),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: Colors.black,
        ),
        body: dashboard());
  }

  Widget dashboard() {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListView(
          children: <Widget>[
            header(),
            myFocus(),
            chart(0),
            chart(1),
            chart(2),
            chart(3),
            tabs()
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            headerCard(0),
            headerCard(1),
            headerCard(2),
            headerCard(3)
          ],
        ),
      ],
    );
  }

  Widget headerCard(int index) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 70,
          width: 87.5,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(41, 41, 41, 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                headNumArr[index].toString() + (index == 2 ? "%" : ""),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                headStrArr[index].toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }

  Widget myFocus() {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 300,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(41, 41, 41, 1),
          ),
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Text(
                      "Product Transactions",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SingleChildScrollView(
                      child: FittedBox(
                        child: DataTable(
                            border: TableBorder(
                                horizontalInside: BorderSide(
                                    color: Color.fromRGBO(
                                        255, 255, 255, 0.43529411764705883))),
                            columnSpacing: 15,
                            columns: const [
                              DataColumn(
                                  label: Text("Purchase ID",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))),
                              DataColumn(
                                  label: Text("Purchase Date",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))),
                              DataColumn(
                                  label: Text("Supplier ID",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))),
                              DataColumn(
                                  label: Text("Created By",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))),
                            ],
                            rows: orders
                                .map((e) => DataRow(cells: [
                              DataCell(Center(
                                  child: Text(
                                    e[0].toString(),
                                    style: TextStyle(
                                        color:
                                        Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                              DataCell(Center(
                                  child: Text(
                                    e[1].toString(),
                                    style: TextStyle(
                                        color:
                                        Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                              DataCell(Center(
                                  child: Text(
                                    e[2].toString(),
                                    style: TextStyle(
                                        color:
                                        Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                              DataCell(Center(
                                  child: Text(
                                    e[3].toString(),
                                    style: TextStyle(
                                        color:
                                        Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                            ]))
                                .toList()),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }

  Widget chart(int index) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 350,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(41, 41, 41, 1),
          ),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(charts[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis:
                          NumericAxis(minimum: 0, maximum: 100, interval: 10),
                      series: <ChartSeries<_ChartData, String>>[
                        ColumnSeries<_ChartData, String>(
                            dataSource: data[index],
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Gold',
                            color: Color.fromRGBO(134, 97, 255, 1))
                      ])
                ],
              ))),
    );
  }

  Widget tabs() {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromRGBO(134, 97, 255, 1)),
          tabs: [
            Tab(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: const Color.fromRGBO(134, 97, 255, 1), width: 1),
              ),
              child: const Text(
                "Requests",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )),
            Tab(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                      color: const Color.fromRGBO(134, 97, 255, 1), width: 1)),
              child: const Text(
                "Forms",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )),
          ],
        ),
        SizedBox(
          width: double.maxFinite,
          height: 210,
          child: TabBarView(
            controller: tabController,
            children: [requests(), forms()],
          ),
        )
      ],
    );
  }

  Widget requests() {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(41, 41, 41, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              requestCard(text: "Request Sales by Employee ID", onClick: () => onRequest(0)),
              requestCard(text: "Request Sales by Month", onClick: () => onRequest(1)),
              requestCard(text: "Request Sales by Product ID", onClick: () => onRequest(2)),
              requestCard(text: "Request Sales by State", onClick: () => onRequest(3)),
              requestCard(text: "Request Sales by Year", onClick: () => onRequest(4)),
            ],
          ),
        ),
      ),
    );
  }

  Widget forms() {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(41, 41, 41, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              formCard(text: "New Project", onClick: () => onForm(0)),
              formCard(text: "New Customer", onClick: () => onForm(1)),
              formCard(text: "Add Order", onClick: () => onForm(2)),
              formCard(text: "Meeting Notes", onClick: () => onForm(3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget formCard({required String text, required VoidCallback onClick}) {
    return GestureDetector(
        onTap: onClick,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(text,
                        style:
                        const TextStyle(color: Colors.white, fontSize: 16)),
                  )
                ],
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
        ));
  }

  Widget requestCard({required String text, required VoidCallback onClick}) {
    return GestureDetector(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(text,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  )
                ],
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
        ));
  }

  void onForm(int index) {
    switch (index) {
      case 0:

        break;
      case 1:
        showGeneralDialog(
            context: context,
            barrierDismissible: false,
            transitionDuration: Duration(milliseconds: 500),
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) => const AddPeopleDialog());
        break;
      case 2:
        showGeneralDialog(
            context: context,
            barrierDismissible: false,
            transitionDuration: Duration(milliseconds: 500),
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) => const NewOrderDialog());
        break;
      case 3:

        break;
    }
  }

  void onRequest(int index) {
    switch (index) {
      case 0:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Employee ID", type: TextInputType.number,));
        break;
      case 1:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Month", type: TextInputType.number,));
        break;
      case 2:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Product ID", type: TextInputType.number,));
        break;
      case 3:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "State", type: TextInputType.text,));
        break;
      case 4:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Year", type: TextInputType.number,));
        break;
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
