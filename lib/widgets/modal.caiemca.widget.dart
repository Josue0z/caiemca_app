


import 'package:caiemca_app/settings.dart';
import 'package:caiemca_app/widgets/btn.caiemca.button.widget.dart';
import 'package:flutter/material.dart';

class ModalCaiemcaWidget extends StatelessWidget {
  String title;
  String btnTitle;
  double width;
  double height;
  VoidCallback? onSubmit;
  List<Widget> children;
  ModalCaiemcaWidget({super.key,this.title = 'TITLE', this.btnTitle = 'CONFIRMAR', this.width = 300,this.height = 400,
  this.onSubmit,this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: width,
        height: height,
        child: Padding(padding: EdgeInsets.all(kDefaultPadding),child: Column(
          children: [
            SizedBox(
            
              child: Row(
              children: [
                Expanded(child: Text(title,style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600
                ))),
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.close))
              ],
            ),
            ),
            SizedBox(
              height: kDefaultPadding/2
            ),
            Expanded(child: ListView(
              children:children
            )),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: CaiemcaButtonWidget(
                title: btnTitle,
                onPressed: onSubmit
              ),
            )
          ],
        ))
        
      ),
    );
  }
}