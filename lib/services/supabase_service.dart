import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<List<String>> uploadImages(List<XFile> images) async {
    List<Future<String>> tasks = images.map((img) => _uploadSingle(img)).toList();
    return await Future.wait(tasks);
  }

  static Future<String> _uploadSingle(XFile image) async {
    String path = 'uploads/${const Uuid().v4()}.jpg';
    Uint8List bytes = await image.readAsBytes();

    if (!kIsWeb) {
      try {
        bytes = await FlutterImageCompress.compressWithList(
          bytes, minHeight: 800, minWidth: 800, quality: 70,
        );
      } catch (e) {}
    }

    await _supabase.storage.from('food_images').uploadBinary(
        path, bytes, fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true)
    );

    return _supabase.storage.from('food_images').getPublicUrl(path);
  }
}