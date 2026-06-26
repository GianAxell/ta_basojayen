import 'supabase_service.dart';

class AuthService {
  final SupabaseService _supabase = SupabaseService();

  Future<bool> login(String username, String password) async {
    try {
      final data = await _supabase.client
          .from('admins')
          .select()
          .eq('username', username)
          .limit(1);

      final list = data as List;
      if (list.isEmpty) return false;

      final admin = list.first as Map<String, dynamic>;
      return admin['password'] == password;
    } catch (e) {
      return false;
    }
  }
}
