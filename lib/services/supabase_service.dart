import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  Future<void> initialize(String url, String anonKey) async {
    await Supabase.initialize(url: url, publishableKey: anonKey);
  }

  StorageFileApi get storage => client.storage.from('menu-images');
}
