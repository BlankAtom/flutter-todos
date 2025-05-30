import 'package:flutter/material.dart';
import 'package:todo_list/i10n/localization_intl.dart';
import 'package:todo_list/model/login_page_model.dart';

import 'bottom_to_top_widget.dart';

class LoginWidget extends StatelessWidget {
  final LoginPageModel loginPageModel;

  const LoginWidget({required Key key, required this.loginPageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final primaryColorLight = Theme.of(context).primaryColorLight;
    final primaryColorDark = Theme.of(context).primaryColorDark;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      child: Form(
        key: loginPageModel.formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BottomToTopWidget(
                  child: TextFormField(
                    validator: (email) =>
                        loginPageModel.logic.validatorEmail(email ?? ''),
                    keyboardType: TextInputType.text,
                    controller: loginPageModel.emailController,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                        hintText: IntlLocalizations.of(context).inputEmail,
                        labelText: IntlLocalizations.of(context).email,
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () => Future.delayed(
                            Duration(milliseconds: 100),
                            () => loginPageModel.emailController?.clear(),
                          ),
                        )),
                  ),
                  index: 0,
                  key: GlobalKey(),
                ),
                BottomToTopWidget(
                  key: GlobalKey(),
                  child: TextFormField(
                    validator: (password) =>
                        loginPageModel.logic.validatePassword(password ?? ''),
                    controller: loginPageModel.passwordController,
                    keyboardType: TextInputType.text,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      hintText: IntlLocalizations.of(context).inputPassword,
                      labelText: IntlLocalizations.of(context).password,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                      suffixIcon: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                          backgroundColor: primaryColorLight,
                        ),
                        onPressed: loginPageModel.logic.onForget,
                        child: Text(
                          IntlLocalizations.of(context).forget,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    obscureText: true,
                  ),
                  index: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                BottomToTopWidget(
                  key: GlobalKey(),
                  index: 2,
                  child: Container(
                    height: 60,
                    width: size.width - 80,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(size.width - 80, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0)),
                      ),
                      child: Text(
                        IntlLocalizations.of(context).logIn,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: loginPageModel.logic.onLogin,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                BottomToTopWidget(
                  key: GlobalKey(),
                  index: 2,
                  child: Container(
                    height: 60,
                    width: size.width - 80,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor.withOpacity(0.3),
                        foregroundColor: Colors.white,
                        minimumSize: Size(size.width - 80, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            side: BorderSide(color: primaryColorDark)),
                      ),
                      child: Text(
                        IntlLocalizations.of(context).haveNoAccount,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: loginPageModel.logic.onRegister,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                loginPageModel.isFirst
                    ? BottomToTopWidget(
                        key: GlobalKey(),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                          child: Text(IntlLocalizations.of(context).skip),
                          onPressed: loginPageModel.logic.onSkip,
                        ),
                        index: 3)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
