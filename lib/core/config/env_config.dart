import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized environment configuration.
///
/// This class provides typed access to environment variables defined in the .env file.
class EnvConfig {
  EnvConfig._();

  /// The base URL for the RAG API.
  static String get ragBaseUrl => _get('RAG_BASE_URL');

  /// The Cloudinary cloud name.
  static String get cloudinaryCloudName => _get('CLOUDINARY_CLOUD_NAME');

  /// The base URL for the Cloudinary API.
  static String get cloudinaryApiBaseUrl => _get('CLOUDINARY_API_BASE_URL');

  /// The URL for the Ministry of Agriculture website.
  static String get ministryUrl => _get('MINISTRY_URL');

  // Cloudinary Presets & Folders
  static String get cloudinaryDiseasePreset =>
      _get('CLOUDINARY_DISEASE_PRESET');
  static String get cloudinaryDiseaseFolder =>
      _get('CLOUDINARY_DISEASE_FOLDER');

  static String get cloudinaryProfilePreset =>
      _get('CLOUDINARY_PROFILE_PRESET');
  static String get cloudinaryProfileFolder =>
      _get('CLOUDINARY_PROFILE_FOLDER');

  static String get cloudinaryReportPreset => _get('CLOUDINARY_REPORT_PRESET');
  static String get cloudinaryReportFolder => _get('CLOUDINARY_REPORT_FOLDER');

  // Tflite Model
  static String get tfliteLabelPath => _get('TFLITE_LABEL_PATH');
  static String get tfliteModelFp16Path => _get('TFLITE_MODEL_FP16_PATH');
  static String get tfliteModelInt8Path => _get('TFLITE_MODEL_INT8_PATH');

  // Google Sign-In
  static String get googleClientId => _get('GOOGLE_CLIENT_ID');

  /// Helper to get an environment variable. Throws if missing.
  static String _get(String key) {
    final value = dotenv.maybeGet(key);
    if (value == null || value.isEmpty) {
      if (kDebugMode) {
        print('❌ [EnvConfig] Missing environment variable for key: $key');
      }
      throw Exception(
        'Missing environment variable: $key. '
        'Please ensure it is defined in your .env file.',
      );
    }
    return value;
  }
}
