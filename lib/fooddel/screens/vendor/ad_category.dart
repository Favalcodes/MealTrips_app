import 'package:flutter/material.dart';

 List schoolList =  ['JS Tarka University', "Benue State University Makurdi"];
 
class SelectSchool extends StatefulWidget {
  final String userId;
  final String view;
  SelectSchool({this.userId, this.view});
  @override
  _SelectSchoolState createState() => _SelectSchoolState();
}

class _SelectSchoolState extends State<SelectSchool> {
 
  String schoolName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                 GestureDetector(
                  onTap: (){
                      setState(()=>schoolName = schoolList[0]);
                  },
                  child:Material(
                    elevation: 2.0,
                      color:schoolName != schoolList[0] ? Colors.white : Colors.lightGreen,
                      borderRadius: BorderRadius.circular(30.0),
                    child: Padding(
                       padding:EdgeInsets.symmetric(horizontal:30.0, vertical: 10.0),
                    child: Text(schoolList[0], style:TextStyle(color:schoolName == schoolList[0] ? Colors.white : Colors.lightGreen, fontSize:16.0)),
                  ),
                  )
                ),
                SizedBox(height:20.0),

                GestureDetector(
                  onTap: (){
                    setState(()=>schoolName = schoolList[1]);
                  },
                  child: Material(
                    elevation: 2.0,
                      color:schoolName != schoolList[1] ? Colors.white : Colors.lightGreen,
                      borderRadius: BorderRadius.circular(30.0),
                    child: Padding(
                      padding:EdgeInsets.symmetric(horizontal:30.0, vertical: 10.0),
                      child:Text(schoolList[1], style:TextStyle(color:schoolName == schoolList[1] ? Colors.white : Colors.lightGreen, fontSize:16.0))
                    ),
                  ),
                )
              ],
            ),
          ),

          //  GestureDetector(
          //    onTap: schoolName == null ? null : ()=>Naviga,
          //   child: Center(
          //     child: Material(
          //       color: schoolName == null ? Colors.grey : Colors.lightGreen, 
          //       borderRadius: BorderRadius.circular(8.0),
          //       child:Padding(
          //          padding:EdgeInsets.symmetric(horizontal:60.0, vertical: 10.0),
          //         child: Text("Continue", style: TextStyle( color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600)),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}