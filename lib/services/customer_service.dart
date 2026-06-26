import '../models/customer_model.dart';
import 'supabase_service.dart';

class CustomerService {
  final SupabaseService _supabase = SupabaseService();

  Future<Customer?> findByEmail(String email) async {
    if (email.isEmpty) return null;
    try {
      final data = await _supabase.client
          .from('customers')
          .select()
          .eq('email', email)
          .maybeSingle();
      if (data == null) return null;
      return Customer.fromMap(data);
    } catch (_) {
      return null;
    }
  }

  Future<Customer> create(Customer customer) async {
    final data = await _supabase.client
        .from('customers')
        .insert(customer.toMap())
        .select()
        .single();
    return Customer.fromMap(data);
  }

  Future<Customer?> findOrCreate(String name, String email, String phone) async {
    if (name.isEmpty && email.isEmpty) return null;
    final existing = await findByEmail(email);
    if (existing != null) return existing;
    return create(Customer(name: name, email: email, phone: phone));
  }
}
