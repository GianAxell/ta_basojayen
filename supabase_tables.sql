-- =============================================
-- Baso Jayen POS - Supabase Database Schema
-- Jalankan di SQL Editor Supabase
-- =============================================

-- 1. Tabel admins
CREATE TABLE admins (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Tabel menu_items
CREATE TABLE menu_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  image_path TEXT NOT NULL DEFAULT 'assets/images/paket_a.png',
  name TEXT NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  price TEXT NOT NULL DEFAULT 'Rp. 0',
  price_value INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Tabel customers
CREATE TABLE customers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL DEFAULT '',
  phone TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Tabel orders
CREATE TABLE orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  order_number TEXT NOT NULL DEFAULT '',
  customer_id UUID REFERENCES customers(id),
  customer_name TEXT NOT NULL DEFAULT '',
  customer_email TEXT NOT NULL DEFAULT '',
  customer_phone TEXT NOT NULL DEFAULT '',
  total_amount INTEGER NOT NULL DEFAULT 0,
  payment_method TEXT NOT NULL DEFAULT 'E-Wallet',
  status TEXT NOT NULL DEFAULT 'Diproses',
  table_number TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Tabel order_items
CREATE TABLE order_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  menu_id TEXT NOT NULL DEFAULT '',
  menu_name TEXT NOT NULL DEFAULT '',
  quantity INTEGER NOT NULL DEFAULT 0,
  price_per_item INTEGER NOT NULL DEFAULT 0,
  subtotal INTEGER NOT NULL DEFAULT 0
);

-- Seed data: admin default
INSERT INTO admins (username, password) VALUES ('admin', 'jayen123');

-- Seed data: menu Paket A-J
INSERT INTO menu_items (image_path, name, description, price, price_value, is_active) VALUES
('assets/images/paket_a.png', 'Paket A', 'Mie, Baso urat, Baso daging, Baso tahu, Siomay', 'Rp. 10.000', 10000, TRUE),
('assets/images/paket_b.png', 'Paket B', 'Mie, Baso daging, Baso tahu, Baso aci, Siomay', 'Rp. 10.000', 10000, TRUE),
('assets/images/paket_c.png', 'Paket C', 'Baso daging, Baso urat, Baso tahu, Baso aci, Siomay', 'Rp. 10.000', 10000, TRUE),
('assets/images/paket_d.png', 'Paket D', 'Baso telor, Baso daging, Baso urat, Baso tahu, Siomay, Ceker', 'Rp. 10.000', 10000, TRUE),
('assets/images/paket_e.png', 'Paket E', 'Baso daging, Baso tahu, Siomay, Ceker, Cuanki', 'Rp. 10.000', 10000, TRUE),
('assets/images/paket_f.png', 'Paket F', 'Baso aci 15 PCS', 'Rp. 10.000', 10000, TRUE),
('assets/images/paket_g.png', 'Paket G', 'Mie, Baso daging 2, Baso urat 2', 'Rp. 10.000', 10000, TRUE),
('assets/images/paket_h.png', 'Paket H', 'Soun, Baso daging, Baso tahu, Siomay', 'Rp. 10.000', 10000, TRUE),
('assets/images/paket_i.png', 'Paket I', 'Soun, Baso daging, Baso aci, Baso tahu, Siomay', 'Rp. 10.000', 10000, TRUE),
('assets/images/paket_j.png', 'Paket J', 'Mie, Baso urat, Baso daging, Baso tahu, Baso aci, Ceker, Siomay', 'Rp. 15.000', 15000, TRUE);

-- Enable Row Level Security (biarkan untuk akses publik anon)
-- Untuk development, kita set mode publik
ALTER TABLE admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Policy: allow all operations for anon key (development mode)
CREATE POLICY "Allow all for anon" ON admins FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for anon" ON menu_items FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for anon" ON customers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for anon" ON orders FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for anon" ON order_items FOR ALL USING (true) WITH CHECK (true);

-- =============================================
-- Enable Realtime untuk pesanan real-time
-- Jalankan di SQL Editor Supabase
-- =============================================
ALTER PUBLICATION supabase_realtime ADD TABLE orders;
ALTER PUBLICATION supabase_realtime ADD TABLE order_items;

ALTER TABLE orders REPLICA IDENTITY FULL;
ALTER TABLE order_items REPLICA IDENTITY FULL;
