import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_restaurant_page.dart';
import 'edit_restaurant_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference restaurants =
      FirebaseFirestore.instance.collection('Restaurants');

  int _selectedIndex = 0; // สำหรับ Bottom Navigation Bar

  void _onItemTapped(int index) {
    if (index == 1) { // ปุ่มเพิ่มร้านอาหาร
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddRestaurantPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // พื้นหลังสีดำ
      appBar: AppBar(
        title: Text('Restaurants'),
        backgroundColor: Colors.white, // AppBar สีแดง
      ),
      body: StreamBuilder(
        stream: restaurants.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.red));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'ไม่มีข้อมูลร้านอาหาร',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            );
          }
          return ListView(
            padding: EdgeInsets.all(10),
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>?;

              String name = data != null && data.containsKey('namefood')
                  ? data['namefood']
                  : 'ไม่มีชื่อ';
              String type = data != null && data.containsKey('typefood')
                  ? data['typefood']
                  : 'ไม่มีประเภท';

              return Card(
                color: Colors.grey[900], // กรอบสีดำเข้ม
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ชื่อร้านอาหาร : $name',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'ประเภท :  $type',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white70),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditRestaurantPage(doc: doc)),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              doc.reference.delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("ลบร้านอาหารสำเร็จ")),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red, // สีแดง
        selectedItemColor: Colors.white, // ไอคอนที่ถูกเลือกสีขาว
        unselectedItemColor: Colors.black, // ไอคอนไม่ถูกเลือกสีดำ
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'โฮม',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'เพิ่ม',
          ),
        ],
      ),
    );
  }
}
