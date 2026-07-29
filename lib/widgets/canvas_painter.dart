import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CalligraphyPainter extends CustomPainter {
  final Paint painter;
  final List<List<Offset>> strokes;

  CalligraphyPainter({required this.strokes, required this.painter});

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, painter);
    }
  }

  @override
  bool shouldRepaint(CalligraphyPainter oldDelegate) => true;
}

class CalligraphyCanvas extends StatefulWidget {
  final Size size;
  Function(Uint8List?) onFinish;
  CalligraphyCanvas({super.key, required this.size, required this.onFinish});

  @override
  _CalligraphyCanvasState createState() => _CalligraphyCanvasState();
}

class _CalligraphyCanvasState extends State<CalligraphyCanvas> {
  List<List<Offset>> strokes = [];
  List<Offset> currentStroke = [];
  Paint? painter;
  final GlobalKey _canvasKey = GlobalKey();

  void _clearCanvas() {
    setState(() {
      strokes.clear();
      currentStroke.clear();
    });
  }

Future<Uint8List?> exportSignature() async {
  try {
    RenderRepaintBoundary boundary =
        _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    // Convierte a bytes
    ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Calcula el bounding box de los strokes
    double minX = double.infinity, minY = double.infinity;
    double maxX = double.negativeInfinity, maxY = double.negativeInfinity;

    for (var stroke in strokes) {
      for (var point in stroke) {
        if (point.dx < minX) minX = point.dx;
        if (point.dy < minY) minY = point.dy;
        if (point.dx > maxX) maxX = point.dx;
        if (point.dy > maxY) maxY = point.dy;
      }
    }

    // Aquí puedes usar librerías como `image` (paquete pub.dev) para recortar
    // el PNG a ese rectángulo (minX, minY, maxX, maxY).
    // Ejemplo con package:image:
    // import 'package:image/image.dart' as img;
    // final decoded = img.decodeImage(pngBytes)!;
    // final cropped = img.copyCrop(decoded, minX.toInt(), minY.toInt(),
    //     (maxX - minX).toInt(), (maxY - minY).toInt());
    // final croppedBytes = Uint8List.fromList(img.encodePng(cropped));

    return pngBytes; // o croppedBytes si aplicas el recorte
  } catch (e) {
    print("Error exportando firma: $e");
    return null;
  }
}


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: RepaintBoundary(
        key: _canvasKey,
        child: ClipRect(
          // evita que los trazos se salgan del área
          child: SizedBox(
            height: widget.size.height,
            width: widget.size.width,

            child: GestureDetector(
              behavior:
                  HitTestBehavior.opaque, // captura todo el área, evita scroll
              onPanStart: (details) {
                painter = Paint()
                  ..color = const ui.Color(0xFF0D7CD7)
                  ..style = PaintingStyle.stroke
                  ..strokeCap = StrokeCap.round
                  ..strokeWidth = 2;
                setState(() {
                  currentStroke = [details.localPosition];
                  strokes.add(currentStroke);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  final velocity = details.delta.distance;
                  // lógica original de presión/ángulo
                  painter!.strokeWidth = (velocity * 0.8).clamp(1, 2);
                  currentStroke.add(details.localPosition);
                });
              },
              onPanEnd: (details) async {
                final data = await exportSignature();
                setState(() {
                  currentStroke = [];
                });
                widget.onFinish(data);
              },
              child: CustomPaint(
                size: Size.infinite,
                painter: painter != null
                    ? CalligraphyPainter(strokes: strokes, painter: painter!)
                    : null,
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        onPressed: _clearCanvas,
                        icon: const Icon(Icons.restore),
                        tooltip: "Reiniciar firma",
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: IconButton(
                        onPressed: () async {
                          final data = await exportSignature();
                          if (data != null) {
                            print("Firma exportada con ${data.length} bytes");
                            widget.onFinish(data);
                            // aquí puedes guardar el Uint8List en archivo o enviarlo
                          }
                        },
                        icon: const Icon(Icons.save),
                        tooltip: "Guardar firma",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
