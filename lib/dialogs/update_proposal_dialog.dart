import 'package:crm/dialogs/add_employee_dialog.dart';
import 'package:crm/dialogs/add_people.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class updateProposalDialog extends StatefulWidget{
  final Map<String, dynamic> mp;
  const updateProposalDialog({Key? key, required this.mp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _updateProposalDialogState(mp: mp);
}

const List<String> Status = <String>["Go", "No Go","Review"];
const List<String> list = <String>[
  'New Project',
  'Modifications',
  'Quote',
  'Negotiation',
  'Closed',
  'Dead'
];


class _updateProposalDialogState extends State<updateProposalDialog>{
  late Map<String, dynamic> mp;
  TextEditingController projectController = TextEditingController();
  TextEditingController questionDeadline = TextEditingController();
  TextEditingController closingDeadline = TextEditingController();
  TextEditingController resultDate = TextEditingController();
  TextEditingController designPrice = TextEditingController();
  TextEditingController provisionalItems = TextEditingController();
  TextEditingController contractAdminPrice = TextEditingController();
  TextEditingController subConsultantPrice = TextEditingController();
  TextEditingController totalBid = TextEditingController();
  TextEditingController bidderPrice = TextEditingController();
  TextEditingController winnerPrice = TextEditingController();
  TextEditingController projectManager = TextEditingController();
  TextEditingController planTakers = TextEditingController();
  TextEditingController bidders = TextEditingController();
  TextEditingController winningBidder = TextEditingController();
  TextEditingController teamMember = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController country = TextEditingController(text: "Canada");
  TextEditingController projectCategory = TextEditingController();
  TextEditingController department = TextEditingController();

  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Project Updated Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool dataLoaded = false;
  var projectStageVal, dept;
  List<String> provinces = Constants.provinces;
  List<String> employees = <String>[];
  List<String> prevCat = [];
  List<String> prevDep= [];
  List<String> prevMember = [],prevPlan = [],prevBid = [];
  List<String> clients = [];
  Map<String, String> empMap = {}, clientMap = {};
  Map<String, int> projectManagerMap = {};
  var stringList,empId,Team;
  var status="",bidStatus="";
  List<Map<String, dynamic>> customers = [];
  List<String> Departments = [];
  List<String> cities = [], departments = [], companies = [];
  Map<String, int> cityMap = {}, departmentMap = {}, companyMap = {},employeeMap={};
  var ProjectManager;

  _updateProposalDialogState({required this.mp}) {
    projectController.text = mp["projectName"];
    department.text = mp["department"];
    closingDeadline.text = mp["closingDeadline"];
    resultDate.text = mp["resultDate"];
    projectManager.text = mp["managerName"];
    questionDeadline.text = mp["questionDeadline"];
    city.text = mp["city"];
    province.text = mp["province"];
    department.text = mp["department"];
    teamMember.text = mp["team"];
    designPrice.text = mp["designPrice"];
    provisionalItems.text = mp["provisionalItems"];
    contractAdminPrice.text = mp["contractAdminPrice"];
    subConsultantPrice.text = mp["subConsultantPrice"];
    totalBid.text = mp["totalBid"];
    planTakers.text =mp["planTakers"];
    bidders.text = mp["bidders"];
    bidderPrice.text = mp["bidderPrice"];
    winnerPrice.text = mp["winningPrice"];
    winningBidder.text = mp["winningBidderName"];
    prevMember = teamMember.text.split(",");
    prevPlan = planTakers.text.split(",");
    prevBid = bidders.text.split(",");
    bidStatus = mp["bidStatus"]=="" ? "No Go" : mp["bidStatus"];
    status = mp["status"]=="" ? "No Go" : mp["status"];

    if(mp["status"]!="") {
      status = mp["status"];
    }
    if(mp["bidStatus"]!=""){
      bidStatus = mp["bidStatus"];
    }

  }

  @override
  void initState() {
    super.initState();

    _getData();
  }

  void _getData() async {
    setState(() {
      dataLoaded = false;
    });
    dynamic res1 = await apiClient.getCities();
    dynamic res2 = await apiClient.getDepartments();
    dynamic res3 = await apiClient.getAllEmployeeNames();
    dynamic res4 = await apiClient.getAllCompanyNames();



    if (res3?["success"] == true&&res1?["success"]==true && res2?["success"]==true&& res4?["success"]) {
      for(var e in res1["res"]){
        cities.add(e["City"]);
        cityMap[e["City"]] = e["City_ID"];
      }

      for(var e in res2["res"]){
        departments.add(e["Department"]);
        departmentMap[e["Department"]] = e["Department_ID"];
      }

      for(var e in res3["res"]){
        employees.add(e["Full_Name"].toString());
        employeeMap[e["Full_Name"]] = e["Employee_ID"];
      }
      for(var e in res4["res"]){
        companies.add(e["Name"]);
        cityMap[e["Name"]] = e["ID"];
      }
      print(employees);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    }
    setState(() {
      dataLoaded = true;
    });

    await Future.delayed(Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void postData() async {
    setState(() {
      dataLoaded = false;
    });

    if (validate() == true) {
      print("validated");
       dynamic res = await apiClient.updateProposal(mp["id"],cityMap[city.text], departmentMap[department.text], projectController.text, questionDeadline.text, closingDeadline.text, resultDate.text,status.toString(),  employeeMap[projectManager.text],  teamMember.text, designPrice.text, provisionalItems.text, contractAdminPrice.text,subConsultantPrice.text, totalBid.text,planTakers.text, bidders.text, bidderPrice, status.toString(), winnerPrice.text, companyMap[winningBidder.text]);

      setState(() {
        dataLoaded = false;
      });

      await Future.delayed(Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }


  bool validate() {
    // if(projectController.text=="" || dueDate.text=="" || projectStageVal.toString() == "" || tentClosing.text == "" || projectValue.text == "" ||stringList == ""|| projectManager.text==""){
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    //   return false;
    // }

    return true;
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () => Navigator.pop(context),
        ),
        title: Text("Update Proposal"),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      body: Visibility(
        replacement: const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(134, 97, 255, 1),
          ),
        ),
        visible: dataLoaded,
        child: form(),
      ),
    );
  }

  Widget form() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ListView(
        children: [
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              city.text = suggestion.toString();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
                tileColor: Colors.black,
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              var curList = [];

              for (var e in cities) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curList.add(e);
                }
              }

              return curList;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: city,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "City*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              if(suggestion != null) {
                if(suggestion == "+ Add Department"){

                }else{
                  department.text = suggestion.toString();
                }
              }
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
                tileColor: Colors.black,
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              // var curList = ["+ Add Department"];
              var curList = [];


              for (var e in departments) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curList.add(e);
                }
              }

              return curList;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: department,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Department*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              projectManager.text = suggestion==null ? "" : suggestion.toString();
            },

            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
                tileColor: Colors.black,
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              var curList = [];

              for (var e in employees) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curList.add(e);
                }
              }

              return curList;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: projectController,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Project Name*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.datetime,
            readOnly: true,
            onTap: () async {
              showDatePicker(
                  context: context,
                  initialDate: questionDeadline.text == ""
                      ? DateTime.now()
                      : DateTime.parse(questionDeadline.text),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          onPrimary: Colors.white,
                          surface: Colors.black,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor:
                        const Color.fromRGBO(41, 41, 41, 1),
                      ),
                      child: child!,
                    );
                  }).then((value) {
                setState(() {
                  questionDeadline.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : questionDeadline.text;
                });
              });
            },
            controller: questionDeadline,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Question Deadline*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.datetime,
            readOnly: true,
            onTap: () async {
              showDatePicker(
                  context: context,
                  initialDate: closingDeadline.text == ""
                      ? DateTime.now()
                      : DateTime.parse(closingDeadline.text),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          onPrimary: Colors.white,
                          surface: Colors.black,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor:
                        const Color.fromRGBO(41, 41, 41, 1),
                      ),
                      child: child!,
                    );
                  }).then((value) {
                setState(() {
                  closingDeadline.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : closingDeadline.text;
                });
              });
            },
            controller: closingDeadline,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Closing Deadline",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.datetime,
            readOnly: true,
            onTap: () async {
              showDatePicker(
                  context: context,
                  initialDate: resultDate.text == ""
                      ? DateTime.now()
                      : DateTime.parse(resultDate.text),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          onPrimary: Colors.white,
                          surface: Colors.black,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor:
                        const Color.fromRGBO(41, 41, 41, 1),
                      ),
                      child: child!,
                    );
                  }).then((value) {
                setState(() {
                  resultDate.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : resultDate.text;
                });
              });
            },
            controller: resultDate,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Result Date",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton<String>(
            value: status,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: const Text(
              "Status*",
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)),
            ),
            icon: null,
            style: const TextStyle(color: Colors.white),
            underline: Container(
              height: 1,
              color: Colors.white,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                status = value!;
              });
            },
            items: Status.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 20,
          ),

          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              projectManager.text = suggestion==null ? "" : suggestion.toString();
            },

            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
                tileColor: Colors.black,
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              var curList = [];

              for (var e in employees) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curList.add(e);
                }
              }

              return curList;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: projectManager,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Project Manager*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),

          DropdownSearch<String>.multiSelection(
            items: employees,
            selectedItems: prevMember,
            dropdownButtonProps: const DropdownButtonProps(
                color: Color.fromRGBO(255, 255, 255, 0.5)
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(

                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    hintText: "Team Members",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
            // dropdownBuilder: (context, distributors) {
            //   return
            // },
            popupProps: const PopupPropsMultiSelection.menu(
                showSelectedItems: true,
                menuProps: MenuProps(
                  backgroundColor: Colors.white,
                )
            ),
            onChanged: (value) {
              List<String> member=[];
              member = value;
              member.sort((a, b) => a.toString().compareTo(b.toString()));
              teamMember.text = member.join(",");
              print(teamMember.text);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: designPrice,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Design Price*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: provisionalItems,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Provisional Items*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: contractAdminPrice,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Contract Admin Price",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: subConsultantPrice,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Sub Consultant Price",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: totalBid,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Total Bid*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownSearch<String>.multiSelection(
            items: companies,
            selectedItems: prevPlan,
            dropdownButtonProps: const DropdownButtonProps(
                color: Color.fromRGBO(255, 255, 255, 0.5)
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(

                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    hintText: "Plan Takers",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
            // dropdownBuilder: (context, distributors) {
            //   return
            // },
            popupProps: const PopupPropsMultiSelection.menu(
                showSelectedItems: true,
                menuProps: MenuProps(
                  backgroundColor: Colors.white,
                )
            ),
            onChanged: (value) {
              List<String> member=[];
              member = value;
              member.sort((a, b) => a.toString().compareTo(b.toString()));
              planTakers.text = member.join(",");
              print(planTakers.text);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownSearch<String>.multiSelection(
            items: companies,
            selectedItems: prevBid,
            dropdownButtonProps: const DropdownButtonProps(
                color: Color.fromRGBO(255, 255, 255, 0.5)
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(

                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    hintText: "Bidders",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
            // dropdownBuilder: (context, distributors) {
            //   return
            // },
            popupProps: const PopupPropsMultiSelection.menu(
                showSelectedItems: true,
                menuProps: MenuProps(
                  backgroundColor: Colors.white,
                )
            ),
            onChanged: (value) {
              List<String> member=[];
              member = value;
              member.sort((a, b) => a.toString().compareTo(b.toString()));
              bidders.text = member.join(",");
              print(bidders.text);
            },
          ),
          const SizedBox(
            height: 20,
          ),

          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: bidderPrice,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Bidder Price*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),

          DropdownButton<String>(
            value: bidStatus,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: const Text(
              "Bid Status*",
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)),
            ),
            icon: null,
            style: const TextStyle(color: Colors.white),
            underline: Container(
              height: 1,
              color: Colors.white,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                bidStatus = value!;
              });
            },
            items: Status.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 20,
          ),

          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: winnerPrice,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Winning Price",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              winningBidder.text = suggestion==null ? "" : suggestion.toString();
            },

            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
                tileColor: Colors.black,
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              var curListed = [];

              for (var e in companies) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curListed.add(e);
                }
              }

              return curListed;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                onChanged: (text){

                },
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: winningBidder,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Winning Bidder",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(onPressed: () {
              postData();
            } ,
              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(134, 97, 255, 1)),
              child: const Text("Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}