import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class updateEmployeeDialog extends StatefulWidget {
  final Map<String, dynamic> mp;

  const updateEmployeeDialog({Key? key, required this.mp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _updateEmployeeDialogState(mp: mp);
}

const List<String> depts = <String>[
  'Admin',
  'Engineer',
  'Manager',
  'Sales',
  'Logistics',
  'Supplier',
  'IT'
];

class _updateEmployeeDialogState extends State<updateEmployeeDialog> {
  final Map<String, dynamic> mp;

  TextEditingController company = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController joiningDate = TextEditingController();
  TextEditingController resignationDate = TextEditingController();
  TextEditingController jobTitle = TextEditingController();
  TextEditingController businessPhone = TextEditingController();
  TextEditingController homePhone = TextEditingController();
  TextEditingController mobilePhone = TextEditingController();
  TextEditingController faxNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController webpage= TextEditingController();
  TextEditingController notes= TextEditingController();
  TextEditingController attachment = TextEditingController();
  var category;

  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Employee Updated Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool loading = false;

  _updateEmployeeDialogState({required this.mp}) {
    category = (mp["department"] == "" ? "Admin" : mp["department"].toString());
    company.text = (mp["company"] == null ? "" : mp["company"].toString());
    firstName.text = (mp["firstName"] == null ? "" : mp["firstName"].toString());
    lastName.text = (mp["lastName"] == null ? "" : mp["lastName"].toString());
    email.text = (mp["email"] == null ? "" : mp["email"].toString());
    if(mp["joiningDate"] != null){
      DateTime parseDate = DateFormat("yyyy-MM-dd").parse(mp["joiningDate"].toString().substring(0, 10));
      joiningDate.text = DateFormat("dd-MM-yyyy").format(parseDate).toString();
    }
    if(mp["resignationDate"] != null){
      DateTime parseDate = DateFormat("yyyy-MM-dd").parse(mp["resignationDate"].toString().substring(0, 10));
      resignationDate.text = DateFormat("dd-MM-yyyy").format(parseDate).toString();
    }
    jobTitle.text = (mp["jobTitle"] == null ? "" : mp["jobTitle"].toString());
    businessPhone.text = (mp["business"] == null ? "" : mp["business"].toString());
    homePhone.text = (mp["home"] == null ? "" : mp["home"].toString());
    mobilePhone.text = (mp["mobile"] == null ? "" : mp["mobile"].toString());
    faxNumber.text = (mp["fax"] == null ? "" : mp["fax"].toString());
    address.text = (mp["address"] == null ? "" : mp["address"].toString());
    city.text = (mp["city"] == null ? "" : mp["city"].toString());
    state.text = (mp["state"] == null ? "" : mp["state"].toString());
    zip.text = (mp["zip"] == null ? "" : mp["zip"].toString());
    country.text = (mp["country"] == null ? "" : mp["country"].toString());
    webpage.text = (mp["webpage"] == null ? "" : mp["webpage"].toString());
    notes.text = (mp["notes"] == null ? "" : mp["notes"].toString());
    attachment.text = (mp["attachments"] == null ? "" : mp["attachments"].toString());
  }

  void postData() async {

    if(validate()==true){
      dynamic res = await apiClient.updateEmployee(mp["id"].toString(), company.text, category.text, firstName.text, lastName.text, email.text, joiningDate.text, resignationDate.text, jobTitle.text, businessPhone.text, homePhone.text, mobilePhone.text, faxNumber.text, address.text, city.text, state.text, zip.text, country.text, webpage.text, notes.text, attachment.text);

      if(res?["success"]==true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar3);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar4);
      }
    }

    await Future.delayed(Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  bool validate() {
    if(category.text=="" || company.text=="" || firstName.text=="" || businessPhone.text=="" || jobTitle.text=="" || joiningDate.text==""){
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
      return false;
    }

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
        title: Text("Update Employee"),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      body: form(),
    );
  }

  Widget form() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ListView(
        children: [
          DropdownButton<String>(
            value: category,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: Text(
              "Category*",
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5), fontSize: 16.0),
            ),
            style: const TextStyle(color: Colors.white),
            underline: Container(
              height: 1,
              color: Colors.white,
            ),
            onChanged: (String? value) {
              setState(() {
                category = value!;
              });
            },
            items: depts.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: company,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Company*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: firstName,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "First Name*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: lastName,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Last Name",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            controller: email,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Email-Address*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: jobTitle,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Job Title*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
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
                  initialDate: joiningDate.text == ""
                      ? DateTime.now()
                      : DateTime.parse(joiningDate.text),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: ColorScheme.dark(
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
                  joiningDate.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : joiningDate.text;
                });
              });
            },
            controller: joiningDate,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Joining Date*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
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
                  initialDate: resignationDate.text == ""
                      ? DateTime.now()
                      : DateTime.parse(resignationDate.text),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: ColorScheme.dark(
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
                  resignationDate.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : resignationDate.text;
                });
              });
            },
            controller: resignationDate,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Resignation Date*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: businessPhone,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Business Phone*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: homePhone,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Home Phone",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: mobilePhone,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Mobile Phone",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: faxNumber,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Fax Number",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: address,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Address",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: city,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "City",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: state,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "State",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: zip,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "ZIP/Postal Code",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: country,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Country",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: webpage,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Webpage",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: notes,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Notes",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: attachment,
            decoration: InputDecoration(
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Attachment",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(onPressed: () => postData(),
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