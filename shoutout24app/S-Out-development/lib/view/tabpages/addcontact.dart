import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/common/customdialog.dart';
import 'package:shoutout24/common/progressDialog.dart';
import 'package:shoutout24/model/contactModel.dart';
import 'package:shoutout24/services/database.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/widgets/custom_input_decoration.dart';
import 'package:shoutout24/widgets/roundedShoutOut24Btn.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class AddContact extends StatefulWidget {
  final ContactModel contactModel;

  const AddContact({Key key, this.contactModel}) : super(key: key);
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _mobileNoController = TextEditingController();

  final FocusNode _mobileNoFocusNode = FocusNode();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'ZA';
  PhoneNumber number = PhoneNumber(dialCode: 'ZA');
  String _phoneNumber;
  bool _isPhoneNumberValid;

  void _nameEditingComplete() {
    FocusScope.of(context).requestFocus(_mobileNoFocusNode);
  }

  @override
  void dispose() {
    _mobileNoController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: CustomInputDecoration(
        labelText: 'Name',
      ),
      keyboardType: TextInputType.name,
      controller: _nameController
        ..text = widget.contactModel != null ? widget.contactModel.name : "",
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

  Widget _internationalMobile() {
    return Container(
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(border: Border.all(color: colorAccent)),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          print(number.phoneNumber);
          print(number.dialCode);
          print(number.isoCode);

          _phoneNumber = number.phoneNumber;
        },
        onInputValidated: (bool value) {
          value ? _isPhoneNumberValid = true : _isPhoneNumberValid = false;
          print(value);
        },
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        ),
        ignoreBlank: false,
        autoValidateMode: AutovalidateMode.disabled,
        selectorTextStyle: TextStyle(color: Colors.black),
        initialValue: number,
        textFieldController: _mobileNoController
          ..text =
              widget.contactModel != null ? widget.contactModel.mobileNo : "",
        hintText: "Mobile Number",
        formatInput: false,
        countries: ['ZA'],
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder: InputBorder.none,
        onSaved: (PhoneNumber number) {
          print('On Saved:  $number');
        },
      ),
    );
  }

  _handleContactCreation(BuildContext context) async {
    print(_mobileNoController.text);
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        status: "Adding Contact",
      ),
    );
    try {
      var res = await DatabaseService().createContact(
          contactModel:
              ContactModel(name: _nameController.text, mobileNo: _phoneNumber));
      Navigator.pop(context);
      Navigator.pop(context);

      if (res != null) {
        _nameController.clear();
        _mobileNoController.clear();
      }
    } catch (e) {
      Navigator.pop(context);
      print("Try Catch $e");
    }
  }

  _handleContactUpdate(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => ProgressDialog(
        status: "Editing Contact",
      ),
    );
    try {
      await DatabaseService().updateContact(
          contactModel:
              ContactModel(name: _nameController.text, mobileNo: _phoneNumber),
          contactId: widget.contactModel.id);
      // loader
      Navigator.pop(context);
      // showDialog(
      //     context: context,
      //     barrierDismissible: false,
      //     builder: (dialogContext) => CustomDialog(
      //           icon: FontAwesome5.check_circle,
      //           title: "Success",
      //           description: "Contact Edited Successfully",
      //           cancelButtonText: "Ok",
      //           okayPress: () {
      //             Navigator.pop(dialogContext);
      //           },
      //         ));
      // exit page
      Navigator.pop(context);
    } catch (error) {
      print(error);
      Navigator.pop(context);
    }
  }

  showErrorDialog({String message}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => CustomDialog(
              icon: FontAwesome.info,
              title: "Error",
              description: message,
              cancelButtonText: "Ok",
              okayPress: () {
                Navigator.pop(dialogContext);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(
            title:
                widget.contactModel == null ? "New Contact" : "Edit Contact"),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNameField(),
              // VerticalSpacing(
              //   height: 20,
              // ),
              // _buildMobileField(),
              VerticalSpacing(
                height: 20,
              ),
              _internationalMobile(),
              VerticalSpacing(
                height: 20,
              ),
              widget.contactModel == null
                  ? ShoutOut24Btn(
                      text: "Add Contact",
                      press: () async {
                        if (_nameController.text.isEmpty) {
                          showErrorDialog(message: "Provide Contact Name");
                          return;
                        }
                        if (!_isPhoneNumberValid) {
                          showErrorDialog(message: "Invalid Phone Number");
                          return;
                        }
                        _handleContactCreation(context);
                      },
                    )
                  : ShoutOut24Btn(
                      text: "Update Contact",
                      press: () => _handleContactUpdate(context),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
