import '../models/order_model.dart';
import 'customer_service.dart';
import 'supabase_service.dart';

class OrderService {
  final SupabaseService _supabase = SupabaseService();
  final CustomerService _customerService = CustomerService();

  Stream<List<Order>> getOrderStream() {
    return _supabase.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((maps) => maps.map((m) => Order.fromMap(m)).toList())
        .asyncMap((orders) async {
          for (var i = 0; i < orders.length; i++) {
            final oid = orders[i].id;
            if (oid != null) {
              try {
                final itemsData = await _supabase.client
                    .from('order_items')
                    .select()
                    .eq('order_id', oid);
                final items = (itemsData as List)
                    .map((m) => OrderItem.fromMap(m as Map<String, dynamic>))
                    .toList();
                orders[i] = orders[i].copyWithItems(items);
              } catch (_) {}
            }
          }
          return orders;
        });
  }

  Future<String> addOrder(Order order) async {
    try {
      final customer = await _customerService.findOrCreate(
        order.customerName,
        order.customerEmail,
        order.customerPhone,
      );

      final items = order.items.map((item) => item.toMap()).toList();
      final orderMap = order.toMap();
      orderMap.remove('items');
      orderMap['customer_id'] = customer?.id;

      final result = await _supabase.client
          .from('orders')
          .insert(orderMap)
          .select()
          .single();

      final orderId = result['id'] as String;

      for (final item in items) {
        item['order_id'] = orderId;
        await _supabase.client.from('order_items').insert(item);
      }

      final orderNumber = 'ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
      await _supabase.client
          .from('orders')
          .update({'order_number': orderNumber})
          .eq('id', orderId);

      return orderId;
    } catch (e) {
      throw Exception('Gagal menyimpan pesanan: $e');
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await _supabase.client.from('orders').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus pesanan: $e');
    }
  }

  Future<void> updateStatus(String id, String status) async {
    try {
      await _supabase.client
          .from('orders')
          .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    } catch (e) {
      throw Exception('Gagal mengupdate status: $e');
    }
  }

  Future<double> getTodayIncome() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();

      final data = await _supabase.client
          .from('orders')
          .select()
          .inFilter('status', ['Diproses', 'Selesai'])
          .gte('created_at', startOfDay);

      final orders = data as List;
      return orders.fold<double>(
        0,
        (sum, order) => sum + ((order as Map<String, dynamic>)['total_amount'] ?? 0).toDouble(),
      );
    } catch (e) {
      return 0;
    }
  }

  Stream<Map<String, String>> getOccupiedTablesStream() {
    return _supabase.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .map((maps) {
      final occupied = <String, String>{};
      for (final m in maps) {
        final status = m['status'] as String? ?? '';
        final table = m['table_number'] as String? ?? '';
        if (table.isNotEmpty && (status == 'Diproses' || status == 'Selesai')) {
          occupied[table] = status;
        }
      }
      return occupied;
    });
  }

  Future<void> clearTable(String tableNumber) async {
    try {
      await _supabase.client
          .from('orders')
          .update({'table_number': '', 'updated_at': DateTime.now().toIso8601String()})
          .eq('table_number', tableNumber)
          .eq('status', 'Selesai');
    } catch (e) {
      throw Exception('Gagal mengosongkan meja: $e');
    }
  }

  Future<int> getTodayOrderCount() async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();

      final data = await _supabase.client
          .from('orders')
          .select()
          .gte('created_at', startOfDay);

      return (data as List).length;
    } catch (e) {
      return 0;
    }
  }
}
