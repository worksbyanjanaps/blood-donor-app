import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference donor = FirebaseFirestore.instance.collection('donor');
  void deleteDonor(docId) {
    donor.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Blood Donation App',style: TextStyle(color: Colors.white),),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {Navigator.pushNamed(context, '/add');},backgroundColor: Colors.white,child: Icon(Icons.add,color: Colors.red,size: 40,),),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
     body: StreamBuilder(
         stream: donor.orderBy('name').snapshots(),
         builder: (context,AsyncSnapshot snapshot) {
           if (snapshot.hasData) {
             return ListView.builder(itemCount: snapshot.data!.docs.length,
                 itemBuilder: (context,index) {
               final DocumentSnapshot donorSnap = snapshot.data.docs[index];
               return Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Container(
                   height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        spreadRadius: 15
                      )
                    ]
                  ),
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                       Container(
                         child: CircleAvatar(
                           radius: 30,
                           backgroundColor: Colors.red,
                           child: Text(donorSnap['group'],style: TextStyle(fontSize: 25),),
                       ),),
                       Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text(donorSnap['name'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,)),
                           Text(donorSnap['phone'].toString(),style: TextStyle(fontSize: 18))
                         ],
                       ),
                         Row(children: [
                           IconButton(onPressed: () {Navigator.pushNamed(context,'/update',arguments: {'name':donorSnap['name'],'phone':donorSnap['phone'].toString(),'group':donorSnap['group'],'id':donorSnap.id});}, icon: Icon(Icons.edit,size: 40,color: Colors.blue,)),
                           IconButton(onPressed: () {deleteDonor(donorSnap.id);}, icon: Icon(Icons.delete,size: 40,color: Colors.red,)),
                         ],)
                     ],),
                   ),
                 ),
               );
                 });
           }
           return Container();
         }),
    );
  }
}
