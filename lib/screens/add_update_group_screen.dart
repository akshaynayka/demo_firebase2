import 'dart:io';

import '../common_methods/common_methods.dart';
import '../common_methods/field_validators.dart';
import '../helpers/groups_helper.dart';
import '../helpers/image_helper.dart';
import '../models/group.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/curved_header_container_widget.dart';
import '../widgets/loader_widget.dart';
import '../widgets/round_button_widget.dart';
import '../widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';

class AddUpdateGroupScreen extends StatefulWidget {
  const AddUpdateGroupScreen({super.key});

  @override
  State<AddUpdateGroupScreen> createState() => _AddUpdateGroupScreenState();
}

class _AddUpdateGroupScreenState extends State<AddUpdateGroupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Group _groupData = Group(
    id: null,
    name: null,
    createdAt: null,
    imageUrl: null,
  );
  File? _pickedImage;

  bool _isLoading = true;
  bool _isInit = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final args = ModalRoute.of(context)!.settings.arguments as Group?;
      if (args != null) {
        _groupData = args;
      }
      setState(() {
        _isLoading = false;
        _isInit = false;
      });
    }

    super.didChangeDependencies();
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

  _submitForm() async {
    final navigator = Navigator.of(context);
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (_pickedImage != null) {
      _groupData.imageUrl = await ImageHelper()
          .uploadImage(directoryName: 'groupimages', imageFile: _pickedImage!);
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final status =
          await GroupsHelper().createUpdateGroup(groupData: _groupData);

      if (mounted) displaySnackbar(context: context, msg: status);

      navigator.pop();
    } catch (error) {
      var message = 'Something went wrong!';
      if (mounted) displaySnackbar(context: context, msg: message);
    }
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
                    CurvedHeaderConyainerWidget(
                        title:
                            '${_groupData.id != null ? 'Update' : 'Create'} Group'),
                    _profileImageContainer(imageUrl: _groupData.imageUrl),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30.0),
                      child: TextFormFieldWidget(
                        initialValue: _groupData.name,
                        lableText: 'Name',
                        icon: Icons.group_outlined,
                        validator: nameValidator,
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          _groupData.name = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    RoundButtonWidget(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      onPressed: _submitForm,
                      label: _groupData.id != null ? 'Update' : 'Create',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
