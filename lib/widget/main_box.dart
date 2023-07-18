import 'package:flutter/material.dart';

class Mainbox extends StatefulWidget {
  const Mainbox({super.key,  this.name,  this.password,  this.domain});
  final  name;
  final  domain;
  final  password;

  @override
  State<Mainbox> createState() => _MainboxState();
}

class _MainboxState extends State<Mainbox> {
  bool isObscure = true;

  void _showpopup(){

    showDialog(
              context: context,
             builder: ( BuildContext context ) {
          return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                  scrollable: true,
                  title: const Text("your password"),
                  content: Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                           child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                SizedBox(height: 10,),
                                Text(widget.name),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(isObscure == true
                                        ? '${widget.password.replaceAll(RegExp(r"."), "*")}'
                                        :widget.password),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isObscure ? isObscure = false : isObscure = true;
                                        });
                                      },
                                      child: Icon(
                                        isObscure ? Icons.visibility_off : Icons.visibility,
                                                                  ),
                                    )
                                  ],
                                )
                              ],
                            ),
                         ));
  });});


    }


  @override
  Widget build(BuildContext context) {
    return
         
       Container(
       
         child: Stack(
            children: [
           
              GestureDetector(
                 onTap: (){
                              _showpopup();
                            },
                child: Container(
                  width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(106, 33, 235, 214),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child:
                       Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(widget.domain,style: TextStyle(fontWeight: FontWeight.w800),),
                         
                          ],
                        ),
                         
                         ),
              ),
            ],
          ),
       );
  }
}
