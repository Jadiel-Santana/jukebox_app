import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jukebox_app/support/components/AppButton.dart';
import 'package:jukebox_app/support/utils/AppColors.dart';

class HashDialog extends StatefulWidget {
  final Function(String) onPressed;
  HashDialog({this.onPressed});
  @override _HashDialogState createState() => _HashDialogState();
}

class _HashDialogState extends State<HashDialog> {
  final _controller = TextEditingController(text: '');
  final _formKeyReset = GlobalKey<FormState>();
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeyReset,
      autovalidate: _validate,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Container(
          width: 200,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(child: Icon(Icons.security, size: 35, color: AppColors.white), radius: 30, backgroundColor: AppColors.purple),
              SizedBox(height: 10),
              Text('Digite a Hash', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                child: TextFormField(
                  controller: _controller,
                  validator: (value) => value.isEmpty ? 'Favor digitar a Hash' : null,
                  maxLines: 2,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    hintText: 'Hash',
                    labelText: 'Hash',
                    hintStyle: TextStyle(fontSize: 13),
                    labelStyle: TextStyle(fontSize: 13),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.security, size: 18),
                  ),
                ),
              ),
              AppButton(
                id: 'btnHash',
                title: 'Salvar',
                icon: Icons.check,
                color: AppColors.blueDark,
                onPressed:() {
                  if (_formKeyReset.currentState.validate()) {
                    _formKeyReset.currentState.save();
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    this.widget.onPressed(_controller.text);
                  }
                  else { setState(() => _validate = true); }
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}