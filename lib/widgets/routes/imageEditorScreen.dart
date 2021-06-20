import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ImageEditorScreen extends StatefulWidget {
  ImageEditorScreen({Key key, final String imageUrl, final File imageFile})
      : this.imageUrl = imageUrl,
        this.imageFile = imageFile,
        super(key: key);
  String imageUrl;
  File imageFile;
  @override
  _ImageEditorScreenState createState() =>
      _ImageEditorScreenState(this.imageUrl, this.imageFile);
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  _ImageEditorScreenState(this._imageUrl, this.imageFile);

  final routesService = locator<RoutesService>();
  final routeColorService = locator<RouteColorService>();
  final controllerRouteName = TextEditingController(text: "");
  final controllerRouteSetter = TextEditingController(text: "");
  final controllerRouteType = TextEditingController(text: "");
  final controllerRouteHolds = TextEditingController(text: "");
  String _imageUrl;
  File imageFile;
  int selectedColorIndex = 0;
  final picker = ImagePicker();

  ui.Image image;
  bool isImageloaded = false;
  GlobalKey _myCanvasKey = new GlobalKey();

  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    image = await loadImage();
  }

  Future<ui.Image> loadImage() async {
    // load image
    File file;
    if (imageFile != null) {
      file = imageFile;
    } else {
      var response = await http.get(Uri.parse(_imageUrl));
      var documentDirectory = await getApplicationDocumentsDirectory();
      file = File(
          join(documentDirectory.path, routesService.currentRoute.value.id));

      file.writeAsBytesSync(response.bodyBytes);
    }
    Uint8List bytes = file.readAsBytesSync();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Widget _buildImage(BuildContext context) {
    ImageEditor editor = ImageEditor(image: image);

    if (this.isImageloaded) {
      double imageRatio = image.height / image.width;
      print(imageRatio);
      return Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.width *
                  imageRatio, //image.height.toDouble(),
              width: MediaQuery.of(context).size.width, //.width.toDouble(),
              child: GestureDetector(
                onPanDown: (detailData) {
                  editor.update(detailData.localPosition);
                  _myCanvasKey.currentContext
                      .findRenderObject()
                      .markNeedsPaint();
                },
                child: CustomPaint(
                  key: _myCanvasKey,
                  painter: editor,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      style: Constants.polyGrayButton,
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child:
                            Text("CANCEL", style: Constants.defaultTextWhite),
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Constants.lightGray,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: () {
                              editor.clear();
                              _myCanvasKey.currentContext
                                  .findRenderObject()
                                  .markNeedsPaint();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CircleAvatar(
                            backgroundColor: Constants.lightGray,
                            child: IconButton(
                              icon: Icon(Icons.undo, color: Colors.white),
                              onPressed: () {
                                editor.undo();
                                _myCanvasKey.currentContext
                                    .findRenderObject()
                                    .markNeedsPaint();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      style: Constants.polyGreenButton,
                      onPressed: () async {
                        var editedFile = await editor.getPng();
                        Navigator.of(context).pop(editedFile);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Text("SAVE", style: Constants.defaultTextWhite),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildImage(context);
  }
}

class ImageEditor extends CustomPainter {
  ImageEditor({
    this.image,
  });

  ui.Image image;
  Canvas _lastCanvas;
  Size _lastSize;

  List<Offset> points = List();

  final Paint painter = new Paint()
    ..color = Colors.red[500]
    ..style = PaintingStyle.fill
    ..isAntiAlias = true
    ..strokeWidth = 10;

  void update(Offset offset) {
    points.add(offset);
  }

  void clear() {
    points.clear();
  }

  void undo() {
    points.removeLast();
  }

  Future<File> getPng() async {
    if (_lastCanvas == null) {
      return null;
    }
    if (_lastSize == null) {
      return null;
    }
    var recorder = new ui.PictureRecorder();
    var origin = new Offset(0.0, 0.0);
    var paintBounds = new Rect.fromPoints(
        _lastSize.topLeft(origin), _lastSize.bottomRight(origin));
    var canvas = new Canvas(recorder, paintBounds);
    paint(canvas, _lastSize);
    var picture = recorder.endRecording();
    var image = await picture.toImage(
        _lastSize.width.round(), _lastSize.height.round());

    ByteData data = await image.toByteData(format: ui.ImageByteFormat.png);
    File myImage = await writeToFile(data);
    return myImage;
  }

  Future<File> writeToFile(ByteData data) async {
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath +
        '/routeimage.png'; // file_01.tmp is dump file, can be anything
    var bufferlist = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return new File(filePath).writeAsBytes(bufferlist);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _lastCanvas = canvas;
    _lastSize = size;
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.width, size.height),
        image: image,
        fit: BoxFit.contain, //BoxFit.scaleDown,
        repeat: ImageRepeat.noRepeat, //ImageRepeat.noRepeat,
        scale: 1.0,
        alignment: Alignment.topCenter,
        flipHorizontally: false,
        filterQuality: FilterQuality.high);
    for (Offset offset in points) {
      final Paint paint = new Paint()
        ..isAntiAlias = true
        ..strokeWidth = 2.0
        ..color = Constants.polyGreen //[500]
        ..style = PaintingStyle.stroke;
      canvas.drawArc(new Rect.fromLTWH(offset.dx - 15, offset.dy - 15, 30, 30),
          10.0, 20.0, false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
