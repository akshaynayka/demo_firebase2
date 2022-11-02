import '../common_methods/common_methods.dart';
import '../common_methods/field_validators.dart';
import '../helpers/image_helper.dart';
import '../helpers/user_helper.dart';
import '../models/user.dart' as user;
import '../values/collections.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/curved_header_container_widget.dart';
import '../widgets/loader_widget.dart';
import '../widgets/round_button_widget.dart';
import '../widgets/text_form_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _pickedImage;

  user.User? _currentUserData;
  bool _isLoading = true;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    setState(() {
      _isLoading = true;
    });
    _currentUserData = await UsersHelper().getCurrentUserData();
    setState(() {
      _isLoading = false;
    });
  }

  Widget _profileImageContainer({String? imageUrl}) {
    return Stack(
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          decoration: BoxDecoration(
            border: Border.all(
              width: 4,
              color: Theme.of(context).primaryColor,
            ),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 10)),
            ],
            image: imageUrl == null && _pickedImage == null
                ? null
                : DecorationImage(
                    fit: BoxFit.cover,
                    image: _pickedImage != null
                        ? FileImage(_pickedImage!) as ImageProvider
                        : NetworkImage(imageUrl!),
                  ),
            shape: BoxShape.circle,
          ),
          child: imageUrl == null && _pickedImage == null
              ? Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey[600],
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: Theme.of(context).primaryColor,
              ),
              color: Colors.white,
            ),
            child: GestureDetector(
              child: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
                size: 19,
              ),
              onTap: () async {
                final pickedImage = await ImageHelper().chooseFile();
                if (pickedImage != null) {
                  setState(() {
                    _pickedImage = pickedImage;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_pickedImage != null) {
      _currentUserData!.imageUrl = await ImageHelper()
          .uploadImage(directoryName: 'userimages', imageFile: _pickedImage!);
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_currentUserData!.id != null) {
        final userInstance = FirebaseFirestore.instance
            .collection(collectionUsers)
            .doc(_currentUserData!.id);
        await userInstance.update(_currentUserData!.toJson());
      }

      if (!mounted) return;
      displaySnackbar(context: context, msg: 'Profile Updated');
      Navigator.of(context).pop();
    } catch (error) {
      const errorMessage = 'Something went wrong';
      if (mounted) {
        showErrorDialog(errorMessage, context);
      }
    }

    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        elevation: 0,
      ),
      body: _isLoading
          ? const LoaderWidget()
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const CurvedHeaderConyainerWidget(
                      title: 'My Profile',
                    ),
                    _profileImageContainer(
                        imageUrl: _currentUserData?.imageUrl),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20.0),
                      child: TextFormFieldWidget(
                        lableText: 'Name',
                        initialValue: _currentUserData!.name,
                        icon: Icons.group_outlined,
                        validator: nameValidator,
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _currentUserData!.name = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5.0),
                      child: TextFormFieldWidget(
                        lableText: 'Email',
                        initialValue: _currentUserData!.email,
                        icon: Icons.group_outlined,
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    RoundButtonWidget(
                      label: 'Update Profile',
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
