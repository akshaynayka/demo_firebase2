import '../common_methods/common_methods.dart';
import '../common_methods/field_validators.dart';
import '../helpers/user_helper.dart';
import '../models/user.dart' as user;
import '../values/collections.dart';
import '../values/colors.dart';
import '../widgets/loader_widget.dart';
import '../widgets/round_button_widget.dart';
import '../widgets/text_form_field_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  final user.User _userData = user.User(
      id: null, email: null, imageUrl: null, password: null, name: null);

  bool _isSignUp = false;
  _submitAuthForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try {
      setState(() {
        _isLoading = true;
      });
      if (_isSignUp) {
        final authUser = await _auth.createUserWithEmailAndPassword(
            email: _userData.email!, password: _userData.password!);

        _userData.id = authUser.user!.uid;

        await UsersHelper().createUser(userData: _userData);
      } else {
        await _auth.signInWithEmailAndPassword(
            email: _userData.email!, password: _userData.password!);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occurred, please check your credentials';

      displaySnackbar(context: context, msg: message);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignInAccount? userSignin;

    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>[
      "email",
    ]);
    userSignin = await googleSignIn.signIn();
    if (userSignin == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final authntication = await userSignin.authentication;
    OAuthCredential? credential;
    credential = GoogleAuthProvider.credential(
        idToken: authntication.idToken, accessToken: authntication.accessToken);

    final authData = await auth.signInWithCredential(credential);

    final userDetails = await FirebaseFirestore.instance
        .collection(collectionUsers)
        .doc(authData.user!.uid)
        .get();
    if (userDetails.exists) return;
    _userData.id = authData.user!.uid;
    _userData.email = authData.user!.email;
    _userData.name = authData.user!.displayName;
    _userData.imageUrl = authData.user!.photoURL;
    await UsersHelper().createUser(userData: _userData);
  }

  @override
  Widget build(BuildContext context) {
    const textFieldPadding =
        EdgeInsets.symmetric(horizontal: 20, vertical: 7.0);
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const LoaderWidget()
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Theme.of(context).primaryColor,
                                  secondGradientColor,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Container(
                                height: 110.0,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3.0,
                                    )),
                                child: const FlutterLogo(
                                  size: 70,
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 35.0,
                            right: 40.0,
                            child: Text(
                              'Chat App',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      if (_isSignUp)
                        Padding(
                          padding: textFieldPadding,
                          child: TextFormFieldWidget(
                            lableText: 'Name',
                            icon: Icons.group_outlined,
                            validator: nameValidator,
                            textInputAction: TextInputAction.next,
                            onSaved: (value) {
                              _userData.name = value;
                            },
                          ),
                        ),
                      Padding(
                        padding: textFieldPadding,
                        child: TextFormFieldWidget(
                          lableText: 'Email',
                          icon: Icons.email_outlined,
                          validator: requiredEmailValidator,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) {
                            _userData.email = removeSpaceFromString(value!);
                          },
                        ),
                      ),
                      Padding(
                        padding: textFieldPadding,
                        child: TextFormFieldWidget(
                          lableText: 'Password',
                          obscureText: true,
                          icon: Icons.lock_outline,
                          validator: nameValidator,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) {
                            _userData.password = value;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      RoundButtonWidget(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        label: _isSignUp ? 'SignUp' : 'Login',
                        onPressed: _submitAuthForm,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundButtonWidget(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        label: 'login with google',
                        onPressed: _signInWithGoogle,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isSignUp = !_isSignUp;
                          });
                        },
                        child: Text(
                          !_isSignUp
                              ? 'Don\'t have an account? SignUp'
                              : 'already have an account? Login',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
