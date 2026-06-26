import 'package:image_picker/image_picker.dart';
import '../models/menu_model.dart';
import 'supabase_service.dart';

class MenuService {
  final SupabaseService _supabase = SupabaseService();

  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 800,
    );
  }

  Future<String> uploadImage(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final fileName = 'menu_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _supabase.storage.uploadBinary(fileName, bytes);
      return _supabase.storage.getPublicUrl(fileName);
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  Stream<List<MenuData>> getMenuStream() async* {
    final data = await _supabase.client
        .from('menu_items')
        .select()
        .order('name', ascending: true);
    yield (data as List).map((m) => MenuData.fromMap(m as Map<String, dynamic>)).toList();
  }

  Stream<List<MenuData>> getActiveMenuStream() async* {
    final data = await _supabase.client
        .from('menu_items')
        .select()
        .eq('is_active', true)
        .order('name', ascending: true);
    yield (data as List).map((m) => MenuData.fromMap(m as Map<String, dynamic>)).toList();
  }

  Future<List<MenuData>> getAllMenus() async {
    final data = await _supabase.client
        .from('menu_items')
        .select()
        .order('name', ascending: true);
    return (data as List).map((m) => MenuData.fromMap(m as Map<String, dynamic>)).toList();
  }

  Future<void> addMenu(MenuData menu) async {
    try {
      await _supabase.client.from('menu_items').insert(menu.toMap());
    } catch (e) {
      throw Exception('Gagal menambahkan menu: $e');
    }
  }

  Future<void> updateMenu(String id, MenuData menu) async {
    try {
      final map = menu.toMap();
      map['updated_at'] = DateTime.now().toIso8601String();
      await _supabase.client.from('menu_items').update(map).eq('id', id);
    } catch (e) {
      throw Exception('Gagal mengupdate menu: $e');
    }
  }

  Future<void> toggleActive(String id, bool isActive) async {
    try {
      await _supabase.client
          .from('menu_items')
          .update({'is_active': isActive, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    } catch (e) {
      throw Exception('Gagal mengubah status menu: $e');
    }
  }

  Future<void> deleteMenu(String id) async {
    try {
      await _supabase.client.from('menu_items').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus menu: $e');
    }
  }
}
