import 'package:caiemca_app/functions.dart';
import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/btn.caiemca.button.widget.dart';
import 'package:flutter/material.dart';

Future<String?> showModalSearch({required BuildContext context, String hintText = 'Escribir algo...'}) {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController controller = TextEditingController();

  onSubmit()async{
     if(formKey.currentState!.validate()){
        try{
       Navigator.pop(context, controller.text);
    }catch(e){
      showTopSnackBar(context, message: e.toString(),color: Colors.red);
    }
     }
  }
  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      constraints: BoxConstraints(maxWidth: 300),
      child: Form(
        key: formKey,
        child: Container(
        padding: EdgeInsets.all(kDefaultPadding / 2),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'BUSCAR...',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: kPrimaryColor),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            TextFormField(
              controller: controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              validator: (val) => val!.isEmpty ? 'CAMPO OBLIGATORIO': null,
              onFieldSubmitted:(_) =>onSubmit(),
              decoration: InputDecoration(
                labelText: 'BUSCAR',
                hintText: hintText,
                suffixIcon: IconButton(
                  onPressed:onSubmit,
                  icon: Icon(Icons.search),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(
                vertical: kDefaultPadding/2
              ),
              width: double.infinity,
              height: 50,
              child: CaiemcaButtonWidget(
                title: 'BUSCAR',
                onPressed:onSubmit
              ),
            ),
          ],
        ),
      ))
    ),
  );
}
