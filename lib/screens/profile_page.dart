import 'dart:io';
import 'package:chatroom/components/custom_appbar.dart';
import 'package:chatroom/models/usermodel.dart';
import 'package:chatroom/services/auth_services/signout_function.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;
  File? _profileImage;
  bool _isLoadingImage = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<UserModel> getUserData(String uid) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  Future<void> fetchUserData() async {
    UserModel userData = await getUserData(widget.uid);
    setState(() {
      user = userData;
    });
  }

  Future<void> updateProfilePic(String uid, File profilePic) async {
    try {
      setState(() {
        _isLoadingImage = true;
      });
      // Upload image to Firebase Storage
      String fileName = 'profile_pics/$uid.png';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref(fileName).putFile(profilePic);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore document
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profilePicUrl': downloadUrl,
      });

      setState(() {
        _isLoadingImage = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoadingImage = false;
      });
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      await updateProfilePic(widget.uid, _profileImage!);
      await fetchUserData();
    }
  }

  Future<void> _showEditDialog(BuildContext context, String title,
      String initialValue, Function(String) onSave) async {
    TextEditingController _controller =
        TextEditingController(text: initialValue);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change $title'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'New $title',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                onSave(_controller.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateUserName(String uid, String newName) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': newName,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveName(String newName) async {
    if (user != null) {
      await updateUserName(user!.uid, newName);
      await fetchUserData();
    }
  }

  Future<void> deleteAccount(BuildContext context, String uid, User? user, String email, String password) async {
    try {
      if (user != null) {
        // Re-authenticate the user
        AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);
        
        // Delete user data from Firestore
        await FirebaseFirestore.instance.collection("users").doc(uid).delete();
        
        // Delete the user account from Firebase Auth
        await user.delete();
        
        // Sign out the user
        await signOut(context);
        
        // Notify the user of successful deletion
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account Deleted')),
        );
        
        // Navigate to the login screen
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      // Show an error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _showDeleteBox(BuildContext context, String userID, User? currentUser) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to delete this account?'),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              // Call the function to delete account with email and password
              await deleteAccount(
                context,
                userID,
                currentUser,
                emailController.text,
                passwordController.text,
              );

              // Dismiss the dialog
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile Page'),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: _isLoadingImage
                            ? CircularProgressIndicator()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: user!.profilePicUrl.isEmpty
                                    ? AssetImage('assets/images/default_profile.png')
                                    : NetworkImage(user!.profilePicUrl)
                                        as ImageProvider,
                              ),
                      ),
                      SizedBox(height: BoxHeight.small),
                      Text(user!.name, style: TextStyle(fontSize: 24)),
                      SizedBox(height: BoxHeight.verysmall),
                      Text(user!.email, style: TextStyle(fontSize: 16)),
                      SizedBox(
                        height: BoxHeight.large,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: Icon(
                            Icons.photo_camera_front_outlined,
                          ),
                          onTap: pickImage,
                          title: const Text(
                            'Change Profile Photo',
                            style: AppStyle.bodyText,
                          ),
                          trailing: IconButton(
                            onPressed: pickImage,
                            icon: Icon(Icons.arrow_forward),
                            color: AppColors.primary,
                            iconSize: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: BoxHeight.small,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: Icon(
                            Icons.abc,
                          ),
                          onTap: () {
                            _showEditDialog(
                                context, 'Name', user!.name, saveName);
                          },
                          title: const Text(
                            'Change Your Name',
                            style: AppStyle.bodyText,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              _showEditDialog(
                                  context, 'Name', user!.name, saveName);
                            },
                            icon: Icon(Icons.arrow_forward),
                            color: AppColors.primary,
                            iconSize: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showDeleteBox(
                              context, widget.uid, widget.currentUser);
                        },
                        icon: Icon(
                          Icons.delete_forever,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          'Delete Account',
                          style: AppStyle.errorText,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.border),
                      ),
                      SizedBox(
                        height: BoxHeight.small,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
