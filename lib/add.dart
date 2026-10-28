import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDonor extends StatefulWidget {
  const AddDonor({super.key});

  @override
  State<AddDonor> createState() => _AddDonorState();
}

class _AddDonorState extends State<AddDonor> {
  final bloodGroups = ['A+','A-','B+','B-','O+','O-','AB+','AB-'];
  String? selectedGroup;
  final CollectionReference donor = FirebaseFirestore.instance.collection('donor');

  Future<bool> addDonor() async {
    final data = {
      'name':donorName.text,
      'phone':donorPhone.text,
      'group':selectedGroup
    };
   try {
     await donor.add(data);

     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
         content: Text('Donor added successfully!'),
         backgroundColor: Colors.green,
       ),
     );
     return true;
     print('Donor added successfully');
   } catch(e){
     print('Error adding Donor:$e');

     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Error adding donor: $e'),
         backgroundColor: Colors.red,
       ),
     );
     return false;
   }
  }
  final TextEditingController donorName = TextEditingController();
  final TextEditingController donorPhone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {    Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        title: const Text("Add Donors",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter donor name';
                  }
                  return null;
                },
                controller: donorName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "DonorText"
                ),
              ),
              SizedBox(height: 12,),
              TextFormField(
                validator:  (value) {
                  if (value == null || value.trim().isEmpty || value.length != 10) {
                    return 'Please enter donor phone Number';
                  }
                  return null;
                },
                controller: donorPhone,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Phone Number"
                ),
              ),
              DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Please select blood group';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "Select Blood Group"),
                  items: bloodGroups.map((e)=> DropdownMenuItem(child: Text(e),value: e,)).toList(),
                  onChanged: (value) {
                    selectedGroup =value as String?;
                  }),
              SizedBox(height: 12),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                    onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await addDonor();
                      if (success && mounted) {
                        Navigator.pop(context);
                      }
                    }
                    },
                    child: const Text("Submit",style: TextStyle(fontSize: 12,color: Colors.white)))),
            ],
          ),
        ),
      ),
    );
  }
}
