import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:passwordsaver/Features/Encryption/encrypt.dart';

import '../../../widget/main_box.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();

  final passwordbox = Hive.box("passwords");
bool errortext =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshitems();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _passController.dispose();
  }

  List<Map<String, dynamic>> _items = [];

  void _refreshitems() {
    final data = passwordbox.keys.map((key) {
      final item = passwordbox.get(key);
      return {
        "key": key,
        "domain": item["domain"],
        "name": item["name"],
        "password": item["password"]
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    
    });
  }

  Future<void> _createItem(Map<String, dynamic> item) async {
    await passwordbox.add(item);
    _refreshitems();
    _nameController.clear();
    _passController.clear();
    _domainController.clear();
  }

  Future<void> _deleteItem(int? itemkey) async {
    await passwordbox.delete(itemkey);
    
    _refreshitems();
  }

  Future<void> _updateItem(int? itemkey, Map<String, dynamic> item) async {
    await passwordbox.put(itemkey, item);

    _refreshitems();
    _nameController.clear();
    _domainController.clear();
    _passController.clear();
  }

  void _showform(BuildContext context, int? itemkey) async {
    bool isVisible = true;

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 15,
                left: 15,
                right: 15,
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextField(
                  controller: _domainController,
                  decoration: InputDecoration(
                    label: Text("Domain"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    label: Text("Username"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: _passController,
                  obscureText: isVisible,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                      
                        },
                        icon: Icon(
                          isVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    label: Text("Password"),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                errortext?Text("Enter All Fields",style: TextStyle(color: Colors.red),):Text(""),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () {
                      if(_domainController.text.isNotEmpty && _nameController.text.isNotEmpty && _passController.text.isNotEmpty){
                     setState((){

                      errortext=false;
                     });
                        
                     
                      if (itemkey == null) {
                        _nameController.clear();
                        _passController.clear();
                        _domainController.clear();
                        _createItem({
                          "domain": _domainController.text,
                          "name": _nameController.text,
                          "password": EncryptData.encryptAES(_passController.text),
                        });
                      }
                      if (itemkey != null) {
                        _updateItem(itemkey, {
                          "domain": _domainController.text,
                          "name": _nameController.text,
                          "password": EncryptData.encryptAES(_passController.text),
                        });

                      }
                      Navigator.of(context).pop();
                      }
                      else{
                      setState((){
                        errortext=true;
                      });
                          
                      
                      }
                      
                    },
                    child:
                        itemkey == null ? Text("Create New") : Text("Update")),
                SizedBox(
                  height: 20,
                ),
              ]),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(232, 33, 235, 215),
        title: Text("Password Saver",style: TextStyle(
          fontWeight: FontWeight.w800
        ),),
        elevation: 0,
      ),
      body: SafeArea(
        
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (_, index) {
                  final currentItem = _items[index];
                  return Stack(
                    children: [
                      Mainbox(
                        name: currentItem['name'],
                        password:  EncryptData.decryptAES(currentItem['password']),
                        domain: currentItem['domain'],
                      ),
                      Positioned(
                          right: 18,
                          top: 25,
                          child: GestureDetector(
                              onTap: () {
                                _deleteItem(currentItem['key']);
                              },
                              child: Icon(Icons.delete))),
                      Positioned(
                          right: 48,
                          top: 25,
                          child: GestureDetector(
                              onTap: () {
                                _domainController.text = currentItem['domain'];
                                _nameController.text = currentItem['name'];
                                _passController.text = EncryptData.decryptAES(currentItem['password']);

                                _showform(context, currentItem['key']);
                              },
                              child: Icon(Icons.edit))),
                    ],
                  );
                })),
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Color.fromARGB(232, 33, 235, 215),
        onPressed: () {
          _showform(context, null);

        },
        child: Icon(Icons.add),
      ),
    );
  }
}
