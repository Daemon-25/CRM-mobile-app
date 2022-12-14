import 'package:crm/admin/drawer.dart';
import 'package:crm/dialogs/filter_employee_dialog.dart';
import 'package:crm/dialogs/update_employee.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  TextEditingController searchController = TextEditingController();
  var apiClient = RemoteServices();
  bool dataLoaded = false;
  final snackBar1 = SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );
  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> filtered = [];
  List<Map<String, dynamic>> search = [];
  List<String> cat = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try {
      setState(() {
        dataLoaded = false;
      });
      dynamic res = await apiClient.getAllEmployees();
      employees.clear();
      search.clear();
      filtered.clear();

      for (var i = 0; i < res["res"].length; i++) {
        var e = res["res"][i];

        Map<String, dynamic> mp = {};
        mp["id"] = e["Employee_ID"];
        mp["department"] = e["Department"] ?? "";
        mp["salutation"] = e["Salutation"];
        mp["lastName"] = e["Last_Name"] ?? "";
        mp["firstName"] = e["First_Name"] ?? "";
        mp["emailWork"] = e["Email_Work"] ?? "";
        mp["emailPersonal"] = e["Email_Personal"] ?? "";
        mp["directManagerId"] = e["Direct_Manager_ID"] ?? "";
        mp["directManager"] = e["Manager_Name"] ?? "";
        mp["username"] = e["Username"] ?? "";
        mp["jobTitleId"] = e["Job_Title_ID"] ?? "";
        mp["jobTitle"] = e["Title"] ?? "";
        mp["joiningDate"] = e["Joining_Date"] == null
            ? ""
            : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(e["Joining_Date"]).toLocal())
                .toString();
        mp["business"] = e["Business_Phone"] ?? "";
        mp["mobile"] = e["Mobile_Phone"] ?? "";
        mp["address"] = e["Address"] ?? "";
        mp["city"] = e["City"] ?? "";
        mp["state"] = e["State"] ?? "";
        mp["zip"] = e["ZIP"] ?? "";
        mp["country"] = e["Country"] ?? "";
        mp["expertise"] = e["Expertise"] ?? "";
        mp["resume"] = e["Resume"] ?? "";
        mp["softwarePrivileges"] = e["Software_Privileges"] ?? "";
        mp["webpage"] = e["Web_Page"] ?? "";
        mp["notes"] = e["Notes"] ?? "";
        mp["attachments"] = e["Attachments"] ?? "";
        mp["proficiency"] = e["Proficiency"] ?? "";
        mp["interests"] = e["Interests"] ?? "";
        mp["cocurricular"] = e["Cocurricular"] ?? "";
        mp["trainings"] = e["Trainings"] ?? "";
        mp["birthday"] = e["Birthday"] == null
            ? ""
            : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(e["Birthday"]).toLocal())
                .toString();
        mp["anniversary"] = e["Anniversary"] == null
            ? ""
            : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(e["Anniversary"]).toLocal())
                .toString();
        mp["sports"] = e["Sports"] ?? "";
        mp["activities"] = e["Activities"] ?? "";
        mp["beverage"] = e["Beverage"] ?? "";
        mp["alcohol"] = e["Alcohol"] ?? "";
        mp["travel"] = e["Travel_Destination"] ?? "";
        mp["spouse"] = e["Spouse_Name"] ?? "";
        mp["children"] = e["Children"] ?? "";
        mp["tvShow"] = e["TV_Show"] ?? "";
        mp["movies"] = e["Movies"] ?? "";
        mp["actor"] = e["Actor"] ?? "";
        mp["dislikes"] = e["Dislikes"] ?? "";
        mp["strength"] = e["Strengths"] ?? "";
        mp["weakness"] = e["Weakness"] ?? "";
        mp["socialActiveIndex"] = e["Social_Active_Index"] ?? "";
        employees.add(mp);
      }

      search.addAll(employees);
      filtered.addAll(employees);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally {
      setState(() {
        dataLoaded = true;
      });

      await Future.delayed(Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _onSearchChanged(String text) async {
    setState(() {
      dataLoaded = false;
    });
    search.clear();

    if (text.isEmpty) {
      search.addAll(filtered);
    } else {
      filtered.forEach((e) {
        if ((e["firstName"] + " " + e["lastName"])
            .toString()
            .toLowerCase()
            .startsWith(text.toLowerCase())) {
          search.add(e);
        }
      });
    }

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Employees"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        drawer: const NavDrawerWidget(
          name: '/employees',
        ),
        body: dashboard());
  }

  Widget dashboard() {
    return Container(
        color: const Color.fromRGBO(0, 0, 0, 1),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width - 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [searchBar(), filterButton()],
                    )),
                Visibility(
                    replacement: const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(134, 97, 255, 1),
                      ),
                    ),
                    visible: dataLoaded,
                    child: search.isEmpty
                        ? const Center(
                            child: Text(
                              "No Employees Found",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: search.length,
                              prototypeItem: ListCard(search.first),
                              itemBuilder: (context, index) {
                                return ListCard(search[index]);
                              },
                            ),
                          ))
              ],
            )));
  }

  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: 300,
      child: TextField(
          cursorColor: Colors.white,
          controller: searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: "Search",
            hintStyle:
                const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)),
          )),
    );
  }

  Widget filterButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ElevatedButton(
        onPressed: () {
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
                  FilterEmployeeDialog(cat: cat)).then((value) {
            filtered.clear();
            cat = value as List<String>;
            if (cat.isEmpty) {
              filtered.addAll(employees);
            } else {
              employees.forEach((e) {
                if (cat.contains(e["department"])) {
                  filtered.add(e);
                }
              });
            }

            _onSearchChanged(searchController.text);
          });
        },
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.filter_alt),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromRGBO(134, 97, 255, 1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ))),
      ),
    );
  }

  Widget ListCard(Map<String, dynamic> mp) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        height: 226,
        width: MediaQuery.of(context).size.width - 20,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(41, 41, 41, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Employee ID : ",
                      style: TextStyle(
                          color: Color.fromRGBO(134, 97, 255, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      mp["id"].toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => showGeneralDialog(
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
                          updateEmployeeDialog(
                            mp: mp,
                          )).then((value) {
                    if (value! == true) {
                      _getData();
                    }
                  }),
                  child: Icon(
                    Icons.edit,
                    color: Color.fromRGBO(134, 97, 255, 1),
                  ),
                )
              ]),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Name : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    child: Text(
                      "${mp["salutation"] == "None" ? "" : "${mp["salutation"]} "}${mp["firstName"]}${mp["lastName"] == "" ? "" : " ${mp["lastName"]}"}",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                    fit: FlexFit.loose,
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Department : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["department"],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Direct Manager : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["directManager"],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Email : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    child: Text(
                      mp["emailWork"],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                    fit: FlexFit.loose,
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Job Title : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    child: Text(
                      mp["jobTitle"],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                    fit: FlexFit.loose,
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Phone : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["business"],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "City : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["city"],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
