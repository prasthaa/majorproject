// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:attendance_sys/UI/Pages/Dashboard.dart';
import 'package:attendance_sys/UI/Pages/LogIn.dart';
import 'package:attendance_sys/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../function.dart';
import '../../providers/auth.dart';

class StudentInfoScreen extends StatefulWidget {
  const StudentInfoScreen({
    Key? key,
  }) : super(key: key);
  static const routeName = "/studentinfo";

  @override
  _StudentInfoScreenState createState() => _StudentInfoScreenState();
}

class _StudentInfoScreenState extends State<StudentInfoScreen> {
  late bool checkboxListTileValue1 = false;
  late bool checkboxListTileValue2 = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentSortColumn = 0;
  var _isInit = true;
  var _isLoading = false;
  int? _total;
  Map<String, String?>? _body;
  String? _error;
  List<Map> _allStudents = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _body = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

      final token = Provider.of<Auth>(context).token;
      try {
        // fetch classname and subject name
        var data = await fetchData("${BACKEND_URL}/api/getinfo",
            body: _body, method: "GET", token: token);

        if (data.length != 0) {
          data['working_days'].forEach(
              (k, v) => _allStudents.add({'roll_no': k, 'present_days': v}));
          _total = data['total_days'];
        }

        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
          _error = error as String;
        });
      }

      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.14),
        child: AppBar(
          backgroundColor: Color(0xFF265784),
          automaticallyImplyLeading: true,
          flexibleSpace: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-0.5, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 45, 0, 0),
                  child: Text(
                    'Smart Attendance NCE',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.95, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.015,
                  decoration: BoxDecoration(
                    color: Color(0xFF265784),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.85, 0),
                child: InkWell(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (alertDialogContext) {
                        return AlertDialog(
                          title: Text('Are you sure to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(alertDialogContext),
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                

                                Navigator.of(context).pushReplacementNamed(
                                  "/",
                                );
                              },
                              child: Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Align(
              alignment: AlignmentDirectional(0, 0.15),
              child: InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashboardScreen(),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    'assets/images/2123.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
          elevation: 0,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(1, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color: Color(0xFF265784),
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(
                            color: Colors.white,
                            width: 0,
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(100),
                              topRight: Radius.circular(0),
                            ),
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(-0.6, 0),
                              child: Text(
                                'Class Name: ${_body!["classname"]}\nSubject Name: ${_body!["subjectname"]}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF265784),
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.65, 0),
                                  child: Text(
                                    'Total Days: ${_total}',
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Color(0xFFEA734D),
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DataTable(
                  columns: [
                    DataColumn(
                      label: Text('Roll no'),
                      // onSort: (columnIndex, _) {
                      //   setState(() {
                      //     _currentSortColumn = columnIndex;
                      //     if (_isSortAsc) {
                      //       allStudents.sort((a, b) =>
                      //           b['Roll no'].compareTo(a['Roll no']));
                      //     } else {
                      //       allStudents.sort((a, b) =>
                      //           a['Roll no'].compareTo(b['Roll no']));
                      //     }
                      //     _isSortAsc = !_isSortAsc;
                      //   });
                      // },
                    ),
                    DataColumn(
                      label: Text('Present Days'),
                      numeric: true,
                    )
                  ],
                  rows: _allStudents
                      .map((student) => DataRow(cells: [
                            DataCell(Text(student['roll_no'])),
                            DataCell(Text(student['present_days'].toString()))
                          ]))
                      .toList(),
                  // sortColumnIndex: _currentSortColumn,
                  // sortAscending: _isSortAsc,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow buildRow(List<String> cells) => TableRow(
        children: cells.map((cell) => Text(cell)).toList(),
      );
}
