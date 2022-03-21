import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/common/progressDialog.dart';
import 'package:shoutout24/model/userModel.dart';
import 'package:shoutout24/services/auth_service.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/view/authentication/login.dart';
import 'package:shoutout24/widgets/custom_input_decoration.dart';
import 'package:shoutout24/widgets/roundedShoutOut24Btn.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class SignUpPage extends StatefulWidget {
  final UserModel userModel;

  const SignUpPage({Key key, this.userModel}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _mobileNoController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  // final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _mobileNoFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  bool _passwordVisible = true;

  void _nameEditingComplete() {
    FocusScope.of(context).requestFocus(_emailFocusNode);
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_mobileNoFocusNode);
  }

  void _mobileNoEditingComplete() {
    FocusScope.of(context).requestFocus(
        widget.userModel == null ? _passwordFocusNode : _addressFocusNode);
  }

  void initState() {
    if (widget.userModel != null) {
      _emailController.text = widget.userModel.email;
      _nameController.text = widget.userModel.name;
      _addressController.text = widget.userModel.address;
      _mobileNoController.text = widget.userModel.mobileNo;
    }
    super.initState();
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        labelText: 'Name',
      ),
      keyboardType: TextInputType.name,
      controller: _nameController,
      textInputAction: TextInputAction.next,
      onEditingComplete: _nameEditingComplete,
      validator: (String value) {
        if (value.isEmpty) {
          return "Name is required";
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        labelText: 'Email Address',
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      focusNode: _emailFocusNode,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      validator: (String value) {
        if (value.isEmpty) {
          return "Email address is required";
        }
        return null;
      },
    );
  }

  Widget _buildMobileField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        labelText: 'Mobile Number',
      ),
      keyboardType: TextInputType.phone,
      controller: _mobileNoController,
      focusNode: _mobileNoFocusNode,
      textInputAction: TextInputAction.next,
      onEditingComplete: _mobileNoEditingComplete,
      validator: (String value) {
        if (value.isEmpty) {
          return "Mobile Number is required";
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        labelText: 'Address',
      ),
      keyboardType: TextInputType.name,
      controller: _addressController
        ..text =
            widget.userModel.address != null ? widget.userModel.address : "",
      textInputAction: TextInputAction.done,
      onEditingComplete: _nameEditingComplete,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: colorAccent)),
          filled: true,
          fillColor: Colors.white,
          hintText: "Password",
          suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                  print(_passwordVisible);
                });
              })),
      obscureText: _passwordVisible ? true : false,
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      onEditingComplete: () {},
      validator: (String value) {
        if (value.isEmpty) {
          return "Password is required";
        }
        return null;
      },
    );
  }

  void _showError(String error) {
    final snackBar = SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _showSuccess(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      // backgroundColor: Theme.of(context).errorColor,
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _clearInput() {
    _emailController.clear();
    _nameController.clear();
    _mobileNoController.clear();
    _passwordController.clear();
  }

  _handleUserUpdate(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
      context: context,
      builder: (dialogContext) => ProgressDialog(
        status: "Updating Details",
      ),
    );
    try {
      await DatabaseService().updateUserDetail(
          userModel: UserModel(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              address: _addressController.text.trim(),
              mobileNo: _mobileNoController.text.trim()));
      Navigator.pop(context);
      _showSuccess("Profile Updated Successfully");
      Timer(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/wrapper');
      });
      _clearInput();
      _addressController.clear();
    } catch (error) {
      Navigator.pop(context);
      _showError("An Error Has Occurred $error");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: widget.userModel != null
            ? customAppBar(title: "Edit Profile")
            : null,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => print('clicked'),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/images/avatar.png'),
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              // gradient: MyTheme.linearGradient,
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/images/camera.png",
                                height: 18,
                                width: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    VerticalSpacing(
                      height: 15.0,
                    ),
                    _buildNameField(),
                    VerticalSpacing(),
                    _buildEmailField(),
                    VerticalSpacing(),
                    _buildMobileField(),
                    VerticalSpacing(),
                    widget.userModel == null
                        ? _buildPasswordField()
                        : _buildAddressField(),
                    VerticalSpacing(
                      height: 20,
                    ),
                    widget.userModel == null
                        ? ShoutOut24Btn(
                            text: "Sign Up",
                            press: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              print(_emailController.text);
                              print(_nameController.text);
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                try {
                                  showDialog(
                                    context: context,
                                    builder: (dialogContext) => ProgressDialog(
                                      status:
                                          "Creating Account Please Wait ....",
                                    ),
                                  );
                                  UserCredential userCredential =
                                      await AuthService.signUpWithEmail(
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim());
                                  Navigator.pop(context);
                                  if (userCredential.user != null) {
                                    print("registered successfully");

                                    try {
                                      await DatabaseService.storeUser(
                                          uid: userCredential.user.uid,
                                          email: userCredential.user.email,
                                          mobileNo:
                                              _mobileNoController.text.trim(),
                                          name: _nameController.text.trim());
                                    } catch (error) {
                                      print('Error $error');
                                    }

                                    _showSuccess("Registered Successfully");

                                    Timer(Duration(seconds: 3), () {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/wrapper');
                                    });
                                  } else {
                                    print("unable to create user");
                                  }
                                } catch (e) {
                                  FirebaseAuthException fAE = e;
                                  print(fAE.message);
                                  print(fAE);
                                  _showError(fAE.message);
                                  print(e);
                                }
                              }
                            },
                          )
                        : ShoutOut24Btn(
                            text: "Update",
                            press: () {
                              _handleUserUpdate(context);
                            }),
                    VerticalSpacing(
                      height: 20,
                    ),
                    widget.userModel == null
                        ? Center(
                            child: RichText(
                              text: TextSpan(
                                  text: "Already have an account?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Login",
                                        style: TextStyle(
                                            color: colorPrimaryDark,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w400),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            print("login clicked");
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()));
                                          })
                                  ]),
                            ),
                          )
                        : Container(),
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
