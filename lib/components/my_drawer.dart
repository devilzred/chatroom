import 'package:chatroom/services/auth_services/signout_function.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
          DrawerHeader(child: Icon(Icons.chat,size: 60,)),
          
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('H O M E'),
                  leading: Icon(Icons.home_filled),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('A C T I V E'),
                  leading: Icon(Icons.online_prediction),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/active'); 
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('P R O F I L E'),
                  leading: Icon(Icons.person),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');                  
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('B L O C K E D'),
                  leading: Icon(Icons.block_flipped),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/blocked');                  
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 30),
            child: ListTile(
              title: Text('L O G O U T'),
              leading: Icon(Icons.logout),
              onTap: (){
                signOut(context);
              },
            ),
          )
        ],
      ),
    );
  }
}