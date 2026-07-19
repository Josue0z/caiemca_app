

import 'package:caiemca_app/settings.dart';
import 'package:flutter/material.dart';

Future<void> showLoader({required BuildContext context})async{
  showDialog(context: context,
  barrierDismissible: false,
   builder: (ctx) => Dialog(
    
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(kBorderRadius)
    ),
    constraints: BoxConstraints(
      maxWidth: 100,
      maxHeight: 100
    ),
    child: SizedBox(
      width: double.infinity,
      height: 100,
      child: Center(
        child: CircularProgressIndicator()
      ),
    ),
  ));
}



void showTopSnackBar(BuildContext context,
    {required String message,
    Color color = Colors.black,
    Color fontColor = Colors.white}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  final animationController = AnimationController(
    vsync: Navigator.of(context),
    duration: Duration(milliseconds: 200),
  );
  final animation =
      Tween<double>(begin: -50, end: 50).animate(animationController);

  overlayEntry = OverlayEntry(
    builder: (context) => AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Positioned(
        top: animation.value,
        left: 20,
        right: 20,
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          color: color,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    message,
                    style: TextStyle(color: fontColor, fontSize: 16),
                  )),
                  IconButton(
                      onPressed: () {
                        animationController.reverse().then((_) {
                          overlayEntry.remove();
                          animationController.dispose();
                        });
                      },
                      icon: Icon(Icons.close, color: Colors.white))
                ],
              )),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Iniciar la animación
  animationController.forward();

  // Remover el SnackBar después de unos segundos

  Future.delayed(Duration(seconds: 5), () {
    if (animationController.isForwardOrCompleted) {
      animationController.reverse().then((_) {
        overlayEntry.remove();
        animationController.dispose();
      });
    }
  });
}