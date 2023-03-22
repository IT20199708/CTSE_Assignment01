import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_assignment01/src/models/interestArea_model/InterestAreaModel.dart';
import 'package:ctse_assignment01/src/screens/org_screens/org_edufeed_screen/org_edufeed_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/colors/colors.dart';
import '../../user_screens/home_screen/home_screen.dart';

class InterestArea extends StatefulWidget {
  final String userRole;
  const InterestArea({Key? key, required this.userRole}) : super(key: key);

  @override
  State<InterestArea> createState() => _InterestAreaState();
}

class _InterestAreaState extends State<InterestArea> {
  var _filters = [];
  bool _isLoading = false;

  Future<List<InterestAreaModel>> GetInterestAres() async{
    List<InterestAreaModel> Areas= [];
    CollectionReference interestAreas = FirebaseFirestore.instance.collection('interestAreas');
    QuerySnapshot querySnapshot = await interestAreas.get();

if(querySnapshot.docs.isEmpty){
   Areas.add(new InterestAreaModel("No Data","No Data"));
  return Areas;
}
    for(var doc in querySnapshot.docs){
      InterestAreaModel area = new InterestAreaModel(doc['name'],doc['description']);
      Areas.add(area);
    }
    return Areas;
  }

  addInterestToDB() async{
    setState(()=>_isLoading = true);
    final docUser = FirebaseFirestore.instance.collection('user').doc(FirebaseAuth.instance.currentUser?.uid);

   await  docUser.update({
      'offeringAreas':_filters,
      'newUser':false
    });
   setState(()=>_isLoading = false);
   if(widget.userRole == 'org'){
     Get.off(()=> OrgEduFeed());
   }else{
     Get.off(()=>HomeScreen());
   }
  }
  @override
  void initState() {
    super.initState();
    print(_filters);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Text(
                'Choose your Interest Areas',
                style: Theme.of(context).textTheme.headline3
              ),
              SizedBox(height: 20.h),
              Text('This tags will be used for customize app content to your preferences',style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: 20.h),
             Card(
               elevation: 5,
               shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10) ),
               child: Container(
                 width: double.maxFinite,
                 height:400.h,
                 child: FutureBuilder(
                     future:GetInterestAres(),
                     builder: (context,AsyncSnapshot<List<InterestAreaModel>> snapshot){
                       if(snapshot.hasData){
                         return SingleChildScrollView(
                           scrollDirection: Axis.vertical,
                           child: Padding(
                             padding: EdgeInsets.all(10),
                             child: Wrap(
                               runSpacing: 10,
                               spacing: 10,
                               children:getChipWidget(snapshot.data!) ,
                             ),
                           ),
                         );
                       }

                      return Center(
                         child: CircularProgressIndicator(),
                       );
                 }),
               ),
             ),
              SizedBox(height:20.h),

          ElevatedButton(onPressed:addInterestToDB, child:_isLoading ? Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            Padding(padding: EdgeInsets.all(5),child: CircularProgressIndicator(color: Colors.white,)),SizedBox(width: 10.w),Text("Loading ....")
          ]) : Padding(padding: EdgeInsets.all(10),child: Text("Done")))

            ],
          ),
        ),
      ),
    );
  }


  List<Widget> getChipWidget(List<InterestAreaModel> list){
    return list.map((e) => FilterChip(label: Text(e.name), onSelected: (value) { 
      setState((){
        if(value){
          _filters.add(e.name);
          print(_filters);
        }else{
          _filters.removeWhere((element) => element == e.name);
        }
      });
    }, selected: _filters.contains(e.name),
      checkmarkColor: tPrimaryColor,
      selectedColor: tPrimaryColor.withOpacity(0.25),)).toList();
  }
}
