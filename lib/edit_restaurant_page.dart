import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRestaurantPage extends StatefulWidget {
  final DocumentSnapshot doc;

  EditRestaurantPage({required this.doc});

  @override
  _EditRestaurantPageState createState() => _EditRestaurantPageState();
}

class _EditRestaurantPageState extends State<EditRestaurantPage> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController stationController;

  @override
  void initState() {
    super.initState();
    var data = widget.doc.data() as Map<String, dynamic>;
    
    nameController = TextEditingController(text: data.containsKey('namefood') ? data['namefood'] : '');
    categoryController = TextEditingController(text: data.containsKey('typefood') ? data['typefood'] : '');
    stationController = TextEditingController(text: data.containsKey('station') ? data['station'] : '');
  }

  Future<void> _updateRestaurant() async {
    try {
      await widget.doc.reference.update({
        'namefood': nameController.text,
        'typefood': categoryController.text,
        'station': stationController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('อัปเดตร้านอาหารเรียบร้อย!')),
      );
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text('แก้ไขร้านอาหาร'), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'ชื่อร้านอาหาร',
                labelStyle: TextStyle(color: Colors.red),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: categoryController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'ประเภทอาหาร',
                labelStyle: TextStyle(color: Colors.red),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: stationController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'สถานที่',
                labelStyle: TextStyle(color: Colors.red),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _updateRestaurant,
              child: Text(
                "บันทึกการเปลี่ยนแปลง",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
