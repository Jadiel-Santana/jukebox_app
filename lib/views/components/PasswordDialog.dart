import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jukebox_app/support/components/AppButton.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';

class PasswordDialog extends StatelessWidget {
  final Key formKey;
  final bool autoValidate;
  final String labelEmail;
  final String labelPassword;
  final TextEditingController controllerEmail;
  final TextEditingController controllerPassword;
  final StreamController<bool> ctrlObscure;
  final Function onPressed;

  PasswordDialog({this.formKey, this.labelEmail, this.labelPassword, this.autoValidate = false, this.controllerEmail, this.controllerPassword, this.ctrlObscure, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: this.formKey,
      autovalidate: this.autoValidate,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              CircleAvatar(child: Icon(Icons.lock, size: 30, color: AppColors.white,), radius: 30, backgroundColor: AppColors.green),
              SizedBox(height: 10),
              Text('Redefinir Senha', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                child: TextFormField(
                  controller: this.controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: (value) => value.isEmpty ? this.labelEmail : null,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(),
                    hintText: this.labelEmail,
                    labelText: this.labelEmail,
                    prefixIcon: Icon(Icons.email, size: 20,),
                    hintStyle: TextStyle(fontSize: 13),
                    labelStyle: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              StreamBuilder<bool>(
                stream: ctrlObscure.stream,
                initialData: true,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: TextFormField(
                      controller: this.controllerPassword,
                      keyboardType: TextInputType.text,
                      obscureText: snapshot.data,
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                      value.isEmpty ? this.labelPassword : null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(),
                        hintText: this.labelPassword,
                        labelText: this.labelPassword,
                        prefixIcon: Icon(Icons.lock, size: 20,),
                        hintStyle: TextStyle(fontSize: 13),
                        labelStyle: TextStyle(fontSize: 13),
                        suffixIcon: IconButton(
                          icon: Icon(snapshot.data ? Icons.visibility : Icons.visibility_off, size: 20,),
                          onPressed: () => ctrlObscure.add(!snapshot.data),),
                      ),
                    ),
                  );
                }
              ),
              AppButton(
                id: 'btnResetPassword',
                title: 'Salvar',
                icon: Icons.check,
                color: AppColors.blueDark,
                onPressed: this.onPressed,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}