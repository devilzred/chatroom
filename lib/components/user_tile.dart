import 'package:chatroom/utils/utils.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final String? profilePicUrl;
  final String? subtitle;
  final void Function()? onTap;

  const UserTile({
    Key? key,
    required this.text,
    this.profilePicUrl,
    this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80, // Adjusted height to accommodate subtitle
        margin: EdgeInsets.fromLTRB(14, 12, 14, 0),
        decoration: BoxDecoration(
          color: AppColors.text,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: profilePicUrl != null && profilePicUrl!.isNotEmpty
                    ? NetworkImage(profilePicUrl!) as ImageProvider
                    : AssetImage('assets/images/default_profile.png'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text, style: TextStyle(fontSize: 16)),
                    if (subtitle != null)
                      Text(subtitle!, style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
