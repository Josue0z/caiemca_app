import 'package:caiemca_app/models/devices/device.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

void showQrModal(BuildContext context, DeviceCaiemca device) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext ctx) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Código QR del dispositivo\n${device.brandName} ${device.modelName}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Widget QR
            RepaintBoundary(
              key: GlobalKey(),
              child: QrImageView(
                data: device.serialNumber ?? '',
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton.icon(
              icon: Icon(Icons.share,color: Colors.white),
              label: Text("Compartir QR",style: TextStyle(
                color: Colors.white
              ),),
              onPressed: () async {
                // Generar imagen del QR para compartir
                final qrPainter = QrPainter(
                  data: device.serialNumber ?? '',
                  version: QrVersions.auto,
                  gapless: true,
                );
                final picData = await qrPainter.toImageData(300);
                final bytes = picData!.buffer.asUint8List();

                // Compartir como archivo temporal
                final tempPath = '${DateTime.now().millisecondsSinceEpoch}.png';
                final xFile = XFile.fromData(
                  bytes,
                  mimeType: 'image/png',
                  name: tempPath,
                );
                await Share.shareXFiles([xFile], text: "QR del dispositivo ${device.serialNumber}");
              },
            ),
            )
          ],
        ),
      );
    },
  );
}
