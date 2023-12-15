
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/user_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../../style/styles.dart';
import '../controller/auth_controller.dart';
import '../controller/validation_input.dart';
import '../widgets/body_background.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/snack_message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailInputTEController = TextEditingController();
  final TextEditingController _firstNameInputTEController =
  TextEditingController();
  final TextEditingController _lastNameInputTEController =
  TextEditingController();
  final TextEditingController _mobileInputTEController =
  TextEditingController();
  final TextEditingController _passwordInputTEController =
  TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool updateProfileInProgress = false;
  XFile? photo;

  Auth auth = Get.find<Auth>();

  @override
  void initState() {
    super.initState();
    _emailInputTEController.text = auth.user?.email ?? '';
    _firstNameInputTEController.text = auth.user?.firstName ?? '';
    _lastNameInputTEController.text = auth.user?.lastName ?? '';
    _mobileInputTEController.text = auth.user?.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummeryCard(onTapStatus: false),
            Expanded(
              child: BodyBackGround(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          const Text("Update Profile",style: TextStyle(fontSize: 30),),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              showPhotoPickerBottomModal();
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Text(
                                          "Photo",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    flex: 3,
                                    child: Visibility(
                                      visible: photo == null,
                                      replacement: Text(
                                        photo?.name ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      child: Text(
                                        "Choose an Image",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailInputTEController,
                            decoration:
                            const InputDecoration(hintText: "Email"),
                            validator: FormValidation.emailValidation,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _firstNameInputTEController,
                            decoration:
                            const InputDecoration(hintText: "First Name"),
                            validator: FormValidation.inputValidation,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _lastNameInputTEController,
                            decoration:
                            const InputDecoration(hintText: "Last Name"),
                            validator: FormValidation.inputValidation,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _mobileInputTEController,
                            decoration: const InputDecoration(
                                hintText: "Mobile Number"),
                            validator: FormValidation.phoneNumberValidation,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordInputTEController,
                            decoration: const InputDecoration(
                                hintText: "Password (optional)"),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: Visibility(
                              visible: updateProfileInProgress == false,
                              replacement: Center(
                                child: CircularProgressIndicator(
                                  color: PrimaryColor.color,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: updateProfile,
                                child: const Icon(
                                    Icons.arrow_circle_right_outlined,color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    String? imageInBase64;

    if (_formKey.currentState!.validate()) {
      updateProfileInProgress = true;
      if (mounted) {
        setState(() {});
      }

      Map<String, dynamic> inputData = {
        "email": _emailInputTEController.text.trim(),
        "firstName": _firstNameInputTEController.text.trim(),
        "lastName": _lastNameInputTEController.text.trim(),
        "mobile": _mobileInputTEController.text.trim(),
      };
      if (_passwordInputTEController.text.isNotEmpty) {
        inputData["password"] = _passwordInputTEController.text;
      }
      if (photo != null) {
        List<int> imageInBytes = await photo!.readAsBytes();
        imageInBase64 = base64Encode(imageInBytes);
        inputData["photo"] = imageInBase64;
      }
      final NetworkResponse response =
      await NetworkCaller.postRequest(Urls.profileUpdate, body: inputData);
      updateProfileInProgress = false;
      if (mounted) {
        setState(() {});
      }
      if (response.isSuccess) {
        Get.find<Auth>().updateUserInformation(UserModel(
          email: _emailInputTEController.text.trim(),
          firstName: _firstNameInputTEController.text.trim(),
          lastName: _lastNameInputTEController.text.trim(),
          mobile: _mobileInputTEController.text.trim(),
          photo: imageInBase64 ?? auth.user?.photo,
        ));
        if (mounted) {
          SnackMsg(context, "Profile Updated Successfully!");
        }
      } else {
        if (mounted) {
          SnackMsg(context, "Action Failed! Please Try Again.", true);
        }
      }
    }
  }

  void showPhotoPickerBottomModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      final XFile? image = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 50,
                      );
                      if (image != null) {
                        photo = image;
                        if (mounted) {
                          Navigator.pop(context);
                          setState(() {});
                        }
                      }
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.image,
                          color: PrimaryColor.color,
                          size: 34,
                        ),
                        const Text(
                          "Gallery",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () async {
                      final XFile? image = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        imageQuality: 50,
                      );
                      if (image != null) {
                        photo = image;
                        if (mounted) {
                          Navigator.pop(context);
                          setState(() {});
                        }
                      }
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera,
                          color: PrimaryColor.color,
                          size: 34,
                        ),
                        const Text(
                          "Camera",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}