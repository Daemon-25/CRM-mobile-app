import 'package:crm/dialogs/calendar_dialog.dart';
import 'package:crm/dialogs/dialog.dart';
import 'package:crm/dialogs/final_dialog.dart';
import 'package:crm/dialogs/timesheet_dialog.dart';
import 'package:crm/dialogs/update_tasks.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EngineersDashboard extends StatefulWidget {
  const EngineersDashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EngineersDashboardState();
}

class _EngineersDashboardState extends State<EngineersDashboard>
    with TickerProviderStateMixin {
  var headNumArr = [25, 10, 50];
  var headStrArr = [
    "Upcoming Projects",
    "Ongoing Projects",
    "Completed Projects",
  ];
  RemoteServices apiClient = RemoteServices();
  bool dataLoaded = false;
  List<Map<String, dynamic>> todo = [];
  late TabController tabController;

  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _getData();
  }

  void _getData() async {
    try {
      setState(() {
        dataLoaded = false;
      });

      dynamic res = await apiClient.getTasksById();
      print(res);
      todo.clear();

      for (var i = 0; i < res["res"].length; i++) {
        var e = res["res"][i];
        Map<String, dynamic> mp = {};

        mp["id"] = e["Task_ID"].toString();
        mp["title"] = e["Title"];
        mp["status"] = e["Status"] ?? "";
        mp["completed"] = e["Percent_Completed"] ?? "0";
        mp["description"] = e["Description"] ?? "";
        mp["startDate"] = e["Start_Date"] == null
            ? ""
            : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(e["Start_Date"]).toLocal())
                .toString();
        mp["dueDate"] = e["Due_Date"] == null
            ? ""
            : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(e["Due_Date"]).toLocal())
                .toString();
        mp["attachments"] = e["Attachments"] ?? "";
        mp["priority"] = e["Priority"].toString();

        todo.add(mp);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally {
      setState(() {
        dataLoaded = true;
      });

      await Future.delayed(Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(child: Text("Engineers Dashboard")),
              GestureDetector(
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        body: Visibility(
          replacement: Container(
            color: const Color.fromRGBO(0, 0, 0, 1),
            child: Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(134, 97, 255, 1),
              ),
            ),
          ),
          visible: dataLoaded,
          child: dashboard(),
        ));
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
            calendarCard(),
            timeSheetCard(),
            budgetsCard(),
            rfpCard(),
            proposalCard(),
            projectsCard(),
            const SizedBox(
              height: 5.0,
            ),
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
          children: <Widget>[headerCard(0), headerCard(1), headerCard(2)],
        ),
      ],
    );
  }

  Widget headerCard(int index) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 70,
          width: 118,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(41, 41, 41, 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                headNumArr[index].toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                headStrArr[index].toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
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
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(41, 41, 41, 1),
        ),
        child: ListView(
          children: <Widget>[
            const Text(
              "My Focus",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            todo.length == 0
                ? Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      "No Work Assigned to You",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(
                              255, 255, 255, 0.43529411764705883),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : DataTable(
                    columnSpacing: 20,
                    border: TableBorder(
                        horizontalInside: BorderSide(
                            color: Color.fromRGBO(
                                255, 255, 255, 0.43529411764705883))),
                    columns: const [
                      DataColumn(
                          label: Text("Title",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      DataColumn(
                          label: Text("Priority",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      DataColumn(
                          label: Text("Completed",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      DataColumn(
                          label: Text("Deadline",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      DataColumn(
                          label: Text("",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                    ],
                    rows: todo
                        .map((e) => DataRow(cells: [
                              DataCell(Center(
                                child: Text(
                                  e["title"].toString(),
                                  style: TextStyle(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.8)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  e["priority"],
                                  style: TextStyle(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.8)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  "${e["completed"].toString()} %",
                                  style: TextStyle(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.8)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  e["dueDate"],
                                  style: TextStyle(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.8)),
                                ),
                              )),
                              DataCell( GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                      UpdateTasksDialog(mp: e)).then((value) {

                                     if(value!=null && value == true){
                                       _getData();
                                     }
                                  });
                                },
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_circle_right,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                            ]))
                        .toList()),
          ],
        ),
      ),
    );
  }

  Widget calendarCard() {
    return Card(
        color: const Color.fromRGBO(0, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            showGeneralDialog(
                context: context,
                barrierDismissible: false,
                transitionDuration: Duration(milliseconds: 500),
                transitionBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const CalendarDialog());
          },
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width - 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(41, 41, 41, 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Calendar",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget timeSheetCard() {
    return Card(
        color: const Color.fromRGBO(0, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            showGeneralDialog(
                context: context,
                barrierDismissible: false,
                transitionDuration: Duration(milliseconds: 500),
                transitionBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const TimeSheetDialog());
          },
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width - 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(41, 41, 41, 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Time Sheet",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget budgetsCard() {
    return Card(
        color: const Color.fromRGBO(0, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/engineerBudgets');
          },
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width - 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(41, 41, 41, 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Budgets",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget rfpCard() {
    return Card(
        color: const Color.fromRGBO(0, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/engineerRfps');
          },
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width - 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(41, 41, 41, 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RFPs",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget proposalCard() {
    return Card(
        color: const Color.fromRGBO(0, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/engineerProposals');
          },
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width - 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(41, 41, 41, 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Proposals",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget projectsCard() {
    return Card(
        color: const Color.fromRGBO(0, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/engineerProjects');
          },
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width - 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(41, 41, 41, 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Projects",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget tabs() {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          unselectedLabelColor: const Color.fromRGBO(41, 41, 41, 0.5),
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
          height: 255,
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
              requestCard(
                  text: "Request All Projects", onClick: () => onRequest(0)),
              requestCard(
                  text: "Request Upcoming Projects",
                  onClick: () => onRequest(1)),
              requestCard(
                  text: "Request Project Details by Month",
                  onClick: () => onRequest(2)),
              requestCard(
                  text: "Request Project Details by Project ID",
                  onClick: () => onRequest(3)),
              requestCard(
                  text: "Request Projects by Employee ID",
                  onClick: () => onRequest(4)),
              requestCard(
                  text: "Request Closed Projects", onClick: () => onRequest(5)),
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
              formCard(text: "Vacation Request", onClick: () => onForm(0)),
              formCard(text: "Training Request", onClick: () => onForm(1)),
              formCard(text: "Sick Leave", onClick: () => onForm(2)),
              formCard(text: "Travel Request", onClick: () => onForm(3)),
              formCard(text: "Advance Form", onClick: () => onForm(4)),
              formCard(text: "Complaint", onClick: () => onForm(5)),
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
    }
  }

  void onRequest(int index) {
    switch (index) {
      case 0:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
      case 1:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
      case 2:
        showDialog(
            context: context,
            builder: (_) =>
                const DialogWidget(hint: "Month", type: TextInputType.number));
        break;
      case 3:
        showDialog(
            context: context,
            builder: (_) => const DialogWidget(
                hint: "Project ID", type: TextInputType.number));
        break;
      case 4:
        showDialog(
            context: context,
            builder: (_) => const DialogWidget(
                hint: "Employee ID", type: TextInputType.number));
        break;
      case 5:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
    }
  }
}
