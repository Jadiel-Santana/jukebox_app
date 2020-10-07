import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jukebox_app/domains/bloc/AuthBloc.dart';
import 'package:jukebox_app/domains/model/User.dart';
import 'package:jukebox_app/support/components/AppButton.dart';
import 'package:jukebox_app/support/components/CircularProgress.dart';
import 'package:jukebox_app/support/components/Toolbar.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';
import 'package:jukebox_app/support/utils/DateUtils.dart';
import 'package:jukebox_app/support/utils/Navigation.dart';
import 'package:jukebox_app/support/utils/NotificationMessage.dart';
import 'package:jukebox_app/support/utils/StringUtils.dart';
import 'package:jukebox_app/views/pages/HomePage.dart';
import 'package:jukebox_app/views/pages/SignIn.dart';

class SignUp extends StatefulWidget { @override _SignUpState createState() => _SignUpState(); }

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _ctrlValidator = StreamController<bool>.broadcast();
  final _ctrlObscureText = StreamController<bool>.broadcast();
  final _nameController = TextEditingController(text: '');
  final _dateController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: Toolbar(
        title: 'Criar minha conta',
        iconActionVisible: false,
      ),
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
                    SizedBox(height: 10),
                    Image.asset('assets/images/jukebox.png', width: 300, height: 40,),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                              child: TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.sentences,
                                textInputAction: TextInputAction.done,
                                validator: (value) => value.isEmpty ? 'Favor digitar um nome' : null,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(),
                                  hintText: 'Digite seu nome',
                                  labelText: 'Digite seu nome',
                                  prefixIcon: Icon(Icons.person, size: 20,),
                                  hintStyle: TextStyle(fontSize: 13),
                                  labelStyle: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                              child: TextFormField(
                                controller: _dateController,
                                keyboardType: TextInputType.text,
                                readOnly: true,
                                textInputAction: TextInputAction.done,
                                validator: (value) => value.isEmpty ? 'Favor selecione a data de nascimento' : null,
                                onTap: () => _selectDate(context, _dateController),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(),
                                  hintText: 'Data de nascimento',
                                  labelText: 'Data de nascimento',
                                  prefixIcon: Icon(Icons.date_range, size: 20,),
                                  hintStyle: TextStyle(fontSize: 13),
                                  labelStyle: TextStyle(fontSize: 13),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                validator: (value) => value.isEmpty ? 'Favor digitar um email' : null,
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
                                          value.isEmpty ? 'Favor digitar uma senha' : null,
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
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: StreamBuilder<bool>(
                                stream: _authBloc.stream,
                                initialData: false,
                                builder: (context, snapshot) =>
                                snapshot.data ? CircularProgress() :
                                AppButton(
                                  id: 'btnSave',
                                  title: 'Salvar',
                                  icon: Icons.save,
                                  color: AppColors.blueDark,
                                  onPressed: _signUp,
                                ),
                              ),
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
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: AppButton(
                            id: 'btnBackSignIn',
                            title: 'Já tenho uma conta',
                            color: AppColors.accent,
                            icon: Icons.keyboard_backspace,
                            onPressed: () => next(context, SignIn(), replacement: true),
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

  Future<void> _selectDate(context, TextEditingController controller) async {
    DateTime _date = DateTime.now();
    if(controller.text.isNotEmpty) { _date = DateUtils.instance.stringToDate(controller.text); }
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      helpText: 'SELECIONE UMA DATA',
      confirmText: 'SELECIONAR',
      cancelText: 'CANCELAR',
      errorFormatText: 'Data inválida',
      fieldLabelText: 'Digite uma data',
      fieldHintText: 'dd/mm/aaaa',
      errorInvalidText: 'Escolha uma data entre ${DateTime.now().year - 80} e ${DateTime.now().year}',
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime(DateTime.now().year - 80),
      lastDate: DateTime(DateTime.now().year + 1));
    if (picked != null) { controller.text = DateUtils.instance.dateToString(picked); }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      var _user = User(
        name: _nameController.text,
        email: _emailController.text,
        password: md5.convert(utf8.encode(_passwordController.text)).toString(),
        birthday: _dateController.text,
      );
      String _result = await _authBloc.signUp(_user);
      (_result.startsWith(StringUtils.OK)) ? next(context, HomePage(), replacement: true)
        : NotificationMessage.instance.warning(context, _result);
    }
    else { _ctrlValidator.add(true);}
  }

  @override
  void dispose() {
    super.dispose();
    _ctrlValidator.close();
    _ctrlObscureText.close();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dateController.dispose();
    _authBloc.dispose();
  }
}