import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jukebox_app/domains/model/HashModel.dart';
import 'package:jukebox_app/domains/bloc/AuthBloc.dart';
import 'package:jukebox_app/domains/service/AuthService.dart';
import 'package:jukebox_app/support/components/AppButton.dart';
import 'package:jukebox_app/support/components/CircularProgress.dart';
import 'package:jukebox_app/support/components/Toolbar.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';
import 'package:jukebox_app/support/utils/Navigation.dart';
import 'package:jukebox_app/support/utils/NotificationMessage.dart';
import 'package:jukebox_app/support/utils/StringUtils.dart';
import 'package:jukebox_app/views/components/HashDialog.dart';
import 'package:jukebox_app/views/components/PasswordDialog.dart';
import 'package:jukebox_app/views/pages/UserList.dart';
import 'package:jukebox_app/views/pages/UserForm.dart';

class SignIn extends StatefulWidget { @override _SignInState createState() => _SignInState(); }

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyReset = GlobalKey<FormState>();
  bool _autoValidateReset = false;
  final _ctrlValidator = StreamController<bool>.broadcast();
  final _ctrlObscureText = StreamController<bool>.broadcast();
  final _ctrlObscureTextReset = StreamController<bool>.broadcast();
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _emailResetController = TextEditingController(text: '');
  final _passwordResetController = TextEditingController(text: '');
  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: Toolbar(title: 'Seja bem-vindo(a)', iconActionVisible: false,),
      body: Center(
        child: SingleChildScrollView(
          child: StreamBuilder<bool>(
            initialData: false,
            stream: _ctrlValidator.stream,
            builder: (context, snapshot) {
              return (!snapshot.hasData) ? CircularProgress() :
              Form(
                key: _formKey,
                autovalidate: snapshot.data,
                child: Column(
                  children: [
                    Image.asset('assets/images/jukebox.png', width: 300, height: 40,),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: (value) => value.isEmpty ? 'Favor digitar um email.' : null,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(),
                                  hintText: 'Digite seu email',
                                  labelText: 'Digite seu email',
                                  prefixIcon: Icon(Icons.email, size: 20,),
                                  hintStyle: TextStyle(fontSize: 13),
                                  labelStyle: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                            StreamBuilder<bool>(
                                    stream: _ctrlObscureText.stream,
                                    initialData: true,
                                    builder: (context, snapshot) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                                        child: TextFormField(
                                          controller: _passwordController,
                                          keyboardType: TextInputType.text,
                                          obscureText: snapshot.data,
                                          textInputAction: TextInputAction.done,
                                          validator: (value) =>
                                          value.isEmpty ? 'Favor digitar uma senha.' : null,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.zero,
                                            border: OutlineInputBorder(),
                                            hintText: 'Digite sua senha',
                                            labelText: 'Digite sua senha',
                                            prefixIcon: Icon(Icons.lock, size: 20,),
                                            hintStyle: TextStyle(fontSize: 13),
                                            labelStyle: TextStyle(fontSize: 13),
                                            suffixIcon: IconButton(
                                              icon: Icon(snapshot.data ? Icons.visibility : Icons.visibility_off, size: 20,),
                                              onPressed: () => _ctrlObscureText.add(!snapshot.data),),
                                          ),
                                        ),
                                      );
                                    }
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AppButton(
                                  id: 'btnSignUp',
                                  title: 'Cadastrar',
                                  icon: Icons.add,
                                  color: AppColors.green,
                                  onPressed: () => next(context, UserForm(fromLogin: true,), replacement: true),
                                ),
                                StreamBuilder<bool>(
                                  stream: _authBloc.streamLoad,
                                  initialData: false,
                                  builder: (context, snapshot) =>
                                    snapshot.data ? CircularProgress() :
                                    AppButton(
                                      id: 'btnSignIn',
                                      title: 'Entrar',
                                      icon: Icons.arrow_forward,
                                      color: AppColors.blueDark,
                                      onPressed: _signIn,
                                    ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                                  child: GestureDetector(
                                    child: Text('Esqueceu a senha?', textAlign: TextAlign.end, style: TextStyle(fontSize: 14, color: AppColors.blue, decoration: TextDecoration.underline),),
                                    onTap: _openAlertBox,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                          child: AppButton(
                            id: 'btnHash',
                            title: 'Alterar Hash',
                            color: AppColors.purple,
                            icon: Icons.settings,
                            onPressed: _hashDialog,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      String _result = await _authBloc.signIn(
        _emailController.text,
        md5.convert(utf8.encode(_passwordController.text)).toString(),
      );
      (_result.startsWith(StringUtils.OK)) ? next(context, UserList(), replacement: true)
        : NotificationMessage.instance.warning(context, _result);
    }
    else { _ctrlValidator.add(true);}
  }

  _openAlertBox() {
    return showDialog(
      context: context,
      builder: (BuildContext contextM) => PasswordDialog(
        formKey: _formKeyReset,
        labelEmail: 'Digite seu email',
        labelPassword: 'Digite sua nova senha',
        autoValidate: _autoValidateReset,
        controllerPassword: _passwordResetController,
        controllerEmail: _emailResetController,
        ctrlObscure: _ctrlObscureTextReset,
        onPressed: () async {
          if (_formKeyReset.currentState.validate()) {
            _formKeyReset.currentState.save();
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            String _result = await _authBloc.changePassword(
              _emailResetController.text,
              md5.convert(utf8.encode(_passwordResetController.text)).toString(),
            );
            if(_result.startsWith(StringUtils.OK)){
              back(contextM);
              NotificationMessage.instance.success(contextM, 'Senha alterada com sucesso');
            } else {
              NotificationMessage.instance.warning(contextM, _result);
            }
          }
          else{ setState(() { _autoValidateReset = true; }); }
        }
      )
    );
  }

  _hashDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext buildContext) => HashDialog(
        onPressed: (String hash) {
          back(buildContext);
          var _hash = HashModel(hash: hash);
          _hash.store();
          hashUsed = _hash;
        },),);
  }

  @override
  void dispose() {
    super.dispose();
    _ctrlValidator.close();
    _ctrlObscureText.close();
    _emailController.dispose();
    _passwordController.dispose();
    _ctrlObscureTextReset.close();
    _emailResetController.dispose();
    _passwordResetController.dispose();
    _authBloc.dispose();
  }
}