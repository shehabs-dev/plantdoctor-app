import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../../../core/errors/exceptions.dart';

const _kInputSize = 260;
const _kThreshold = 0.65;
const _kOodLabel = 'Unknown Disease';

abstract class TFLiteDataSource {
  Future<void> loadModel();
  Future<List<Map<String, dynamic>>> classify(File image);
  Future<void> closeModel();
}

class TFLiteDataSourceImpl implements TFLiteDataSource {
  TFLiteDataSourceImpl({
    required this.fp16ModelPath,
    required this.int8ModelPath,
    required this.labelPath,
  });

  final String fp16ModelPath;
  final String int8ModelPath;
  final String labelPath;

  Interpreter? _interpreter;
  List<String> _labels = [];

  @override
  Future<void> loadModel() async {
    try {
      final labelData = await rootBundle.loadString(labelPath);
      _labels = labelData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      try {
        final opts = InterpreterOptions()..addDelegate(GpuDelegate());
        _interpreter = await Interpreter.fromAsset(
          fp16ModelPath,
          options: opts,
        );
      } catch (_) {
        _interpreter = await Interpreter.fromAsset(int8ModelPath);
      }

      _runWarmup();
    } catch (e) {
      throw ModelException();
    }
  }

  void _runWarmup() {
    try {
      final dummyInput = [
        List.generate(
          _kInputSize,
          (_) => List.generate(_kInputSize, (_) => [0.0, 0.0, 0.0]),
        ),
      ];
      final dummyOutput = [List<double>.filled(_labels.length, 0.0)];
      _interpreter!.run(dummyInput, dummyOutput);
    } catch (_) {}
  }

  @override
  Future<List<Map<String, dynamic>>> classify(File image) async {
    try {
      if (_interpreter == null || _labels.isEmpty) {
        await loadModel();
      }

      return await compute(_runInference, {
        'interpreterAddress': _interpreter!.address,
        'labels': _labels,
        'imagePath': image.path,
      });
    } catch (e) {
      throw ModelException();
    }
  }

  static Future<List<Map<String, dynamic>>> _runInference(
    Map<String, dynamic> params,
  ) async {
    final int address = params['interpreterAddress'];
    final List<String> labels = params['labels'];
    final String imagePath = params['imagePath'];

    final interpreter = Interpreter.fromAddress(address);

    final bytes = await File(imagePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw Exception('Failed to decode image');

    final resized = img.copyResize(
      decoded,
      width: _kInputSize,
      height: _kInputSize,
    );

    final input = <List<List<List<double>>>>[
      List.generate(
        _kInputSize,
        (y) => List.generate(_kInputSize, (x) {
          final pixel = resized.getPixel(x, y);
          return <double>[
            pixel.r.toDouble(),
            pixel.g.toDouble(),
            pixel.b.toDouble(),
          ];
        }),
      ),
    ];

    final output = <List<double>>[List<double>.filled(labels.length, 0.0)];

    interpreter.run(input, output);

    final probs = output[0];
    final maxIdx = probs.indexOf(probs.reduce(max));
    final confidence = probs[maxIdx];
    final label = confidence >= _kThreshold ? labels[maxIdx] : _kOodLabel;

    return [
      {'label': label, 'confidence': confidence},
    ];
  }

  @override
  Future<void> closeModel() async {
    _interpreter?.close();
    _interpreter = null;
  }
}
