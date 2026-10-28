import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final bloodGroups = ['A+','A-','B+','B-','O+','O-','AB+','AB-'];
  String? selectedGroup;
  final CollectionReference donor = FirebaseFirestore.instance.collection('donor');

  final TextEditingController donorName = TextEditingController();
  final TextEditingController donorPhone = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<bool> updateDonor(String docId) async {
    final data = {
      'name': donorName.text.trim(),
      'phone': donorPhone.text.trim(),
      'group': selectedGroup,
    };

    try {
      await donor.doc(docId).update(data);
      return true;
    } catch (e) {
      debugPrint('Error updating donor: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map;
    donorName.text = args['name'];
    donorPhone.text = args['phone'];
    selectedGroup = args['group'];
    final docId = args['id'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        title: const Text("Update Donors",style: TextStyle(color: Colors.white),),
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
                validator: (value) {
                  if (value == null || !RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                    return 'Enter a valid 10-digit phone number';
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
                initialValue: selectedGroup,
                  decoration: InputDecoration(labelText: "Select Blood Group"),
                  items: bloodGroups.map((e)=> DropdownMenuItem(child: Text(e),value: e,)).toList(),
                  onChanged: (value) {
                    selectedGroup =value as String?;
                  }),
              SizedBox(height: 12,),

              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final success = await updateDonor(docId);

                        if (success && mounted) {
                          Navigator.pop(context);
                        } else if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to update donor'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: const Text("Submit",style: TextStyle(fontSize: 12,color: Colors.white))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
