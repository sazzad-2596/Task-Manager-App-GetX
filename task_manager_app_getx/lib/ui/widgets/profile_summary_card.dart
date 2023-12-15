import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../style/styles.dart';
import '../controller/auth_controller.dart';
import '../screens/login_screen.dart';
import '../screens/update_profile_screen.dart';


class ProfileSummeryCard extends StatefulWidget {
  final bool onTapStatus;

  const ProfileSummeryCard({
    super.key,
    this.onTapStatus = true,
  });

  @override
  State<ProfileSummeryCard> createState() => _ProfileSummeryCardState();
}

class _ProfileSummeryCardState extends State<ProfileSummeryCard> {
  String imageFormat = Auth().user?.photo ?? '';

  @override
  Widget build(BuildContext context) {
    if (imageFormat.startsWith('data:image')) {
      imageFormat =
          imageFormat.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
    }
    Uint8List imageInBytes = const Base64Decoder().convert(imageFormat);
    return GetBuilder<Auth>(
      builder: (auth) {
        return ListTile(
          onTap: () {
            if (widget.onTapStatus == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UpdateProfileScreen()),
              );
            }
          },
          leading: Visibility(
            visible: imageInBytes.isNotEmpty,
            replacement: const CircleAvatar(
              backgroundColor: Colors.lightGreen,
              child: Icon(Icons.account_circle_outlined),
            ),
            child: CircleAvatar(
              backgroundImage: Image.memory(
                imageInBytes,
                fit: BoxFit.cover,
              ).image,
              backgroundColor: Colors.lightGreen,
            ),
          ),
          title: Text(
            userFullName(auth),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            auth.user?.email ?? '',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          trailing: IconButton(
            onPressed: () async {
              await Get.find<Auth>().clearUserAuthState();
              Get.offAll(LoginScreen());
            },
            icon: const Icon(Icons.logout,color: Colors.white,),
          ),
          tileColor: PrimaryColor.color,
        );
      }
    );
  }

  String userFullName(Auth auth) {
    return '${auth.user?.firstName ?? ''} ${auth.user?.lastName ?? ''}';
  }
}