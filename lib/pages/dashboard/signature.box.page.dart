
import 'dart:convert';
import 'dart:typed_data';

import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/models/forms/form.ciaemca.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/btn.caiemca.button.widget.dart';
import 'package:caiemca_app/widgets/canvas_painter.dart';
import 'package:flutter/material.dart';

class SignatureBoxPage extends StatefulWidget {
  final FormCaiemca form;
  const SignatureBoxPage({super.key, required this.form});

  @override
  State<SignatureBoxPage> createState() => _SignatureBoxPageState();
}

class _SignatureBoxPageState extends State<SignatureBoxPage> {
  Uint8List? signatureResponsableBytes;
  Uint8List? clientSignatureBytes;
  _onSubmit() async {
    showLoader(context: context);
    try{
       if(signatureResponsableBytes != null && clientSignatureBytes != null){
       final form = widget.form;
      form.signatureResponsible = base64Encode(signatureResponsableBytes!);
      form.clientSignature = base64Encode(clientSignatureBytes!);
      await form.signatureFormPdf();
      Navigator.pop(context);
      Navigator.pop(context,form);
    }
    }catch(e){
      Navigator.pop(context);
      showTopSnackBar(context, message: e.toString(),color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.form.formNumber ?? '',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(kDefaultPadding),
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Firma Trabajador',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: kPrimaryColor),
            ),

            Text(widget.form.workerName ?? ''),
            SizedBox(height: kDefaultPadding / 2),
            CalligraphyCanvas(size: Size(size.width, 250),onFinish: (bytes){
                 if(bytes != null){
                   signatureResponsableBytes = bytes;
                 }
            }),
            SizedBox(height: kDefaultPadding),
            Text(
              'Firma Responsable',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: kPrimaryColor),
            ),
            Text(widget.form.responsibleName ?? ''),
            SizedBox(height: kDefaultPadding / 2),
            CalligraphyCanvas(size: Size(size.width, 250),onFinish: (bytes){
              if(bytes != null){
                clientSignatureBytes = bytes;
              }
            }),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(kDefaultPadding),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: CaiemcaButtonWidget(title: 'FIRMAR', onPressed: _onSubmit),
        ),
      ),
    );
  }
}
