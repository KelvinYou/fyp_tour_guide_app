import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fyp_project/ui_view/login_view.dart';
import 'package:fyp_project/ui_view/register_view.dart';
import 'package:fyp_project/app_theme.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static const String title = 'Profile';
  int counter = 0;
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 56.0,
                    backgroundImage: AssetImage('assets/erza.jpg'),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppTheme.nearlyWhite,
                        side: const BorderSide(width: 1.0, color: AppTheme.primary,),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: AppTheme.primary,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppTheme.primary,
                      ),
                      child: Text('Register'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Register()),
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(child: Column(
                  children: [
                    
                  ],
                ),
                ),
              ],
            ),),
          ],
        ),
      ),
    );
    // bool isLogin = false;
    // return Scaffold(

      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     setState(() {
      //       counter = counter + 1;
      //     });
      //   },
      //   child: Container(
      //     width: 60,
      //     height: 60,
      //     child: Icon(
      //         Icons.add
      //     ),
      //     decoration: const BoxDecoration(
      //         shape: BoxShape.circle,
      //         gradient: LinearGradient(
      //           colors: [Colors.blue,Colors.lightBlueAccent],)),
      //   ),
      // ),
      // body: Stack(
      //   children: [
      //     Column(
      //       children: [
      //         Expanded(
      //           flex: 4,
      //           child: Row(
      //             children: [
      //               const Expanded(
      //                 child: CircleAvatar(
      //                   radius: 65.0,
      //                   backgroundImage: AssetImage('assets/erza.jpg'),
      //                   backgroundColor: Colors.white,
      //                 ),
      //               ),
      //               Expanded(
      //                 child: ElevatedButton(
      //                   child: const Text('Login'),
      //                   onPressed: () {
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(builder: (context) => const Login()),
      //                     );},
      //                 ),
      //               ),
      //
      //               Expanded(
      //                 child: ElevatedButton(
      //                   child: const Text('Register'),
      //                   onPressed: () {
      //                     // Navigate to second route when tapped.
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(builder: (context) => const Register()),
      //                     );
      //                   },
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         Expanded(
      //           flex:5,
      //           child:Container(
      //             width: double.infinity,
      //             decoration: const BoxDecoration(
      //               gradient: LinearGradient(
      //                 colors: [Colors.blue,Colors.lightBlueAccent],
      //               ),
      //             ),
      //             child: Column(
      //                 children: const [
      //                   // SizedBox(height: 110.0,),
      //                   CircleAvatar(
      //                     radius: 65.0,
      //                     backgroundImage: AssetImage('assets/erza.jpg'),
      //                     backgroundColor: Colors.white,
      //                   ),
      //                   SizedBox(height: 10.0,),
      //                   Text('Kelvin You',
      //                       style: TextStyle(
      //                         color:Colors.white,
      //                         fontSize: 20.0,
      //                       )),
      //                   SizedBox(height: 10.0,),
      //                   Text('New User',
      //                     style: TextStyle(
      //                       color:Colors.white,
      //                       fontSize: 15.0,
      //                     ),)
      //                 ]
      //             ),
      //           ),
      //         ),
      //
      //         Expanded(
      //           flex:5,
      //           child: Container(
      //             color: Colors.grey[200],
      //             child: Center(
      //                 child:Card(
      //                     margin: const EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      //                     child: SizedBox(
      //                         width: 345.0,
      //                         height:120.0,
      //                         child: Padding(
      //                           padding: EdgeInsets.all(10.0),
      //                           child: Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Row(
      //                                 mainAxisAlignment: MainAxisAlignment.start,
      //                                 children: [
      //                                   Icon(
      //                                     Icons.help_center,
      //                                     color: Colors.blueAccent[400],
      //                                     size: 35,
      //                                   ),
      //                                   SizedBox(width: 20.0,),
      //                                   Column(
      //                                     crossAxisAlignment: CrossAxisAlignment.start,
      //                                     children: [
      //                                       Text("Help Center",
      //                                         style: TextStyle(
      //                                           fontSize: 15.0,
      //                                         ),),
      //                                     ],
      //                                   )
      //                                 ],
      //                               ),
      //                               SizedBox(height: 20.0,),
      //                               Row(
      //                                 mainAxisAlignment: MainAxisAlignment.start,
      //                                 children: [
      //                                   Icon(
      //                                     Icons.chat_bubble,
      //                                     color: Colors.yellowAccent[400],
      //                                     size: 35,
      //                                   ),
      //                                   SizedBox(width: 20.0,),
      //                                   Column(
      //                                     crossAxisAlignment: CrossAxisAlignment.start,
      //                                     children: [
      //                                       Text("Chat with Admin",
      //                                         style: TextStyle(
      //                                           fontSize: 15.0,
      //                                         ),),
      //                                     ],
      //                                   )
      //                                 ],
      //                               ),
      //                             ],
      //                           ),
      //                         )
      //                     )
      //                 )
      //             ),
      //           ),
      //         ),
      //
      //       ],
      //     ),
      //     Positioned(
      //         top:MediaQuery.of(context).size.height*0.20,
      //         left: 20.0,
      //         right: 20.0,
      //         child: Card(
      //             child: Padding(
      //               padding:EdgeInsets.all(16.0),
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                 children: [
      //                   Container(
      //                       child:Column(
      //                         children: [
      //                           Text('Completed',
      //                             style: TextStyle(
      //                                 color: Colors.grey[400],
      //                                 fontSize: 14.0
      //                             ),),
      //                           SizedBox(height: 5.0,),
      //                           Text("$counter",
      //                             style: TextStyle(
      //                               fontSize: 15.0,
      //                             ),)
      //                         ],
      //                       )
      //                   ),
      //
      //                   Container(
      //                     child: Column(
      //                         children: [
      //                           Text('Browse',
      //                             style: TextStyle(
      //                                 color: Colors.grey[400],
      //                                 fontSize: 14.0
      //                             ),),
      //                           SizedBox(height: 5.0,),
      //                           Text('30',
      //                             style: TextStyle(
      //                               fontSize: 15.0,
      //                             ),)
      //                         ]),
      //                   ),
      //
      //                   Container(
      //                       child:Column(
      //                         children: [
      //                           Text('Collect',
      //                             style: TextStyle(
      //                                 color: Colors.grey[400],
      //                                 fontSize: 14.0
      //                             ),),
      //                           SizedBox(height: 5.0,),
      //                           Text('5',
      //                             style: TextStyle(
      //                               fontSize: 15.0,
      //                             ),)
      //                         ],
      //                       )
      //                   ),
      //                 ],
      //               ),
      //             )
      //         )
      //     )
      //   ],

      // ),
    // );
  }
  
}